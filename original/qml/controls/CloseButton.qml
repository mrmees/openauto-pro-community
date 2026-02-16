import QtQuick 2.11
import QtGraphicalEffects 1.0
import OpenAuto 1.0

Item {
    property alias fillMode: image.fillMode
    property alias source: image.source
    property bool rounded: false
    property bool colorize: (!root.source.toString().includes("no_color"))
                            && (root.source.toString().split('.').pop(
                                    ) === "svg")
    property alias color: colorOverlay.color

    id: root

    Item {
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height) * 0.75
        height: width

        Image {
            anchors.fill: parent
            id: image
            sourceSize: Qt.size(parent.width, parent.height)
            visible: !colorOverlay.visible
        }

        DropShadow {
            cached: true
            anchors.fill: image
            source: image
            horizontalOffset: 3
            verticalOffset: 3
            radius: 8.0
            samples: 17
            color: ThemeController.iconShadowColor
            visible: ThemeController.iconShadowColor !== "transparent"
        }

        ColorOverlay {
            id: colorOverlay
            anchors.fill: image
            source: image
            color: ThemeController.iconColor
            visible: root.colorize
        }
    }

    layer.enabled: root.rounded
    layer.effect: OpacityMask {
        maskSource: Item {
            width: root.width
            height: root.height

            Rectangle {
                anchors.centerIn: parent
                width: image.width
                height: width
                radius: Math.min(width, height)
            }
        }
    }
}
