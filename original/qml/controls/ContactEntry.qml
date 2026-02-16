import QtQuick 2.11
import OpenAuto 1.0
import "../../oainput/qml"

InputControl {
    property alias text: label.scrollableText
    property alias iconSource: icon.source
    property bool active: false

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
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.015
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.015

        Icon {
            id: icon
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height * 0.5
            width: height
        }

        NormalText {
            id: label
            anchors.left: icon.right
            anchors.leftMargin: parent.width * 0.015
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            fontPixelSize: root.height * 0.35
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHLeft
            verticalAlignment: Text.AlignVCenter
            color: root.active ? ThemeController.specialFontColor : ThemeController.normalFontColor
        }
    }
}
