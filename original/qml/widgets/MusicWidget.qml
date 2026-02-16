import QtQuick 2.11
import OpenAuto 1.0
import "../controls"

Item {
    signal activeCallClicked

    id: root

    Item {
        anchors.fill: parent
        visible: VoiceCallController.callState !== CallState.ACTIVE

        NormalText {
            text: qsTr("No active call at the moment.")
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.95
            height: parent.height
            font.italic: true
            fontPixelSize: width * 0.05
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }
    }

    Item {
        anchors.fill: parent
        visible: VoiceCallController.callState === CallState.ACTIVE

        BarIcon {
            id: icon
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.2
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.3
            height: width
            source: "/images/ico_activecall_ongoing_status_no_color.svg"
            colorize: false
            onTriggered: {
                root.activeCallClicked()
            }
        }

        NormalText {
            id: label
            anchors.top: icon.bottom
            anchors.topMargin: icon.width * 0.3
            height: width * 0.1
            width: parent.width
            scrollableText: VoiceCallController.contactName
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            fontPixelSize: width * 0.07
        }

        BarIcon {
            id: hangIcon
            anchors.top: label.bottom
            anchors.topMargin: parent.width * 0.1
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.15
            height: width
            source: "/images/ico_hangcall.svg"
            colorize: false
            onTriggered: {
                VoiceCallController.hangUp()
            }
        }
    }
}
