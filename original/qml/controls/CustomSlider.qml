import QtQuick 2.11
import OpenAuto 1.0
import "../../oainput/qml"

InputControl {
    property alias text: label.text
    property string descriptionText: ""

    id: root

    hightlight: Item {
        Rectangle {
            color: "transparent"
            border.color: ThemeController.highlightColor
            border.width: height * 0.05
            anchors.fill: parent
            radius: width * 0.25
        }
    }

    ControlBackground {
        id: background
        radius: width * 0.25
    }

    Item {
        id: container
        anchors.fill: parent

        NormalText {
            id: label
            fontPixelSize: root.height * 0.415
            anchors.centerIn: parent
        }
    }
}
