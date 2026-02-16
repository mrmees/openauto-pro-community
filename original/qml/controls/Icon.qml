import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../../oainput/qml"

Item {
    property alias from: slider.from
    property alias to: slider.to
    property alias value: slider.value
    property alias position: slider.position
    property alias snapMode: slider.snapMode
    property alias pressed: slider.pressed
    property alias scrollingActive: inputControl.scrollingActive
    property alias labelText: label.text
    property double stepSize: 1.0

    id: root

    AdjustmentButton {
        id: plusButton
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: height
        height: parent.height * 0.1
        source: "/images/ico_arrow_up.png"
        onClicked: {
            slider.value = Math.min(slider.value + slider.stepSize, slider.to)
        }
    }

    AdjustmentButton {
        id: minusButton
        anchors.top: label.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: height
        height: parent.height * 0.1
        source: "/images/ico_arrow_down.png"
        onClicked: {
            slider.value = Math.max(slider.value - slider.stepSize, slider.from)
        }
    }

    NormalText {
        id: label
        fontPixelSize: height * 0.45
        anchors.top: inputControl.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    NormalText {
        id: valueLabel
        fontPixelSize: height * 0.45
        anchors.top: plusButton.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: slider.value
    }

    InputControl {
        id: inputControl
        anchors.top: valueLabel.bottom
        controlTouchEvents: false
        width: parent.width
        height: parent.height * 0.6
        hightlight: highlightComponent
        scrollingHighlight: highlightComponent

        Slider {
            id: slider
            stepSize: root.stepSize
            anchors.fill: parent
            orientation: Qt.Vertical

            handle: Rectangle {
                x: slider.leftPadding + (slider.availableWidth - width) / 2
                y: slider.topPadding + slider.visualPosition * (slider.availableHeight - height)
                implicitWidth: 18
                implicitHeight: 18
                radius: width / 2
                color: ThemeController.controlForegroundColor
                border.width: slider.visualFocus ? 2 : 1
                border.color: ThemeController.controlForegroundColor
            }

            background: Rectangle {
                x: slider.leftPadding + (slider.availableWidth - width) / 2
                y: slider.topPadding
                implicitWidth: 3
                implicitHeight: 200
                width: implicitWidth
                height: slider.availableHeight
                radius: 3
                color: "white"
                scale: slider.mirrored ? -1 : 1

                Rectangle {
                    y: slider.visualPosition * parent.height
                    width: 3
                    height: slider.position * parent.height
                    radius: 3
                    color: ThemeController.controlForegroundColor
                }
            }
        }

        onTriggered: {
            inputControl.scrollingActive = !inputControl.scrollingActive
        }

        onScrollLeft: {
            value = Math.max(root.from, root.value - stepSize)
        }

        onScrollRight: {
            value = Math.min(root.to, root.value + stepSize)
        }
    }

    Component {
        id: highlightComponent

        Item {
            Rectangle {
                color: "transparent"
                border.color: ThemeController.highlightColor
                border.width: width * 0.1
                height: parent.height
                width: parent.width * 0.6
                anchors.centerIn: parent
                radius: width * 0.25
                opacity: root.scrollingActive ? 1 : 0.5
            }
        }
    }

    function valueAt(position) {
        var value = (to - from) * position
        return from + (value + 0.5)
    }
}
