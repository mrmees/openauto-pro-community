import QtQuick 2.11
import OpenAuto 1.0

Item {
    property double percent: TelephonyController.batteryLevel / 100

    id: root

    Rectangle {
        id: background
        height: parent.height * 0.85
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: ThemeController.iconColor
        opacity: 0.5
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: background.top
        width: parent.width * 0.5
        opacity: percent < 1 ? 0.5 : 1
        color: ThemeController.iconColor
    }

    Rectangle {
        id: indicator
        height: background.height * root.percent
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: ThemeController.iconColor
    }
}
