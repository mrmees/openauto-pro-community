import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../../controls"
import "../../components"

TelephoneApplicationMenu {
    signal contactSelected(string name, string number)
    property alias model: view.model

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

    Tile {
        anchors.centerIn: parent
        visible: TelephonyController.resyncContactsNeeded
        width: (parent.width / 5) * 0.99
        height: (parent.height / 2.9) * 0.99
        labelText: qsTr("Refresh")
        iconPath: "/images/ico_resume.svg"
        onTriggered: {
            TelephonyController.resyncContacts()
        }
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
        visible: !TelephonyController.resyncContactsNeeded
        cellWidth: (width / 2) - (scrollBar.width / 2.5)
        cellHeight: height / 6

        delegate: Item {
            width: view.cellWidth
            height: view.cellHeight

            ContactEntry {
                id: applicationDelegate
                anchors.centerIn: parent
                width: parent.width * 0.95
                height: parent.height * 0.95
                name: model.modelData
                number: model.number
                order: model.index
                onTriggered: {
                    contactSelected(model.modelData, model.number)
                }
            }
        }

        ScrollBar.vertical: CustomScrollBar {
            id: scrollBar
            active: true
            visible: view.count > 12
            anchors.top: parent.top
        }
    }
}
