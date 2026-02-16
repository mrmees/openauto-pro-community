import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../controls"
import "../tools/ClockTools.js" as ClockTools

ApplicationMenu {
    id: root
    applicationType: ApplicationType.PHONE_NOTIFICATIONS
    title: qsTr("Phone notifications")

    onMoveToNextControl: {
        listView.incrementCurrentIndex()
    }

    onMoveToPreviousControl: {
        listView.decrementCurrentIndex()
    }

    onActivated: {
        listView.currentIndex = 0
        listView.positionViewAtBeginning()
    }

    Item {
        id: aboutAppContainer
        anchors.centerIn: parent
        width: parent.width * 0.85
        height: parent.height * 0.65
        visible: PhoneNotificationsController.status
                 === PhoneNotificationsControllerStatus.DISCONNECTED

        ControlBackground {
            radius: height * 0.025
        }

        Rectangle {
            id: qrcode
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.025
            anchors.verticalCenter: parent.verticalCenter
            width: aboutAppContainer.height * 0.7
            height: qrcode.width
            color: "white"

            Image {
                source: "/images/connected_pro_qr.svg"
                anchors.fill: parent
            }
        }

        ColumnLayout {
            anchors.left: qrcode.right
            anchors.leftMargin: parent.width * 0.025
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.025
            spacing: parent.height * 0.025
            height: qrcode.height
            anchors.verticalCenter: parent.verticalCenter

            NormalText {
                fontPixelSize: aboutAppContainer.height * 0.065
                text: qsTr("Connect your phone using <b>Connected Pro</b> application to see phone's notifications.")
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                Layout.preferredWidth: parent.width
            }

            NormalText {
                fontPixelSize: aboutAppContainer.height * 0.065
                text: qsTr("Do not have <b>Connected Pro</b> application yet? Use QR code to get it or visit <b>https://bit.ly/connectedpro</b>.")
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                Layout.preferredWidth: parent.width
            }
        }
    }

    ListView {
        property int animationDuration: 500

        id: listView
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.bottom: parent.bottom
        model: PhoneNotificationsController.model
        visible: PhoneNotificationsController.status
                 !== PhoneNotificationsControllerStatus.DISCONNECTED

        delegate: Item {
            width: listView.width
            height: listView.height / 5

            PhoneNotification {
                width: parent.width * 0.975
                height: parent.height * 0.95
                titleText: model.title
                messageText: model.text
                primaryIconSource: "image://phone_notification_primary_icons/" + model.key
                secondaryIconSource: "image://phone_notification_secondary_icons/" + model.key
                order: model.index
                timeText: {
                    if (ConfigurationController.timeFormat === TimeFormat.FORMAT_12H) {
                        return ClockTools.get12HTime(model.time)
                    } else {
                        return ClockTools.get24HTime(model.time)
                    }
                }

                onCloseTriggered: {
                    PhoneNotificationsController.removeNotification(model.key)
                }
            }
        }

        ScrollBar.vertical: CustomScrollBar {
            id: scrollBar
            active: true
            visible: listView.count > 4
            anchors.top: parent.top
        }

        add: Transition {
            NumberAnimation {
                properties: "x"
                from: listView.width / 2
                duration: listView.animationDuration
            }
        }

        addDisplaced: Transition {
            NumberAnimation {
                properties: "x"
                duration: listView.animationDuration * 2
            }
        }

        move: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: listView.animationDuration * 2
            }
        }

        moveDisplaced: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: listView.animationDuration * 2
            }
        }

        remove: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity"
                    to: 0
                    duration: listView.animationDuration
                }
                NumberAnimation {
                    properties: "x"
                    to: listView.width / 2
                    duration: listView.animationDuration
                }
            }
        }

        removeDisplaced: Transition {
            NumberAnimation {
                properties: "x"
                duration: listView.animationDuration
            }
        }
    }

    Component.onCompleted: {
        PhoneNotificationsController.focus = true
        NotificationsController.suspendChannel(
                    PhoneNotificationsController.notificationsChannelId)
    }

    Component.onDestruction: {
        PhoneNotificationsController.focus = false
        NotificationsController.resumeChannel(
                    PhoneNotificationsController.notificationsChannelId)
    }

    Connections {
        target: PhoneNotificationsController.model
        onRowsInserted: {
            Qt.callLater(positionAtBeginning)
        }
    }

    Connections {
        target: AndroidAutoController
        onProjectionActiveChanged: {
            if (AndroidAutoController.projectionActive) {
                NotificationsController.resumeChannel(
                            PhoneNotificationsController.notificationsChannelId)
            } else {
                NotificationsController.suspendChannel(
                            PhoneNotificationsController.notificationsChannelId)
            }
        }
    }

    Connections {
        target: MirroringController
        onProjectionActiveChanged: {
            if (MirroringController.projectionActive) {
                NotificationsController.resumeChannel(
                            PhoneNotificationsController.notificationsChannelId)
            } else {
                NotificationsController.suspendChannel(
                            PhoneNotificationsController.notificationsChannelId)
            }
        }
    }

    Connections {
        target: AutoboxController
        onProjectionActiveChanged: {
            if (AutoboxController.projectionActive) {
                NotificationsController.resumeChannel(
                            PhoneNotificationsController.notificationsChannelId)
            } else {
                AutoboxController.suspendChannel(
                            PhoneNotificationsController.notificationsChannelId)
            }
        }
    }

    function positionAtBeginning() {
        listView.positionViewAtBeginning()
        listView.currentIndex = 0
        root.highlightDefaultControl()
    }
}
