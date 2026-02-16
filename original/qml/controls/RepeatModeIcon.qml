import QtQuick 2.11
import OpenAuto 1.0

Item {
    property bool checked

    id: root

    Rectangle {
        radius: height * 0.1
        anchors.centerIn: parent
        color: ThemeController.controlBackgroundColor
        border.color: "darkgray"
        border.width: height * 0.085
        height: parent.height
        width: height

        Rectangle {
            id: checkedBox
            radius: height * 0.1
            height: parent.height * 0.55
            width: height
            anchors.centerIn: parent
            color: ThemeController.controlForegroundColor
            opacity: 0.0

            states: [
                State {
                    when: root.checked
                    PropertyChanges {
                        target: checkedBox
                        opacity: 1.0
                    }
                },
                State {
                    when: !root.checked
                    PropertyChanges {
                        target: checkedBox
                        opacity: 0.0
                    }
                }
            ]
            transitions: Transition {
                NumberAnimation {
                    property: "opacity"
                    duration: 100
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.checked = !root.checked
        }
    }
}
