import QtQuick 2.11
import OpenAuto 1.0
import "../../oainput/qml"

Item {
    property int maxValue
    property int minValue
    readonly property alias value: label.value
    property bool fillValue: false

    id: root

    AdjustmentButton {
        id: minusButton
        height: parent.height
        width: height * 1.5
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        source: "/images/ico_arrow_left.png"
        onClicked: {
            root.decrease()
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
            root.increase()
        }
    }

    InputControl {
        id: inputControl
        controlTouchEvents: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: minusButton.right
        anchors.leftMargin: parent.width * 0.0175
        anchors.right: plusButton.left
        anchors.rightMargin: parent.width * 0.0175
        hightlight: highlightComponent
        scrollingHighlight: highlightComponent

        onTriggered: {
            inputControl.scrollingActive = !inputControl.scrollingActive
        }

        onScrollLeft: {
            root.decrease()
        }

        onScrollRight: {
            root.increase()
        }

        NormalText {
            property int value

            id: label
            anchors.fill: parent
            fontPixelSize: parent.height * 0.6
            text: {
                if (root.fillValue) {
                    return label.value < 10 ? '0' + label.value : label.value
                } else {
                    return label.value
                }
            }

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Component {
        id: highlightComponent

        Rectangle {
            color: "transparent"
            border.color: ThemeController.highlightColor
            border.width: height * 0.075
            anchors.fill: parent
            radius: width * 0.075
            opacity: root.scrollingActive ? 1 : 0.5
        }
    }

    function increase() {
        var newValue = label.value + 1

        if (newValue > maxValue) {
            newValue = minValue
        }

        label.value = newValue
    }

    function decrease() {
        var newValue = label.value - 1

        if (newValue < minValue) {
            newValue = maxValue
        }

        label.value = newValue
    }

    function setValue(value) {
        if (value < root.minValue) {
            label.value = root.minValue
        } else if (value > root.maxValue) {
            label.value = root.maxValue
        } else {
            label.value = value
        }
    }
}
