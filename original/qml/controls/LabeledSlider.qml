import QtQuick 2.11
import OpenAuto 1.0
import "../../oainput/qml"

InputControl {
    property alias labelText: label.text

    id: root

    hightlight: Item {
        Rectangle {
            color: "transparent"
            border.color: ThemeController.highlightColor
            border.width: height * 0.05
            anchors.fill: parent
            radius: height * 0.15
        }
    }

    ControlBackground {
        radius: height * 0.15
    }

    Item {
        id: container
        anchors.fill: parent

        NormalText {
            id: label
            fontPixelSize: parent.height * 0.325
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.01
        }

        Image {
            id: switcher
            anchors.right: parent.right
            height: parent.height * 0.45
            width: height
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: parent.width * 0.01
            source: "/images/ico_arrow_right.png"
        }
    }
}
