import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../../controls"
import "../../components"
import "../"

TelephoneApplicationMenu {
    signal entrySelected(string name, string number)

    id: root
    title: qsTr("Call history")

    onMoveToNextControl: {
        view.incrementCurrentIndex()
    }

    onMoveToPreviousControl: {
        view.decrementCurrentIndex()
    }

    onActivated: {
        view.currentIndex = 0
        view.positionViewAtBeginning()
    }

    ListView {
        id: view
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.bottom: parent.bottom
        model: VoiceCallController.callHistoryModel

        delegate: Item {
            width: view.width
            height: view.height / 6

            CallHistoryEntry {
                id: applicationDelegate
                anchors.centerIn: parent
                width: parent.width * 0.8
                height: parent.height * 0.95
                name: model.modelData
                dateTime: model.dateTime
                number: model.number
                order: model.index
                type: model.type
                onTriggered: {
                    entrySelected(model.modelData, model.number)
                }
            }
        }

        ScrollBar.vertical: CustomScrollBar {
            id: scrollBar
            active: true
            visible: view.count > 6
            anchors.top: parent.top
        }
    }
}
