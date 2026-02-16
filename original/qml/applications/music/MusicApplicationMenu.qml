import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"
import "../"

MusicApplicationMenu {
    id: root
    title: qsTr("Bluetooth music")
    objectName: "A2DPMenu"

    Item {
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.095
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.095

        ControlBackground {
            radius: height * 0.05
        }

        Item {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: playbackControlsContainer.top

            Item {
                id: coverartContainer
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.1
                anchors.left: parent.left
                anchors.leftMargin: parent.height * 0.1
                width: parent.width * 0.25

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
                        source: A2DPController.coverArtUrl
                        width: parent.width * 0.975
                        height: parent.height * 0.975
                        mipmap: true
                        antialiasing: true
                        cache: false
                    }
                }
            }

            Item {
                id: trackInfoContainer

                anchors.top: coverartContainer.top
                anchors.bottom: coverartContainer.bottom
                anchors.bottomMargin: parent.height * 0.15
                anchors.left: coverartContainer.right
                anchors.leftMargin: parent.width * 0.04
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.04

                ColumnLayout {
                    anchors.fill: parent
                    spacing: parent.height * 0.05

                    NormalText {
                        id: titleLabel
                        scrollableText: A2DPController.title
                        fontPixelSize: parent.height * 0.125
                        elide: Text.ElideRight
                        Layout.preferredWidth: parent.width
                    }

                    NormalText {
                        id: artistLabel
                        scrollableText: A2DPController.artist
                        fontPixelSize: parent.height * 0.105
                        elide: Text.ElideRight
                        Layout.preferredWidth: parent.width
                    }

                    NormalText {
                        id: albumLabel
                        scrollableText: A2DPController.album
                        fontPixelSize: parent.height * 0.105
                        elide: Text.ElideRight
                        Layout.preferredWidth: parent.width
                    }

                    Item {
                        Layout.preferredWidth: parent.width * 0.75
                        Layout.preferredHeight: parent.height * 0.2

                        SimpleSlider {
                            id: seekSlider
                            anchors.fill: parent
                            from: 0
                            to: A2DPController.duration
                            readOnly: true
                            stepSize: 1000
                            active: false

                            Component.onCompleted: {
                                seekSlider.value = A2DPController.position
                            }
                        }

                        NormalText {
                            id: positionLabel
                            anchors.left: seekSlider.left
                            anchors.top: seekSlider.bottom
                            text: A2DPController.positionLabel
                            fontPixelSize: parent.height * 0.45

                            Component.onCompleted: {
                                positionLabel.text = A2DPController.positionLabel
                            }
                        }

                        NormalText {
                            anchors.right: seekSlider.right
                            anchors.top: seekSlider.bottom
                            text: A2DPController.durationLabel
                            fontPixelSize: parent.height * 0.45
                        }

                        Connections {
                            target: A2DPController
                            onPositionChanged: {
                                seekSlider.value = A2DPController.position
                                positionLabel.text = A2DPController.positionLabel
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: playbackControlsContainer
            height: parent.height * 0.225
            anchors.bottom: parent.bottom
            width: parent.width

            GradientLine {
                id: divider
                anchors.top: parent.top
                width: parent.width * 0.8
                height: parent.height * 0.03
                anchors.horizontalCenter: parent.horizontalCenter
                startColor: "transparent"
                endColor: ThemeController.controlForegroundColor
            }

            RowLayout {
                property int buttonWidth: height * 0.8
                property int buttonHeight: height * 0.8

                id: playbackControlsRow
                anchors.top: divider.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.4
                spacing: width * 0.025

                BarIcon {
                    Layout.preferredHeight: parent.buttonHeight
                    Layout.preferredWidth: parent.buttonWidth
                    Layout.alignment: Qt.AlignHCenter
                    source: "/images/ico_previous_white.svg"
                    onTriggered: {
                        A2DPController.previous()
                    }
                }

                Item {
                    Layout.preferredHeight: parent.buttonHeight
                    Layout.preferredWidth: parent.buttonWidth
                    Layout.alignment: Qt.AlignHCenter
                }

                BarIcon {
                    Layout.preferredHeight: parent.buttonHeight
                    Layout.preferredWidth: parent.buttonWidth
                    Layout.alignment: Qt.AlignHCenter
                    source: A2DPController.isPlaying ? "/images/ico_pause_white.svg" : "/images/ico_play_white.svg"
                    onTriggered: {
                        A2DPController.togglePlay()
                    }
                }

                Item {
                    Layout.preferredHeight: parent.buttonHeight
                    Layout.preferredWidth: parent.buttonWidth
                    Layout.alignment: Qt.AlignHCenter
                }

                BarIcon {
                    Layout.preferredHeight: parent.buttonHeight
                    Layout.preferredWidth: parent.buttonWidth
                    Layout.alignment: Qt.AlignHCenter
                    source: "/images/ico_next_white.svg"
                    onTriggered: {
                        A2DPController.next()
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        NotificationsController.suspendChannel(
                    A2DPController.notificationsChannelId)
    }

    Component.onDestruction: {
        NotificationsController.resumeChannel(
                    A2DPController.notificationsChannelId)
    }
}
