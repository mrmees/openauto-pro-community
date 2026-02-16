import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../../oainput/qml"

InputControl {
    property alias text: label.text
    property alias fontPixelSize: label.fontPixelSize
    property alias checked: button.checked
    property var group

    implicitWidth: (button.width + label.implicitWidth + (label.anchors.leftMargin * 2))

    id: root
    z: -1
    enableClickAnimation: button.checked
    onTriggered: {
        if (!button.checked) {
            button.checked = true
        }
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

    RadioButton {
        id: button
        ButtonGroup.group: group
        anchors.left: parent.left
        height: parent.height * 0.6
        width: height
        anchors.verticalCenter: parent.verticalCenter

        indicator: Rectangle {
            implicitWidth: 18
            implicitHeight: 18

            x: text ? (button.mirrored ? button.width - width - button.rightPadding : button.leftPadding) : button.leftPadding
                      + (button.availableWidth - width) / 2
            y: button.topPadding + (button.availableHeight - height) / 2

            radius: width / 2
            color: "gray"
            border.width: button.visualFocus ? 2 : 1
            border.color: "#676767"

            Rectangle {
                x: (parent.width - width) / 2
                y: (parent.height - height) / 2
                width: 16
                height: 16
                radius: width / 2
                color: ThemeController.controlForegroundColor
                visible: button.checked
            }
        }
    }

    NormalText {
        id: label
        anchors.left: button.right
        anchors.leftMargin: parent.height * 0.275
        anchors.right: parent.right
        anchors.rightMargin: parent.height * 0.25
        height: parent.height
        verticalAlignment: Text.AlignVCenter
    }
}
