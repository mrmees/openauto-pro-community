import QtQuick 2.11
import OpenAuto 1.0
import "../../oainput/qml"

InputControl {
    property bool active: false

    id: root

    hightlight: Item {
        Rectangle {
            color: "transparent"
            border.color: ThemeController.highlightColor
            border.width: height * 0.085
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            radius: width * 0.5
        }
    }

    Icon {
        id: iconImage
        width: parent.width
        height: parent.width
        anchors.centerIn: parent
        source: "/images/ico_topbarhide.svg"
        rotation: root.active ? 0 : 180

        Behavior on rotation {
            SmoothedAnimation {
                duration: 200
            }
        }

        Behavior on width {
            SmoothedAnimation {
                duration: 200
            }
        }
    }
}
