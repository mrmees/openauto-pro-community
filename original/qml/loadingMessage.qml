import QtQuick 2.11
import OpenAuto 1.0
import "../controls"

CustomPopup {
    LoadingMessage {
        id: loadingMessage
        width: parent.width * 0.31
        height: parent.height * 0.285
        anchors.centerIn: parent
        messageText: qsTr("Connecting...")
    }

    CustomButton {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: loadingMessage.bottom
        anchors.topMargin: parent.height * 0.0325
        width: parent.width * 0.2
        height: parent.height * 0.125
        labelText: qsTr("Cancel")

        onTriggered: {
            AndroidAutoController.cancelConnect()
        }
    }
}
