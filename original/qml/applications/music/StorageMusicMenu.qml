import QtQuick 2.11
import OpenAuto 1.0
import "../"

ApplicationBase {
    id: root
    rootComponent: musicSourceMenuComponent

    Component {
        id: a2dpMenuComponent

        A2DPMenu {}
    }

    Component {
        id: musicSourceMenuComponent

        MusicSourceMenu {
            onBluetoothClicked: {
                applicationsStack.push(a2dpMenuComponent)
            }

            onStorageClicked: {
                applicationsStack.push(storageMusicMenuComponent)
            }

            onAndroidAutoClicked: {
                applicationsStack.push(androidAutoMusicMenuComponent)
            }

            onAutoboxClicked: {
                applicationsStack.push(autoboxMusicMenuComponent)
            }

            onFmRadioClicked: {
                if (!LicenseController.rtlSdrFmPluginValid
                        || !LicenseController.rtlSdrFmLicenseValid) {
                    applicationsStack.push(rtlSdrFmSetupPluginMenuComponent)
                } else {
                    applicationsStack.push(fmRadioMusicMenuComponent)
                }
            }
        }
    }

    Component {
        id: storageMusicMenuComponent

        StorageMusicMenu {
            onBrowseClicked: {
                applicationsStack.push(browseStorageMenuComponent)
            }

            onListClicked: {
                applicationsStack.push(storageMusicPlaylistMenuComponent)
            }
        }
    }

    Component {
        id: androidAutoMusicMenuComponent

        AndroidAutoMusicMenu {}
    }

    Component {
        id: browseStorageMenuComponent

        BrowseStorageMenu {
            onFileSelected: {
                StorageMusicController.select(path)
                applicationsStack.pop()
            }
        }
    }

    Component {
        id: storageMusicPlaylistMenuComponent

        StorageMusicPlaylistMenu {
            onSelected: {
                applicationsStack.pop()
            }
        }
    }

    Component {
        id: autoboxMusicMenuComponent

        AutoboxMusicMenu {}
    }

    Component {
        id: fmRadioMusicMenuComponent

        FMRadioMenu {
            onListClicked: {
                applicationsStack.push(fmRadioPresetsMenuComponent)
            }
        }
    }

    Component {
        id: fmRadioPresetsMenuComponent

        FMRadioPresetsMenu {
            onSelected: {
                RtlSdrFmController.tuneToFrequency(frequency)
                applicationsStack.pop()
            }
        }
    }

    Component {
        id: rtlSdrFmSetupPluginMenuComponent

        RtlSdrFmSetupPluginMenu {
            onBrowseClicked: {
                applicationsStack.push(rtlSdrFmBrowsePluginFileMenuComponent)
            }

            onEnterSerialNumberClicked: {
                applicationsStack.push(rtlSdrFmEnterSerialNumberMenuComponent)
            }

            onFinishSetupClicked: {
                LicenseController.activateRtlSdrFmLicense()
                root.activateFmRadioMenu()
            }

            Component.onDestruction: {
            }
        }
    }

    Component {
        id: rtlSdrFmBrowsePluginFileMenuComponent

        RtlSdrFmBrowsePluginFileMenu {
            onFileSelected: {
                LicenseController.validateRtlSdrFmPlugin(path)
                applicationsStack.pop()
            }
        }
    }

    Component {
        id: rtlSdrFmEnterSerialNumberMenuComponent

        RtlSdrFmEnterSerialNumberMenu {
            onValidateSerialNumberClicked: {
                validationParams.result = LicenseController.validateRtlSdrFmLicense(
                            validationParams.serialNumber)

                if (validationParams.result) {
                    applicationsStack.pop()
                }
            }
        }
    }

    function activate() {
        applicationsStack.replace(null, rootComponent)
    }

    function activateBluetoothMenu() {
        if (!root.isA2DPMusicMenuActive()) {
            root.activate()
            applicationsStack.push(a2dpMenuComponent)
        }
    }

    function activateStorageMenu() {
        if (!root.isStorageMusicMenuActive()) {
            root.activate()
            applicationsStack.push(storageMusicMenuComponent)
        }
    }

    function activateAndroidAutoMenu() {
        if (!root.isAndroidAutoMusicMenuActive()) {
            root.activate()
            applicationsStack.push(androidAutoMusicMenuComponent)
        }
    }

    function activateAutoboxMenu() {
        if (!root.isAutoboxMusicMenuActive()) {
            root.activate()
            applicationsStack.push(autoboxMusicMenuComponent)
        }
    }

    function activateFmRadioMenu() {
        if (!LicenseController.rtlSdrFmPluginValid
                || !LicenseController.rtlSdrFmLicenseValid) {
            root.activate()
            applicationsStack.replace(null, rtlSdrFmSetupPluginMenuComponent)
        } else if (!root.isFmRadioMusicMenuActive()) {
            root.activate()
            applicationsStack.push(fmRadioMusicMenuComponent)
        }
    }

    function activateCurrentSourceMenu() {
        if (AudioFocusController.gainedStreamId === A2DPController.audioStreamId) {
            root.activateBluetoothMenu()
        } else if (AudioFocusController.gainedStreamId === AndroidAutoController.audioStreamId) {
            root.activateAndroidAutoMenu()
        } else if (AudioFocusController.gainedStreamId === StorageMusicController.audioStreamId) {
            root.activateStorageMenu()
        } else if (AudioFocusController.gainedStreamId === AutoboxController.audioStreamId) {
            root.activateAutoboxMenu()
        } else if (AudioFocusController.gainedStreamId === RtlSdrFmController.audioStreamId) {
            root.activateFmRadioMenu()
        } else {
            root.activate()
        }
    }

    function isA2DPMusicMenuActive() {
        return applicationsStack.currentItem.objectName === "A2DPMenu"
    }

    function isStorageMusicMenuActive() {
        return applicationsStack.currentItem.objectName === "StorageMusicMenu"
    }

    function isAndroidAutoMusicMenuActive() {
        return applicationsStack.currentItem.objectName === "AndroidAutoMusicMenu"
    }

    function isAutoboxMusicMenuActive() {
        return applicationsStack.currentItem.objectName === "AutoboxMusicMenu"
    }

    function isFmRadioMusicMenuActive() {
        return applicationsStack.currentItem.objectName === "FMRadioMenu"
    }
}
