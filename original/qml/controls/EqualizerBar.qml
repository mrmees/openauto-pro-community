import QtQuick 2.11
import OpenAuto 1.0
import "../../oainput/qml"

InputControl {
    property alias labelText: label.text
    property alias color: background.color

    id: root

    onTriggered: {
        //root.color = ThemeController.controlForegroundColor
    }

    hightlight: Item {
        Rectangle {
            color: "transparent"
            border.color: ThemeController.highlightColor
            border.width: height * 0.075
            anchors.fill: parent
            radius: height * 0.15
        }
    }

    Rectangle {
        anchors.fill: parent
        id: background
        color: "#151515"
        z: -1
        radius: height * 0.15
    }

    Item {
        id: container
        anchors.fill: parent

        CustomText {
            id: label
            anchors.centerIn: parent
            font.family: "Noto Sans, Noto Sans Korean, Noto Color Emoji"
            fontPixelSize: parent.height * 0.375
            color: "white"
        }
    }
}
