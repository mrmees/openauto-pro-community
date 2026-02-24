/*
 * Remove BlueZ core SDP records that have 128-bit UUID encoding
 * Android's SDP parser can't handle (UUID size mismatch bug).
 * Then register a clean AA Wireless SDP record with properly
 * encoded 16-bit UUIDs.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/sdp.h>
#include <bluetooth/sdp_lib.h>

int main() {
    bdaddr_t any = {{0}};
    bdaddr_t local = {{0,0,0,0xff,0xff,0xff}};
    sdp_session_t *session = sdp_connect(&any, &local, SDP_RETRY_IF_BUSY);
    if (!session) {
        fprintf(stderr, "sdp_connect failed: %s\n", strerror(errno));
        return 1;
    }

    /* Try to remove core records 0x10000-0x10003 (PnP, GAP, GATT, DevInfo)
     * These have UUIDs encoded as 128-bit which Android rejects */
    for (uint32_t h = 0x10000; h <= 0x10003; h++) {
        sdp_record_t rec;
        memset(&rec, 0, sizeof(rec));
        rec.handle = h;
        if (sdp_device_record_unregister_binary(session, &local, h) == 0) {
            printf("Removed record 0x%x\n", h);
        } else {
            printf("Could not remove 0x%x: %s (trying sdp_record_unregister)\n", h, strerror(errno));
            rec.handle = h;
            if (sdp_record_unregister(session, &rec) == 0) {
                printf("  -> removed via sdp_record_unregister\n");
            } else {
                printf("  -> also failed: %s\n", strerror(errno));
            }
        }
    }

    /* Now register our AA record */
    sdp_record_t *record = sdp_record_alloc();

    /* AA UUID: 4de17a00-52cb-11e6-bdf4-0800200c9a66 */
    uint128_t uuid128 = {{
        0x4d,0xe1,0x7a,0x00, 0x52,0xcb,0x11,0xe6,
        0xbd,0xf4,0x08,0x00, 0x20,0x0c,0x9a,0x66
    }};
    uuid_t aa_uuid;
    sdp_uuid128_create(&aa_uuid, &uuid128);

    /* ServiceClassIDList = [AA UUID] only — no SPP.
     * Android's SDP parser rejects records where UUID sizes are mixed
     * (128-bit AA UUID + 16-bit SPP triggers "invalid length for discovery attribute") */
    sdp_list_t *cls = sdp_list_append(NULL, &aa_uuid);
    sdp_set_service_classes(record, cls);

    /* ProtocolDescriptorList: L2CAP + RFCOMM ch 8 */
    uuid_t l2cap, rfcomm;
    sdp_uuid16_create(&l2cap, L2CAP_UUID);
    sdp_uuid16_create(&rfcomm, RFCOMM_UUID);

    sdp_list_t *l2cap_list = sdp_list_append(NULL, &l2cap);

    uint8_t channel = 8;
    sdp_data_t *ch_data = sdp_data_alloc(SDP_UINT8, &channel);
    sdp_list_t *rfcomm_list = sdp_list_append(NULL, &rfcomm);
    rfcomm_list = sdp_list_append(rfcomm_list, ch_data);

    sdp_list_t *proto = sdp_list_append(NULL, l2cap_list);
    proto = sdp_list_append(proto, rfcomm_list);

    sdp_list_t *access = sdp_list_append(NULL, proto);
    sdp_set_access_protos(record, access);

    /* BrowseGroupList */
    uuid_t browse;
    sdp_uuid16_create(&browse, PUBLIC_BROWSE_GROUP);
    sdp_list_t *browse_list = sdp_list_append(NULL, &browse);
    sdp_set_browse_groups(record, browse_list);

    /* No ProfileDescriptorList — SPP profile descriptor has 16-bit UUID
     * which triggers Android's "invalid length" bug when mixed with 128-bit AA UUID */

    /* ServiceName */
    sdp_set_info_attr(record, "Android Auto Wireless", NULL, NULL);

    if (sdp_record_register(session, record, 0) < 0) {
        fprintf(stderr, "sdp_record_register failed: %s\n", strerror(errno));
        sdp_record_free(record);
        sdp_close(session);
        return 1;
    }

    printf("AA SDP record registered, handle=0x%x\n", record->handle);

    /* Free lists */
    sdp_data_free(ch_data);
    sdp_list_free(cls, NULL);
    sdp_list_free(l2cap_list, NULL);
    sdp_list_free(rfcomm_list, NULL);
    sdp_list_free(proto, NULL);
    sdp_list_free(access, NULL);
    sdp_list_free(browse_list, NULL);
    sdp_record_free(record);

    printf("SDP session open. Keeping alive...\n");
    fflush(stdout);
    while(1) sleep(3600);
    return 0;
}
