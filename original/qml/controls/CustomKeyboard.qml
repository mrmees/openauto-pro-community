import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.0
import OpenAuto 1.0
import OpenAuto.Input 1.0
import "../controls"
import "../../oainput/qml"

InputScope {
    signal closeClicked

    id: root
    y: -root.height

    TouchControl {
        anchors.fill: parent
    }

    Connections {
        target: NotificationsController

        onShowNotification: {
            root.show()
        }

        onNotificationsEmptied: {
            root.hide()
        }
    }

    ControlBackground {
        opacity: 1
    }

    Item {
        id: container
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: bottomBar.top

        Image {
            id: progressIcon
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.025
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height * 0.75
            width: height
            source: NotificationsController.progressIcon
            mipmap: true
            antialiasing: true
            visible: source !== "" && primaryIcon.status !== Image.Ready
        }

        Item {
            id: primaryIconContainer
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.025
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height * 0.7
            width: height

            Image {
                id: primaryIcon
                anchors.fill: parent
                sourceSize: Qt.size(parent.width, parent.height)
                //source: NotificationsController.primaryIcon
                asynchronous: true
                visible: status === Image.Ready
                layer.enabled: NotificationsController.roundedIcons
                cache: false
                layer.effect: OpacityMask {
                    maskSource: Item {
                        width: primaryIconContainer.width
                        height: primaryIconContainer.height

                        Rectangle {
                            anchors.centerIn: parent
                            width: Math.min(primaryIconContainer.width,
                                            primaryIconContainer.height) * 0.95
                            height: width * 0.95
                            radius: Math.min(width, height)
                        }
                    }
                }

                // Workaround for bug with Android Auto coverarts
                Component.onCompleted: {
                    primaryIcon.source = NotificationsController.primaryIcon
                }

                Connections {
                    target: NotificationsController
                    onPrimaryIconChanged: {
                        if (NotificationsController.channelId
                                === AndroidAutoController.notificationsChannelId) {
                            primaryIcon.source = ""
                        }

                        primaryIcon.source = NotificationsController.primaryIcon
                    }
                }
            }

            ColorOverlay {
                id: colorOverlay
                anchors.fill: primaryIcon
                source: primaryIcon
                color: ThemeController.iconColor
                visible: (primaryIcon.source.toString().split('.').pop(
                              ) === "svg")
            }
        }

        ColumnLayout {
            height: parent.height * 0.7
            anchors.left: primaryIconContainer.right
            anchors.leftMargin: parent.width * 0.025
            anchors.right: closeButton.left
            anchors.rightMargin: parent.width * 0.01
            anchors.verticalCenter: parent.verticalCenter

            NormalText {
                id: title
                fontPixelSize: container.height * (description.visible ? 0.225 : 0.25)
                elide: Text.ElideRight
                text: NotificationsController.title
                Layout.preferredWidth: parent.width
                Layout.alignment: Qt.AlignVCenter
            }

            DescriptionText {
                id: description
                fontPixelSize: container.height * 0.19
                elide: Text.ElideRight
                text: NotificationsController.description
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: parent.width
                visible: text !== ""
            }
        }

        CloseButton {
            id: closeButton
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.025
            anchors.verticalCenter: parent.verticalCenter
            height: width
            width: parent.height * 0.5
            onTriggered: {
                root.closeClicked()
            }
        }
    }

    Rectangle {
        id: bottomBar
        color: ThemeController.barShadowColor
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height * 0.01
    }

    Rectangle {
        id: progressBar
        color: ThemeController.controlForegroundColor
        anchors.bottom: parent.bottom
        width: Math.min(
                   parent.width,
                   (parent.width * (elapsedTimer.elapsed / NotificationsController.duration)) + 0.5)
        height: parent.height * 0.01

        Behavior on width {
            NumberAnimation {
                duration: elapsedTimer.interval
            }
        }
    }

    Behavior on y {
        NumberAnimation {
            id: animation
            duration: 600
        }
    }

    Timer {
        property int elapsed: 0

        id: elapsedTimer
        repeat: true
        running: false
        interval: 200
        onTriggered: {
            elapsedTimer.elapsed += elapsedTimer.interval
        }
    }

    function show() {
        root.y = 0
        elapsedTimer.elapsed = 0
        elapsedTimer.repeat = true
        elapsedTimer.running = true
    }

    function hide() {
        root.y = -root.height
        elapsedTimer.elapsed = 0
        elapsedTimer.repeat = false
        elapsedTimer.running = false
    }
}
