import QtQuick 2.11
import OpenAuto 1.0
import "../controls"

ControlBox {
    signal activeCallClicked
    id: root

    BarIcon {
        id: telephoneIcon
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.05
        height: parent.height * 0.85
        width: height
        anchors.verticalCenter: parent.verticalCenter
        source: "/images/ico_activecall_ongoing_status_no_color.svg"
        colorize: false
        onTriggered: {
            root.activeCallClicked()
        }
    }

    NormalText {
        id: callerIdLabel
        anchors.left: telephoneIcon.right
        anchors.leftMargin: telephoneIcon.width * 0.3
        anchors.right: hangIcon.left
        anchors.rightMargin: telephoneIcon.width * 0.3
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height * 0.9
        scrollableText: VoiceCallController.contactName
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        fontPixelSize: parent.height * 0.42
    }

    BarIcon {
        id: hangIcon
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.05
        height: parent.height * 0.85
        width: height
        anchors.verticalCenter: parent.verticalCenter
        source: "/images/ico_hangcall.svg"
        colorize: false
        onTriggered: {
            VoiceCallController.hangUp()
        }
    }
}
