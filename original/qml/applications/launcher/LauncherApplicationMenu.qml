import QtQuick 2.11
import OpenAuto 1.0
import "../../controls"

LauncherApplicationMenu {
    title: qsTr("Applications")
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
        model: ApplicationsController.applicationsModel
        cellWidth: width / 5
        cellHeight: height / 2.9
        delegate: Item {
            width: view.cellWidth
            height: view.cellHeight

            Tile {
                id: applicationDelegate
                anchors.centerIn: parent
                width: parent.width * 0.985
                height: parent.height * 0.985
                labelText: model.modelData
                iconPath: "file://" + model.iconPath
                active: ApplicationsController.isApplicationRunning(model.index)
                colorize: false

                onTriggered: {
                    ApplicationsController.run(model.index)
                }

                Connections {
                    target: ApplicationsController
                    onApplicationStatusChanged: {
                        if (index === model.index) {
                            applicationDelegate.active = running
                        }
                    }
                }
            }
        }
    }
}
