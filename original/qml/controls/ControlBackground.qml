import QtQuick 2.11
import OpenAuto 1.0
import "../../oainput/qml"

Item {
    signal triggered
    property alias source: icon.source
    property alias rotation: icon.rotation
    property alias rounded: icon.rounded
    property alias colorize: icon.colorize
    property alias color: icon.color

    id: root

    InputControl {
        onTriggered: {
            root.triggered()
        }

        height: parent.height
        width: height

        hightlight: Item {
            z: 2

            Rectangle {
                color: "transparent"
                border.color: ThemeController.highlightColor
                border.width: height * 0.075
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                radius: width * 0.5
            }
        }

        Rectangle {
            id: container
            anchors.fill: parent
            radius: parent.width * 0.5
            color: "transparent"

            Icon {
                id: icon
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height)
                height: width
            }
        }
    }
}
