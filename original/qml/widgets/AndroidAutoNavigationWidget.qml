import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../controls"

Item {
    signal musicSourceClicked
    id: root

    Item {
        anchors.fill: parent
        visible: !NowPlayingController.isMusicActive

        NormalText {
            text: qsTr("No music is playing at the moment.")
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
        visible: NowPlayingController.isMusicActive

        Item {
            id: coverartContainer
            anchors.top: parent.top
            anchors.topMargin: height * 0.25
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.4
            height: width

            ForegroundShape {
                width: parent.height
                height: width

                Image {
                    anchors.centerIn: parent
                    source: "/images/default_cover_art.png"
                    width: parent.width * 0.975
                    height: parent.height * 0.975
                    mipmap: true
                    antialiasing: true
                }

                Image {
                    id: coverImage
                    asynchronous: true
                    anchors.centerIn: parent
                    //source: NowPlayingController.coverArtUrl
                    width: parent.width * 0.975
                    height: parent.height * 0.975
                    mipmap: true
                    antialiasing: true
                    cache: false

                    // Workaround for bug with Android Auto coverarts
                    Component.onCompleted: {
                        coverImage.source = NowPlayingController.coverArtUrl
                    }

                    Connections {
                        target: NowPlayingController

                        onCoverArtUrlChanged: {
                            if (AudioFocusController.gainedStreamId
                                    === AndroidAutoController.audioStreamId) {
                                coverImage.source = ""
                            }

                            coverImage.source = NowPlayingController.coverArtUrl
                        }
                    }
                }
            }
        }

        NormalText {
            id: titleLabel
            anchors.top: coverartContainer.bottom
            anchors.topMargin: height * 0.85
            height: width * 0.075
            width: parent.width
            scrollableText: NowPlayingController.title
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            fontPixelSize: AudioFocusController.gainedStreamId !== RtlSdrFmController.audioStreamId ? width * 0.055 : width * 0.075
        }

        NormalText {
            id: artistLabel
            anchors.top: titleLabel.bottom
            anchors.topMargin: height * 0.5
            height: width * 0.075
            width: parent.width
            scrollableText: NowPlayingController.artist
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            fontPixelSize: width * 0.05
        }

        NormalText {
            id: positionLabel
            anchors.top: artistLabel.bottom
            anchors.topMargin: height * 0.5
            height: width * 0.075
            width: parent.width
            text: NowPlayingController.positionLabel + "/" + NowPlayingController.durationLabel
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            fontPixelSize: width * 0.04
            visible: AudioFocusController.gainedStreamId !== RtlSdrFmController.audioStreamId
        }

        RowLayout {
            id: playbackControlsRow
            anchors.top: positionLabel.bottom
            anchors.topMargin: height * 0.6
            anchors.horizontalCenter: parent.horizontalCenter
            height: width * 0.125
            width: parent.width * 0.9
            spacing: width * 0.025

            BarIcon {
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.height
                Layout.alignment: Qt.AlignHCenter
                source: NowPlayingController.musicSourceIconUrl
                onTriggered: {
                    root.musicSourceClicked()
                }
            }

            BarIcon {
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.height
                Layout.alignment: Qt.AlignHCenter
                source: "/images/ico_previous_white.svg"
                onTriggered: {
                    AudioFocusController.previous()
                }
            }

            BarIcon {
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.height
                Layout.alignment: Qt.AlignHCenter
                source: NowPlayingController.isPlaying ? "/images/ico_pause_white.svg" : "/images/ico_play_white.svg"
                onTriggered: {
                    AudioFocusController.togglePlay()
                }
            }

            BarIcon {
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.height
                Layout.alignment: Qt.AlignHCenter
                source: "/images/ico_next_white.svg"
                onTriggered: {
                    AudioFocusController.next()
                }
            }
        }
    }

    Component.onCompleted: {
        NotificationsController.suspendChannel(
                    StorageMusicController.notificationsChannelId)

        NotificationsController.suspendChannel(
                    A2DPController.notificationsChannelId)

        NotificationsController.suspendChannel(
                    AndroidAutoController.notificationsChannelId)

        NotificationsController.suspendChannel(
                    RtlSdrFmController.notificationsChannelId)
    }

    Component.onDestruction: {
        NotificationsController.resumeChannel(
                    StorageMusicController.notificationsChannelId)

        NotificationsController.resumeChannel(
                    A2DPController.notificationsChannelId)

        NotificationsController.resumeChannel(
                    AndroidAutoController.notificationsChannelId)

        NotificationsController.resumeChannel(
                    RtlSdrFmController.notificationsChannelId)
    }
}
