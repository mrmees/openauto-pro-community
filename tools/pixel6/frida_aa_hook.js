/*
 * Frida hook script for Android Auto protobuf interception.
 *
 * Hooks into the AA app's protobuf serialization/deserialization to capture
 * every message with full type information. Also hooks transport-level I/O
 * to correlate messages with AAP channel IDs.
 *
 * Usage (from frida_aa_hook.py wrapper):
 *   frida -U -f com.google.android.projection.gearhead -l frida_aa_hook.js
 *
 * Or attach to running process:
 *   frida -U com.google.android.projection.gearhead -l frida_aa_hook.js
 */

'use strict';

const LOG_PREFIX = '[AA-HOOK]';

// AAP channel names for readable output
const CHANNEL_NAMES = {
    0: 'CONTROL',
    1: 'INPUT',
    2: 'SENSOR',
    3: 'VIDEO',
    4: 'MEDIA_AUDIO',
    5: 'SPEECH_AUDIO',
    6: 'SYSTEM_AUDIO',
    7: 'AV_INPUT',
    8: 'BLUETOOTH',
    9: 'CH9_UNKNOWN',
    10: 'CH10_UNKNOWN',
    11: 'CH11_UNKNOWN',
    12: 'CH12_UNKNOWN',
    13: 'CH13_UNKNOWN',
    14: 'WIFI',
};

// Control message IDs
const CONTROL_MESSAGES = {
    0x0001: 'VERSION_REQUEST',
    0x0002: 'VERSION_RESPONSE',
    0x0003: 'SSL_HANDSHAKE',
    0x0004: 'AUTH_COMPLETE',
    0x0005: 'SERVICE_DISCOVERY_REQUEST',
    0x0006: 'SERVICE_DISCOVERY_RESPONSE',
    0x0007: 'CHANNEL_OPEN_REQUEST',
    0x0008: 'CHANNEL_OPEN_RESPONSE',
    0x000b: 'PING_REQUEST',
    0x000c: 'PING_RESPONSE',
    0x000d: 'NAVIGATION_FOCUS_REQUEST',
    0x000e: 'NAVIGATION_FOCUS_RESPONSE',
    0x000f: 'SHUTDOWN_REQUEST',
    0x0010: 'SHUTDOWN_RESPONSE',
    0x0011: 'VOICE_SESSION_REQUEST',
    0x0012: 'AUDIO_FOCUS_REQUEST',
    0x0013: 'AUDIO_FOCUS_RESPONSE',
};

// Track message counts per channel
const messageCounters = {};

// Configuration
const CONFIG = {
    logPayloadHex: true,       // Log raw payload hex (first N bytes)
    maxPayloadLog: 128,        // Max bytes of payload to log
    logVideoFrames: false,     // Video frames are noisy — off by default
    logAudioFrames: false,     // Audio frames are noisy — off by default
    logProtoFields: true,      // Attempt to log proto field breakdown
    outputFile: null,          // Set to path to also write to file
};

function hexdump(buf, maxLen) {
    const arr = new Uint8Array(buf.slice(0, maxLen || buf.byteLength));
    return Array.from(arr).map(b => ('0' + b.toString(16)).slice(-2)).join(' ');
}

function channelName(id) {
    return CHANNEL_NAMES[id] || `CH${id}_UNKNOWN`;
}

function logMessage(direction, channel, msgId, flags, payload) {
    const ch = channelName(channel);

    // Skip noisy AV data unless configured
    if (!CONFIG.logVideoFrames && channel === 3 && msgId <= 0x0001) return;
    if (!CONFIG.logAudioFrames && (channel >= 4 && channel <= 7) && msgId <= 0x0001) return;

    const isControl = (flags & 0x04) !== 0;
    const encrypted = (flags & 0x08) !== 0;

    let msgName = `0x${msgId.toString(16).padStart(4, '0')}`;
    if (isControl && CONTROL_MESSAGES[msgId]) {
        msgName = CONTROL_MESSAGES[msgId];
    }

    // Track counters
    const key = `${ch}:${msgName}`;
    messageCounters[key] = (messageCounters[key] || 0) + 1;

    const payloadLen = payload ? payload.byteLength : 0;
    let line = `${LOG_PREFIX} ${direction} ch=${ch} msg=${msgName} len=${payloadLen}`;
    if (encrypted) line += ' [ENC]';

    console.log(line);

    if (CONFIG.logPayloadHex && payload && payloadLen > 0 && payloadLen < 4096) {
        console.log(`${LOG_PREFIX}   hex: ${hexdump(payload, CONFIG.maxPayloadLog)}`);
    }

    if (CONFIG.logProtoFields && payload && payloadLen > 2 && payloadLen < 4096) {
        try {
            const fields = parseProtoFields(new Uint8Array(payload));
            if (fields.length > 0) {
                console.log(`${LOG_PREFIX}   fields: ${JSON.stringify(fields)}`);
            }
        } catch (e) {
            // Not valid proto, that's fine
        }
    }
}

function parseProtoFields(data) {
    /* Minimal protobuf field parser — extracts field numbers and wire types */
    const fields = [];
    let pos = 0;
    while (pos < data.length && fields.length < 50) {
        const tag = readVarint(data, pos);
        if (tag === null) break;
        pos = tag.next;

        const fieldNum = tag.value >>> 3;
        const wireType = tag.value & 0x07;

        if (fieldNum === 0 || fieldNum > 10000) break;

        const wireNames = ['VARINT', 'I64', 'LEN', 'SGROUP', 'EGROUP', 'I32'];
        const wt = wireNames[wireType] || `WT${wireType}`;

        switch (wireType) {
            case 0: { // varint
                const v = readVarint(data, pos);
                if (v === null) { pos = data.length; break; }
                pos = v.next;
                fields.push({ f: fieldNum, t: wt, v: v.value });
                break;
            }
            case 1: { // 64-bit
                pos += 8;
                fields.push({ f: fieldNum, t: wt });
                break;
            }
            case 2: { // length-delimited
                const len = readVarint(data, pos);
                if (len === null) { pos = data.length; break; }
                pos = len.next;
                const strBytes = data.slice(pos, pos + len.value);
                pos += len.value;
                // Try to interpret as string
                let strVal = null;
                if (len.value < 200 && len.value > 0) {
                    const allPrintable = Array.from(strBytes).every(b => b >= 0x20 && b < 0x7f);
                    if (allPrintable) {
                        strVal = String.fromCharCode.apply(null, strBytes);
                    }
                }
                fields.push({ f: fieldNum, t: wt, len: len.value, s: strVal });
                break;
            }
            case 5: { // 32-bit
                pos += 4;
                fields.push({ f: fieldNum, t: wt });
                break;
            }
            default:
                pos = data.length; // unknown wire type, bail
        }
    }
    return fields;
}

function readVarint(data, pos) {
    let result = 0;
    let shift = 0;
    while (pos < data.length) {
        const b = data[pos];
        result |= (b & 0x7f) << shift;
        pos++;
        if (!(b & 0x80)) {
            return { value: result >>> 0, next: pos };
        }
        shift += 7;
        if (shift > 35) return null;
    }
    return null;
}


// ========================================================================
// Hook Strategy 1: Native protobuf library hooks
// ========================================================================

function hookNativeProto() {
    console.log(`${LOG_PREFIX} Searching for native protobuf symbols...`);

    // Common protobuf function names in native .so files
    const targets = [
        // libprotobuf full runtime
        '_ZN6google8protobuf11MessageLite14SerializeToStringEPNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE',
        '_ZN6google8protobuf11MessageLite16ParseFromStringERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE',
        // libprotobuf-lite
        '_ZNK6google8protobuf11MessageLite25SerializeToCodedStreamEPNS0_2io17CodedOutputStreamE',
        '_ZN6google8protobuf11MessageLite27MergeFromCodedStreamEPNS0_2io16CodedInputStreamE',
    ];

    // Also try to find transport-level write/read
    const transportTargets = [
        // Java_* JNI functions related to AA
        'Java_com_google_android_apps_auto_sdk',
        'Java_com_google_android_gearhead',
    ];

    Process.enumerateModules().forEach(function(mod) {
        if (mod.name.includes('proto') || mod.name.includes('auto') ||
            mod.name.includes('gearhead') || mod.name.includes('projection') ||
            mod.name.includes('gal')) {
            console.log(`${LOG_PREFIX} Found relevant module: ${mod.name} @ ${mod.base} (${mod.size} bytes)`);

            // Enumerate exports for proto-related symbols
            mod.enumerateExports().forEach(function(exp) {
                if (exp.name.includes('Serialize') || exp.name.includes('Parse') ||
                    exp.name.includes('protobuf') || exp.name.includes('Proto')) {
                    console.log(`${LOG_PREFIX}   Export: ${exp.name} @ ${exp.address}`);
                }
            });
        }
    });
}


// ========================================================================
// Hook Strategy 2: Java-level protobuf hooks
// ========================================================================

function hookJavaProto() {
    console.log(`${LOG_PREFIX} Setting up Java protobuf hooks...`);

    Java.perform(function() {
        // Hook GeneratedMessageLite (proto-lite, most likely for mobile)
        try {
            const MessageLite = Java.use('com.google.protobuf.GeneratedMessageLite');
            console.log(`${LOG_PREFIX} Found GeneratedMessageLite — hooking toByteArray()`);

            MessageLite.toByteArray.implementation = function() {
                const result = this.toByteArray();
                const className = this.getClass().getName();

                // Filter for AA-related proto classes
                if (className.includes('auto') || className.includes('gearhead') ||
                    className.includes('projection') || className.includes('gal') ||
                    className.includes('aap') || className.includes('androidauto')) {
                    console.log(`${LOG_PREFIX} SERIALIZE: ${className} (${result.length} bytes)`);
                    if (result.length < 4096) {
                        const hex = bytesToHex(result);
                        console.log(`${LOG_PREFIX}   hex: ${hex.substring(0, CONFIG.maxPayloadLog * 3)}`);
                    }
                }
                return result;
            };
        } catch (e) {
            console.log(`${LOG_PREFIX} GeneratedMessageLite not found: ${e}`);
        }

        // Hook AbstractMessageLite.parseFrom (full runtime)
        try {
            const AbstractMessage = Java.use('com.google.protobuf.AbstractMessageLite');
            console.log(`${LOG_PREFIX} Found AbstractMessageLite`);
        } catch (e) {
            console.log(`${LOG_PREFIX} AbstractMessageLite not found (expected for lite runtime)`);
        }

        // Hook the AA projection service directly
        hookProjectionService();

        // Hook transport-level I/O
        hookTransportIO();
    });
}

function hookProjectionService() {
    // Try to hook the main AA projection classes
    const classesToTry = [
        'com.google.android.apps.auto.sdk.ProjectionService',
        'com.google.android.gearhead.projection.ProjectionService',
        'com.google.android.apps.auto.sdk.service.ProjectionService',
        'com.google.android.gearhead.telecom.InCallService',
    ];

    classesToTry.forEach(function(className) {
        try {
            const cls = Java.use(className);
            console.log(`${LOG_PREFIX} Found class: ${className}`);

            // List all methods for discovery
            const methods = cls.class.getDeclaredMethods();
            methods.forEach(function(method) {
                const name = method.getName();
                if (name.includes('send') || name.includes('receive') ||
                    name.includes('message') || name.includes('channel') ||
                    name.includes('proto') || name.includes('write') ||
                    name.includes('read') || name.includes('dispatch')) {
                    console.log(`${LOG_PREFIX}   Method: ${name}(${method.getParameterTypes().map(t => t.getName()).join(', ')})`);
                }
            });
        } catch (e) {
            // Class not found, that's expected for most
        }
    });
}

function hookTransportIO() {
    // Hook OutputStream.write and InputStream.read at the socket level
    // to capture raw AAP frames
    try {
        const Socket = Java.use('java.net.Socket');
        const origGetOutputStream = Socket.getOutputStream;

        Socket.getOutputStream.implementation = function() {
            const stream = origGetOutputStream.call(this);
            const remoteAddr = this.getRemoteSocketAddress();
            const addr = remoteAddr ? remoteAddr.toString() : 'unknown';

            // Only hook if this looks like an AA connection (port 5277 or the HU's TCP port)
            if (addr.includes(':5277') || addr.includes(':5288') || addr.includes('10.0.0.1')) {
                console.log(`${LOG_PREFIX} AA socket output stream detected: ${addr}`);
                return hookOutputStream(stream, 'TX');
            }
            return stream;
        };

        Socket.getInputStream.implementation = function() {
            const stream = origGetOutputStream.call(this);
            const remoteAddr = this.getRemoteSocketAddress();
            const addr = remoteAddr ? remoteAddr.toString() : 'unknown';

            if (addr.includes(':5277') || addr.includes(':5288') || addr.includes('10.0.0.1')) {
                console.log(`${LOG_PREFIX} AA socket input stream detected: ${addr}`);
                return hookInputStream(stream, 'RX');
            }
            return stream;
        };
    } catch (e) {
        console.log(`${LOG_PREFIX} Socket hooking failed: ${e}`);
    }
}

function hookOutputStream(stream, direction) {
    const OutputStream = Java.use('java.io.OutputStream');
    const wrapper = Java.cast(stream, OutputStream);

    // Hook write(byte[]) and write(byte[], int, int)
    // These will capture raw AAP frames
    const origWrite = wrapper.write.overload('[B', 'int', 'int');
    wrapper.write.overload('[B', 'int', 'int').implementation = function(buf, off, len) {
        if (len >= 2) {
            const bytes = Java.array('byte', buf);
            const channelId = bytes[off] & 0xFF;
            const flags = bytes[off + 1] & 0xFF;

            if (channelId <= 14 && len > 4) {
                // Parse message ID from after the frame header + size
                const frameType = flags & 0x03;
                let headerLen = (frameType === 1) ? 8 : 4; // FIRST=8, others=4
                if (off + headerLen + 2 <= off + len) {
                    const msgId = ((bytes[off + headerLen] & 0xFF) << 8) | (bytes[off + headerLen + 1] & 0xFF);
                    const payload = buf.slice(off + headerLen + 2, off + len);
                    logMessage(direction, channelId, msgId, flags, payload);
                }
            }
        }
        return origWrite.call(this, buf, off, len);
    };

    return wrapper;
}

function hookInputStream(stream, direction) {
    // Similar to output but for incoming data
    // The actual parsing happens in a read buffer, so this is trickier
    // For now, just log that we detected the connection
    return stream;
}

function bytesToHex(bytes) {
    const result = [];
    for (let i = 0; i < bytes.length && i < CONFIG.maxPayloadLog; i++) {
        result.push(('0' + (bytes[i] & 0xFF).toString(16)).slice(-2));
    }
    return result.join(' ');
}


// ========================================================================
// Hook Strategy 3: Enumerate all AA-related classes for discovery
// ========================================================================

function discoverAAClasses() {
    console.log(`${LOG_PREFIX} Discovering AA-related classes...`);

    Java.perform(function() {
        Java.enumerateLoadedClasses({
            onMatch: function(className) {
                if (className.includes('gearhead') || className.includes('projection.') ||
                    className.includes('androidauto') || className.includes('.auto.sdk') ||
                    className.includes('.gal.')) {
                    // Filter out inner classes for cleaner output
                    if (!className.includes('$') || className.includes('$1')) {
                        console.log(`${LOG_PREFIX} CLASS: ${className}`);
                    }
                }
            },
            onComplete: function() {
                console.log(`${LOG_PREFIX} Class discovery complete.`);
            }
        });
    });
}


// ========================================================================
// Summary and stats command
// ========================================================================

function printStats() {
    console.log(`\n${LOG_PREFIX} === Message Statistics ===`);
    const sorted = Object.entries(messageCounters).sort((a, b) => b[1] - a[1]);
    sorted.forEach(([key, count]) => {
        console.log(`${LOG_PREFIX}   ${key}: ${count}`);
    });
    console.log(`${LOG_PREFIX} === End Statistics ===\n`);
}

// Export for interactive use
rpc.exports = {
    stats: printStats,
    discover: discoverAAClasses,
    config: function(key, value) {
        if (key in CONFIG) {
            CONFIG[key] = value;
            console.log(`${LOG_PREFIX} Config: ${key} = ${value}`);
        }
    },
};


// ========================================================================
// Main — start all hooks
// ========================================================================

console.log(`${LOG_PREFIX} ====================================`);
console.log(`${LOG_PREFIX} Android Auto Protocol Interceptor`);
console.log(`${LOG_PREFIX} ====================================`);

// Run native hooks first (before Java is fully loaded)
hookNativeProto();

// Wait for Java runtime, then hook Java layer
Java.perform(function() {
    console.log(`${LOG_PREFIX} Java runtime ready, setting up hooks...`);
    hookJavaProto();
    console.log(`${LOG_PREFIX} Hooks installed. Start Android Auto to capture messages.`);
    console.log(`${LOG_PREFIX} Use rpc.exports.stats() for message statistics.`);
    console.log(`${LOG_PREFIX} Use rpc.exports.discover() to list AA classes.`);
});
