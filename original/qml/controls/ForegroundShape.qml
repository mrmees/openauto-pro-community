import QtQuick 2.11
import OpenAuto 1.0
import QtGraphicalEffects 1.0

Item {
    property bool active: false
    property string activeColor
    property alias radius: inner.radius
    property alias border: inner.border

    id: root
    opacity: ConfigurationController.controlsOpacity / 100
    z: -1
    anchors.fill: parent

    Rectangle {
        id: inner
        anchors.fill: parent
        color: active ? activeColor : ThemeController.controlBackgroundColor
        layer.enabled: true
        layer.effect: DropShadow {
            cached: true
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 8
            samples: 17
        }
    }
}
