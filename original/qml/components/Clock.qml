import QtQuick 2.11
import "../controls"

CustomPopup {
    id: root

    NormalText {
        id: messageTextLabel
        text: qsTr("Android Auto is currently unavailable")
        fontPixelSize: parent.height * 0.065
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    CustomButton {
        id: button
        anchors.top: messageTextLabel.bottom
        anchors.topMargin: parent.height * 0.08
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.2
        height: parent.height * 0.125
        labelText: qsTr("OK")

        onTriggered: {
            root.visible = false
        }
    }
}
