import QtQuick 2.11
import QtGraphicalEffects 1.0
import OpenAuto 1.0

import "../controls"

Item {
    property bool active: false
    property bool projectionActive: false

    id: root
    y: -root.height

    Connections {
        target: NotificationsController

        onShowNotification: {
            root.show()
        }

        onNotificationsEmptied: {
            root.hide()
        }
    }

    Image {
        id: progressIcon
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.005
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height * 0.9
        width: height
        source: NotificationsController.progressIcon
        mipmap: true
        antialiasing: true
        visible: source !== "" && primaryIcon.status !== Image.Ready
    }

    Item {
        id: primaryIconContainer
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.005
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height * 0.9
        width: height

        Image {
            id: primaryIcon
            anchors.fill: parent
            //source: NotificationsController.primaryIcon
            asynchronous: true
            mipmap: true
            antialiasing: true
            cache: false
            visible: status === Image.Ready
            sourceSize: Qt.size(parent.width, parent.height)
            layer.enabled: NotificationsController.roundedIcons
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
            visible: (primaryIcon.source.toString().split('.').pop() === "svg")
        }
    }

    SpecialText {
        id: title
        font.pixelSize: parent.height * 0.65
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        text: NotificationsController.singleLine
        height: parent.height
        anchors.left: primaryIconContainer.right
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.01
        anchors.verticalCenter: parent.verticalCenter
    }

    Behavior on y {
        SmoothedAnimation {
            id: animation
            duration: 1000
        }
    }

    function show() {
        root.y = 0
        root.active = true
    }

    function hide() {
        root.y = -root.height
        root.active = false
    }
}
