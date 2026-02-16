import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../controls"

BottomBarDelegate {
    property real buttonWidth: root.height * 0.85
    property real buttonHeight: root.height * 0.85

    id: root
    defaultControl: homeButton

    BarIcon {
        id: backButton
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.015
        anchors.verticalCenter: parent.verticalCenter
        width: root.buttonWidth
        height: root.buttonHeight
        visible: root.backButtonVisible
        source: "/images/ico_back.svg"

        onTriggered: {
            root.backClicked()
        }

        Rectangle {
            z: -1
            width: parent.width
            height: width
            radius: width * 0.5
            color: ThemeController.controlBoxBackgroundColor
            anchors.centerIn: parent
        }
    }

    RowLayout {
        property int leftMargin: backButton.visible ? parent.width * 0.03 : parent.width * 0.02

        id: rowLayout
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: backButton.visible ? backButton.right : parent.left
        anchors.leftMargin: leftMargin
        anchors.right: box.sourceComponent != null ? box.left : homeButton.left
        anchors.rightMargin: parent.width * 0.02

        property real itemWidth: height
        property real itemHeight: height

        BarIcon {
            id: settingsButton
            Layout.preferredWidth: root.buttonWidth
            Layout.preferredHeight: root.buttonHeight
            source: "/images/ico_settings_white.svg"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            onTriggered: {
                root.settingsClicked()
            }
        }

        BarIcon {
            id: notificationsButton
            Layout.preferredWidth: root.buttonWidth
            Layout.preferredHeight: root.buttonHeight
            source: {
                return PhoneNotificationsController.status
                        === PhoneNotificationsControllerStatus.UNREAD ? "/images/ico_notification_unread.svg" : "/images/ico_notification.svg"
            }

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            onTriggered: {
                root.notificationsClicked()
            }
        }

        BarIcon {
            id: powerOffButton
            Layout.preferredWidth: root.buttonWidth
            Layout.preferredHeight: root.buttonHeight
            source: "/images/ico_poweroff.svg"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            onTriggered: {
                root.powerOffClicked()
            }
        }

        Behavior on leftMargin {
            SmoothedAnimation {
                duration: 1000
            }
        }
    }

    Loader {
        id: box
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: homeButton.left
        anchors.rightMargin: parent.width * 0.03
        height: parent.height
        width: parent.width * 0.425
        sourceComponent: root.boxDelegate
        onSourceComponentChanged: {
            animation.running = true
        }

        PropertyAnimation {
            id: animation
            target: box.item
            property: "y"
            from: height * 0.75
            to: 0
            duration: 150
        }
    }

    BarIcon {
        id: homeButton
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.verticalCenter: parent.verticalCenter
        width: root.buttonWidth
        height: root.buttonHeight
        source: "/images/ico_home_new.svg"

        onTriggered: {
            homeClicked()
        }
    }
}
