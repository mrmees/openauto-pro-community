import QtQuick 2.11
import QtQuick.Layouts 1.11
import "../controls"

CustomPopup {
    property alias messageText: messageTextLabel.text

    signal yesClicked
    signal noClicked

    id: root

    NormalText {
        id: messageTextLabel
        fontPixelSize: parent.height * 0.065
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    RowLayout {
        anchors.top: messageTextLabel.bottom
        anchors.topMargin: parent.height * 0.08
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.4
        height: parent.height * 0.13
        spacing: width * 0.1

        CustomButton {
            id: noButton
            Layout.preferredWidth: parent.width * 0.4
            Layout.preferredHeight: parent.height
            labelText: qsTr("No")

            onTriggered: {
                noClicked()
            }
        }

        CustomButton {
            id: yesButton
            Layout.preferredWidth: parent.width * 0.4
            Layout.preferredHeight: parent.height
            labelText: qsTr("Yes")

            onTriggered: {
                yesClicked()
            }
        }
    }
}
