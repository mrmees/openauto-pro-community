import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"
import "../"

MusicApplicationMenu {
    signal listClicked

    id: root
    title: qsTr("FM Radio")
    defaultControl: listButton
    objectName: "FMRadioMenu"

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
                }
            }

            Item {
                anchors.top: coverartContainer.top
                anchors.bottom: coverartContainer.bottom
                anchors.left: coverartContainer.right
                anchors.leftMargin: parent.width * 0.04
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.04

                ColumnLayout {
                    anchors.fill: parent
                    spacing: parent.height * 0.05

                    NormalText {
                        id: titleLabel
                        font.bold: true
                        scrollableText: RtlSdrFmController.title
                        fontPixelSize: parent.height * 0.15
                        elide: Text.ElideRight
                        Layout.preferredWidth: parent.width
                    }

                    Item {
                        Layout.preferredWidth: parent.width * 0.75
                        Layout.preferredHeight: parent.height * 0.7

                        GridLayout {

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

                anchors.top: divider.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: divider.width * 0.95
                spacing: width * 0.025

                BarIcon {
                    id: listButton
                    Layout.preferredHeight: parent.buttonHeight
                    Layout.preferredWidth: parent.buttonWidth
                    Layout.alignment: Qt.AlignHCenter
                    source: "/images/ico_music_list.svg"
                    onTriggered: {
                        if (!RtlSdrFmController.scanActive) {
                            root.listClicked()
                        }
                    }
                }

                BarIcon {
                    Layout.preferredHeight: parent.buttonHeight
                    Layout.preferredWidth: parent.buttonWidth
                    Layout.alignment: Qt.AlignHCenter
                    source: "/images/ico_fast_rewind.svg"
                    onTriggered: {
                        RtlSdrFmController.startBackwardScan()
                    }
                }

                BarIcon {
                    Layout.preferredHeight: parent.buttonHeight
                    Layout.preferredWidth: parent.buttonWidth
                    Layout.alignment: Qt.AlignHCenter
                    source: "/images/ico_step_back.svg"
                    onTriggered: {
                        RtlSdrFmController.stepBackward()
                    }
                }

                BarIcon {
                    Layout.preferredHeight: parent.buttonHeight
                    Layout.preferredWidth: parent.buttonWidth
                    Layout.alignment: Qt.AlignHCenter
                    source: "/images/ico_previous_white.svg"
                    onTriggered: {
                        RtlSdrFmController.previous()
                    }
                }

                BarIcon {
                    Layout.preferredHeight: parent.buttonHeight
                    Layout.preferredWidth: parent.buttonWidth
                    Layout.alignment: Qt.AlignHCenter
                    source: RtlSdrFmController.isPlaying ? "/images/ico_pause_white.svg" : "/images/ico_play_white.svg"
                    onTriggered: {
                        RtlSdrFmController.togglePlay()
                    }
                }

                BarIcon {
                    Layout.preferredHeight: parent.buttonHeight
                    Layout.preferredWidth: parent.buttonWidth
                    Layout.alignment: Qt.AlignHCenter
                    source: "/images/ico_next_white.svg"
                    onTriggered: {
                        RtlSdrFmController.next()
                    }
                }

                BarIcon {
                    Layout.preferredHeight: parent.buttonHeight
                    Layout.preferredWidth: parent.buttonWidth
                    Layout.alignment: Qt.AlignHCenter
                    source: "/images/ico_step_forward.svg"
                    onTriggered: {
                        RtlSdrFmController.stepForward()
                    }
                }

                BarIcon {
                    Layout.preferredHeight: parent.buttonHeight
                    Layout.preferredWidth: parent.buttonWidth
                    Layout.alignment: Qt.AlignHCenter
                    source: "/images/ico_fast_forward.svg"
                    onTriggered: {
                        RtlSdrFmController.startForwardScan()
                    }
                }

                BarIcon {
                    id: favoritesButton
                    Layout.preferredHeight: parent.buttonHeight
                    Layout.preferredWidth: parent.buttonWidth
                    Layout.alignment: Qt.AlignHCenter
                    source: RtlSdrFmController.hasPreset(
                                RtlSdrFmController.currentFrequency) ? "/images/ico_favorites.svg" : "/images/ico_favorites_inactive.svg"
                    onTriggered: {
                        RtlSdrFmController.togglePreset()
                    }

                    Connections {
                        target: RtlSdrFmController.allPresetsListModel
                        onModelReset: {
                            favoritesButton.refreshIcon()
                        }
                    }

                    Connections {
                        target: RtlSdrFmController
                        onCurrentFrequencyChanged: {
                            favoritesButton.refreshIcon()
                        }
                    }

                    function refreshIcon() {
                        favoritesButton.source = RtlSdrFmController.hasPreset(
                                    RtlSdrFmController.currentFrequency) ? "/images/ico_favorites.svg" : "/images/ico_favorites_inactive.svg"
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        NotificationsController.suspendChannel(
                    RtlSdrFmController.notificationsChannelId)
    }

    Component.onDestruction: {
        NotificationsController.resumeChannel(
                    RtlSdrFmController.notificationsChannelId)
    }
}
