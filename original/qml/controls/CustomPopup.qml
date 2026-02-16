import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../controls"

ControlBox {
    signal musicSourceClicked

    id: root

    BarIcon {
        id: sourceIcon
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.05
        anchors.verticalCenter: parent.verticalCenter
        width: parent.height * 0.85
        height: width
        source: NowPlayingController.musicSourceIconUrl

        onTriggered: {
            root.musicSourceClicked()
        }
    }

    RowLayout {
        property real itemWidth: width / 3

        id: playbackControlsRow
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.05
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.05
        anchors.left: sourceIcon.right
        anchors.leftMargin: parent.width * 0.1
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.01
        spacing: width * 0.025

        BarIcon {
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: playbackControlsRow.itemWidth
            Layout.fillWidth: true
            source: "/images/ico_previous_white.svg"
            onTriggered: {
                AudioFocusController.previous()
            }
        }

        BarIcon {
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: playbackControlsRow.itemWidth
            Layout.fillWidth: true
            source: NowPlayingController.isPlaying ? "/images/ico_pause_white.svg" : "/images/ico_play_white.svg"
            onTriggered: {
                AudioFocusController.togglePlay()
            }
        }

        BarIcon {
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: playbackControlsRow.itemWidth
            Layout.fillWidth: true
            source: "/images/ico_next_white.svg"
            onTriggered: {
                AudioFocusController.next()
            }
        }
    }
}
