import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"
import "../"

MusicApplicationMenu {
    signal bluetoothClicked
    signal storageClicked
    signal androidAutoClicked
    signal autoboxClicked
    signal fmRadioClicked

    id: root
    title: qsTr("Music source")

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
        model: ListModel {
            ListElement {
                name: qsTr("Bluetooth")
                iconPath: "/images/ico_bluetooth.svg"
            }

            ListElement {
                name: qsTr("Storage")
                iconPath: "/images/ico_music_library.svg"
            }

            ListElement {
                name: qsTr("Android Auto")
                iconPath: "/images/ico_androidauto.svg"
            }

            ListElement {
                name: qsTr("Autobox")
                iconPath: "/images/ico_autobox.svg"
            }

            ListElement {
                name: qsTr("FM Radio")
                iconPath: "/images/ico_radio.svg"
            }
        }

        cellWidth: (width / 5)
        cellHeight: height / 2.9
        delegate: Item {
            width: view.cellWidth
            height: view.cellHeight

            Tile {
                anchors.centerIn: parent
                width: parent.width * 0.985
                height: parent.height * 0.985
                labelText: model.name
                iconPath: model.iconPath
                order: model.index

                onTriggered: {
                    if (model.index === 0) {
                        bluetoothClicked()
                    } else if (model.index === 1) {
                        storageClicked()
                    } else if (model.index === 2) {
                        androidAutoClicked()
                    } else if (model.index === 3) {
                        autoboxClicked()
                    } else if (model.index === 4) {
                        fmRadioClicked()
                    }
                }
            }
        }
    }
}
