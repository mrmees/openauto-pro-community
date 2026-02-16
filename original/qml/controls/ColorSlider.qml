import QtQuick 2.11
import QtGraphicalEffects 1.0
import OpenAuto 1.0
import "../../oainput/qml"

InputControl {
    property alias colorize: colorOverlay.visible

    id: root

    hightlight: Item {
        Rectangle {
            color: "transparent"
            border.color: ThemeController.highlightColor
            border.width: height * 0.075
            anchors.fill: parent
            radius: width * 0.5
        }
    }

    Item {
        width: height
        height: parent.height * 0.75
        anchors.centerIn: parent

        Image {
            id: closeIcon
            anchors.fill: parent
            sourceSize: Qt.size(parent.width, parent.height)
            source: "/images/ico_close.svg"
            visible: !colorOverlay.visible
        }

        ColorOverlay {
            id: colorOverlay
            anchors.fill: closeIcon
            source: closeIcon
            color: ThemeController.iconColor
        }
    }
}
