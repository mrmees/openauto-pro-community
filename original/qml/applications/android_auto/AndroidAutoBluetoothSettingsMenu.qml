import QtQuick 2.11
import OpenAuto 1.0
import "../../controls"

SettingsApplicationMenu {
    signal audioSettingsClicked
    signal videoSettingsClicked
    signal bluetoothSettingsClicked
    signal systemSettingsClicked

    id: root
    title: qsTr("Android Auto settings")

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
                        root.audioSettingsClicked()
                    } else if (model.index === 1) {
                        root.videoSettingsClicked()
                    } else if (model.index === 2) {
                        root.bluetoothSettingsClicked()
                    } else if (model.index === 3) {
                        root.systemSettingsClicked()
                    }
                }
            }
        }

        model: ListModel {
            ListElement {
                property string text: qsTr("Audio")
                property string icon: "/images/ico_audio.svg"
            }

            ListElement {
                property string text: qsTr("Video")
                property string icon: "/images/ico_video_settings.svg"
            }

            ListElement {
                property string text: qsTr("Bluetooth")
                property string icon: "/images/ico_bluetooth.svg"
            }

            ListElement {
                property string text: qsTr("System")
                property string icon: "/images/ico_systemsettings.svg"
            }
        }
    }
}
