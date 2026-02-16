import QtQuick 2.11
import OpenAuto 1.0
import "../../controls"

AndroidAutoApplicationMenu {
    signal addressSelected(string address)

    id: root
    title: qsTr("Recent Android Auto connections")

    onMoveToNextControl: {
        listView.incrementCurrentIndex()
    }

    onMoveToPreviousControl: {
        listView.decrementCurrentIndex()
    }

    ListView {
        id: listView
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.bottom: parent.bottom
        width: parent.width * 0.5
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: height * 0.01

        model: AndroidAutoController.recentAddressesModel
        delegate: ListItemButton {
            id: element
            width: listView.width
            height: listView.height / 7
            text: model.modelData
            order: model.index

            onTriggered: {
                root.addressSelected(text)
            }
        }
    }
}
