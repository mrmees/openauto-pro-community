import QtQuick 2.11
import OpenAuto 1.0
import "../../controls"

SettingsApplicationMenu {
    signal androidAutoSettingsClicked
    signal audioSettingsClicked
    signal systemSettingsClicked
    signal appearanceSettingsClicked
    signal mirroringSettingsClicked
    signal dayNightSettingsClicked
    signal wallpaperSettingsClicked
    signal rearCameraSettingsClicked
    signal wirelessSettingsClicked
    signal volumeSettingsClicked
    signal languageSettingsClicked
    signal gestureSettingsClicked
    signal colorSettingsClicked
    signal autoboxSettingsClicked
    signal versionClicked

    id: root
    title: qsTr("Settings")

    onMoveToNextControl: {
        view.moveCurrentIndexRight()
    }

    onMoveToPreviousControl: {
        view.moveCurrentIndexLeft()
    }

    onActivated: {
        view.currentIndex = 0
        view.positionViewAtBeginning()
    }

    GridView {
        id: view
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.bottom: parent.bottom
        cellWidth: width / 5
        cellHeight: height / 2.9
        delegate: Item {
            width: view.cellWidth
            height: view.cellHeight

            Tile {
                id: delegate
                anchors.centerIn: parent
                width: parent.width * 0.985
                height: parent.height * 0.985

                labelText: model.text
                iconPath: model.icon
                order: model.index
                onTriggered: {
                    if (model.index === 0) {
                        root.androidAutoSettingsClicked()
                    } else if (model.index === 1) {
                        root.audioSettingsClicked()
                    } else if (model.index === 2) {
                        root.systemSettingsClicked()
                    } else if (model.index === 3) {
                        root.appearanceSettingsClicked()
                    } else if (model.index === 4) {
                        root.mirroringSettingsClicked()
                    } else if (model.index === 5) {
                        root.dayNightSettingsClicked()
                    } else if (model.index === 6) {
                        root.wallpaperSettingsClicked()
                    } else if (model.index === 7) {
                        root.rearCameraSettingsClicked()
                    } else if (model.index === 8) {
                        root.volumeSettingsClicked()
                    } else if (model.index === 9) {
                        root.wirelessSettingsClicked()
                    } else if (model.index === 10) {
                        root.languageSettingsClicked()
                    } else if (model.index === 11) {
                        root.gestureSettingsClicked()
                    } else if (model.index === 12) {
                        root.colorSettingsClicked()
                    } else if (model.index === 13) {
                        root.autoboxSettingsClicked()
                    } else if (model.index === 14) {
                        root.versionClicked()
                    }
                }
            }
        }

        model: ListModel {
            ListElement {
                property string text: qsTr("Android Auto")
                property string icon: "/images/ico_androidauto.svg"
            }

            ListElement {
                property string text: qsTr("Audio")
                property string icon: "/images/ico_audio.svg"
            }

            ListElement {
                property string text: qsTr("System")
                property string icon: "/images/ico_systemsettings.svg"
            }

            ListElement {
                property string text: qsTr("Appearance")
                property string icon: "/images/ico_appearance.svg"
            }

            ListElement {
                property string text: qsTr("Mirroring")
                property string icon: "/images/ico_mirroring.svg"
            }

            ListElement {
                property string text: qsTr("Day/Night")
                property string icon: "/images/ico_daynight.svg"
            }

            ListElement {
                property string text: qsTr("Wallpaper")
                property string icon: "/images/ico_wallpaper.svg"
            }

            ListElement {
                property string text: qsTr("Rear camera")
                property string icon: "/images/ico_rear_camera.svg"
            }

            ListElement {
                property string text: qsTr("Volume")
                property string icon: "/images/ico_volume.svg"
            }

            ListElement {
                property string text: qsTr("Wireless")
                property string icon: "/images/ico_wifi.svg"
            }

            ListElement {
                property string text: qsTr("Language")
                property string icon: "/images/ico_language.svg"
            }

            ListElement {
                property string text: qsTr("Gestures")
                property string icon: "/images/ico_gesture.svg"
            }

            ListElement {
                property string text: qsTr("Colors")
                property string icon: "/images/ico_pallete.svg"
            }

            ListElement {
                property string text: qsTr("Autobox")
                property string icon: "/images/ico_autobox.svg"
            }

            ListElement {
                property string text: qsTr("Version")
                property string icon: "/images/ico_version.svg"
            }
        }
    }
}
