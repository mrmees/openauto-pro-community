import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../../oainput/qml"

InputControl {
    property alias text: checkBox.text
    property alias font: checkBox.font
    property alias checked: checkBox.checked
    id: root

    onTriggered: {
        checkBox.checked = !checkBox.checked
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

    CheckBox {
        id: checkBox
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: parent.height * 0.9
        font.family: "Noto Sans, Noto Sans Korean, Noto Color Emoji"

        contentItem: Item {
            CustomText {
                text: checkBox.text
                font: checkBox.font
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.05
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                opacity: enabled ? 1.0 : 0.3
                color: checkBox.down ? "#f57c2a" : "#F5B42A"
                verticalAlignment: Text.AlignVCenter
                leftPadding: checkBox.indicator.width + checkBox.spacing
                fontSizeMode: Text.Fit
            }
        }
    }
}
