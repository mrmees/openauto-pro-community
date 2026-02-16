import QtQuick 2.11
import OpenAuto 1.0
import "../../oainput/qml"

InputControl {
    property alias text: label.text
    property string descriptionText: ""
    property bool active: false
    property alias horizontalAlignement: label.horizontalAlignment
    property alias verticalAlignement: label.verticalAlignment
    property alias hasNextLevel: nextLevelIcon.visible

    id: root

    hightlight: Item {       
        Rectangle {
            color: "transparent"
            border.color: ThemeController.highlightColor
            border.width: height * 0.05
            anchors.fill: parent
            radius: height * 0.1
        }
    }

    ControlBackground {
        id: background
        radius: height * 0.1
    }

    Item {
        id: container
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: root.width * 0.015
        anchors.right: nextLevelIcon.visible ? nextLevelIcon.left : parent.right
        anchors.rightMargin: root.width * 0.015

        NormalText {
            id: label
            anchors.fill: parent
            fontPixelSize: root.height * 0.325
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: root.active ? ThemeController.specialFontColor : ThemeController.normalFontColor
        }
    }

    Icon {
        id: nextLevelIcon
        height: parent.height * 0.75
        width: height
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: root.width * 0.015
        source: "/images/ico_forward.svg"
        visible: false
    }
}
