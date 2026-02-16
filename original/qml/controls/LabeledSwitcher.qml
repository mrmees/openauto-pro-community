import QtQuick 2.11

Item {
    property alias labelText: label.text
    property alias from: slider.from
    property alias to: slider.to
    property alias value: slider.value
    property alias position: slider.position
    property alias pressed: slider.pressed
    property alias scrollingActive: slider.scrollingActive
    property alias stepSize: slider.stepSize

    id: root

    ControlBackground {
        radius: height * 0.15
    }

    NormalText {
        id: label
        fontPixelSize: parent.height * 0.325
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.01
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 0.5
        height: label.height
        verticalAlignment: Text.AlignVCenter
    }

    CustomSlider {
        id: slider
        anchors.right: valueLabel.left
        anchors.rightMargin: parent.width * 0.03
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 0.4
        height: parent.height * 0.5
    }

    NormalText {
        id: valueLabel
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.01
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        text: slider.value //Math.floor(valueAt(slider.position))
        width: parent.width * 0.075
        fontPixelSize: parent.height * 0.3
        verticalAlignment: Text.AlignVCenter
    }

    function valueAt(position) {
        return slider.valueAt(position)
    }
}
