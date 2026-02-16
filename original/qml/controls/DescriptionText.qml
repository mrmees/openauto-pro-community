import QtQuick 2.11

Item {
    property alias from: slider.from
    property alias to: slider.to
    property alias value: slider.value
    property alias position: slider.position
    property alias pressed: slider.pressed
    property alias scrollingActive: slider.scrollingActive
    property alias stepSize: slider.stepSize
    property string label

    id: root

    CustomSlider {
        id: slider
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.01
        anchors.right: valueLabel.left
        anchors.rightMargin: parent.width * 0.05
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
    }

    NormalText {
        id: valueLabel
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.01
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        width: parent.width * 0.075
        text: label + " " + slider.value
        fontPixelSize: parent.height * 0.5
        verticalAlignment: Text.AlignVCenter
    }

    function valueAt(position) {
        return slider.valueAt(position)
    }
}
