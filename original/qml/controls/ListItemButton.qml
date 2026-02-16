import QtQuick 2.11
import "../../oainput/qml"

Item {
    property alias from: slider.from
    property alias to: slider.to
    property alias value: slider.value
    property alias position: slider.position
    property alias snapMode: slider.snapMode
    property alias pressed: slider.pressed
    property alias scrollingActive: slider.scrollingActive
    property alias stepSize: slider.stepSize
    property alias readOnly: slider.readOnly

    id: root

    AdjustmentButton {
        id: minusButton
        height: parent.height
        width: height * 1.5
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        source: "/images/ico_arrow_left.png"
        onClicked: {
            if (!root.readOnly) {
                slider.value = Math.max(slider.value - slider.stepSize,
                                        slider.from)
            }
        }
    }

    AdjustmentButton {
        id: plusButton
        height: parent.height
        width: height * 1.5
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        source: "/images/ico_arrow_right.png"
        onClicked: {
            if (!root.readOnly) {
                slider.value = Math.min(slider.value + slider.stepSize,
                                        slider.to)
            }
        }
    }

    SimpleSlider {
        id: slider
        controlTouchEvents: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: minusButton.right
        anchors.leftMargin: parent.width * 0.0125
        anchors.right: plusButton.left
        anchors.rightMargin: parent.width * 0.0125
    }

    function valueAt(position) {
        var value = (to - from) * position
        return from + (value + 0.5)
    }
}
