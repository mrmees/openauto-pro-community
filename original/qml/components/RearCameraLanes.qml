import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../../oainput/qml"

InputControl {
    property alias from: slider.from
    property alias to: slider.to
    property alias value: slider.value
    property alias position: slider.position
    property alias snapMode: slider.snapMode
    property alias pressed: slider.pressed
    property double stepSize: 1.0
    property bool readOnly: false

    id: root
    hightlight: highlightComponent
    scrollingHighlight: highlightComponent

    Slider {
        property double usedWidth: width // slider.availableWidth

        id: slider
        stepSize: root.stepSize
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.95
        height: parent.height * 0.9
        anchors.verticalCenter: parent.verticalCenter
        orientation: Qt.Horizontal
        leftPadding: 0

        handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * (slider.usedWidth - width)
            y: slider.topPadding + (slider.availableHeight - height) / 2
            implicitWidth: 18
            implicitHeight: 18
            radius: width / 2
            color: ThemeController.controlForegroundColor
            border.width: slider.visualFocus ? 2 : 1
            border.color: ThemeController.controlForegroundColor
            visible: root.to > root.from && !root.readOnly
        }

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + (slider.availableHeight - height) / 2
            implicitWidth: 200
            implicitHeight: 3
            width: slider.usedWidth
            height: implicitHeight
            radius: 3
            color: "white"
            scale: slider.mirrored ? -1 : 1

            Rectangle {
                y: 0
                width: slider.position * parent.width
                height: 3
                radius: 3
                color: ThemeController.controlForegroundColor
            }
        }
    }

    onTriggered: {
        var scrollingStatus = !root.scrollingActive
        root.scrollingActive = (scrollingStatus && !root.readOnly)
    }

    onScrollLeft: {
        if (!root.readOnly) {
            value = Math.max(root.from, root.value - stepSize)
        }
    }

    onScrollRight: {
        if (!root.readOnly) {
            value = Math.min(root.to, root.value + stepSize)
        }
    }

    TouchControl {
        anchors.fill: parent
        visible: root.readOnly
    }

    Component {
        id: highlightComponent

        Item {
            Rectangle {
                color: "transparent"
                border.color: ThemeController.highlightColor
                border.width: height * 0.1
                anchors.fill: parent
                radius: height * 0.25
                opacity: root.scrollingActive ? 1 : 0.5
            }
        }
    }
}
