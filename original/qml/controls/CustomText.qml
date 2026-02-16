import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0

ScrollBar {
    id: root
    active: true
    opacity: ConfigurationController.controlsOpacity / 100

    contentItem: Rectangle {
        implicitWidth: 6
        implicitHeight: 100
        radius: width / 2
        color: root.pressed ? ThemeController.highlightColor : ThemeController.controlBackgroundColor
    }
}
