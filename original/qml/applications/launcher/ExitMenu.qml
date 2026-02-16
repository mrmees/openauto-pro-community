import QtQuick 2.11
import OpenAuto 1.0
import "../../controls"

AutoboxApplicationMenu {
    signal resumeClicked
    signal infoClicked

    title: qsTr("Connected to Autobox")
    id: root

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
                name: qsTr("Resume")
                iconPath: "/images/ico_resume.svg"
            }

            ListElement {
                name: qsTr("Info")
                iconPath: "/images/ico_info.svg"
            }
        }

        cellWidth: width / 5
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
                        resumeClicked()
                    } else if (model.index === 1) {
                        infoClicked()
                    }
                }
            }
        }
    }
}
