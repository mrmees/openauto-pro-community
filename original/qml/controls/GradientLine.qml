import QtQuick 2.11
import QtQuick.Controls 2.4

Item {
    property alias messageText: messageTextLabel.text
    property alias fontPixelSize: messageTextLabel.fontPixelSize

    id: root

    NormalText {
        id: messageTextLabel
        anchors.top: parent.top
        height: parent.height * 0.5
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter
        fontPixelSize: height * 0.5
    }

    ProgressBar {
        indeterminate: true
        anchors.top: messageTextLabel.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
