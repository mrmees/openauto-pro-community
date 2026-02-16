import QtQuick 2.11

Item {
    property alias labelText: label.text
    readonly property alias value: spinBox.value
    property alias minValue: spinBox.minValue
    property alias maxValue: spinBox.maxValue

    id: root

    ControlBackground {
        radius: height * 0.15
    }

    Item {
        id: container
        anchors.fill: parent

        NormalText {
            id: label
            fontPixelSize: parent.height * 0.325
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.01
        }

        CustomSpinBox {
            id: spinBox
            anchors.right: parent.right
            height: parent.height * 0.5
            width: parent.width * 0.2
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: parent.width * 0.01
        }
    }

    function setValue(value) {
        spinBox.setValue(value)
    }
}
