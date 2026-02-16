import QtQuick 2.11
import OpenAuto 1.0
import "../../oainput/qml"

InputControl {
    property alias labelText: label.text
    property alias checked: switcher.checked

    id: root
    enableClickAnimation: false

    onTriggered: {
        switcher.checked = !switcher.checked
    }

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

        CustomSwitch {
            id: switcher
            anchors.right: parent.right
            height: parent.height * 0.5
            width: height
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: parent.width * 0.025
        }
    }
}
