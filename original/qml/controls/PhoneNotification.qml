import QtQuick 2.11
import QtQuick.Layouts 1.11

Item {
    property alias labelText: label.text
    property string value
    property alias minHour: hourSetter.minValue
    property alias maxHour: hourSetter.maxValue

    id: root

    ControlBackground {
        radius: height * 0.15
    }

    RowLayout {
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.01
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        NormalText {
            id: label
            fontPixelSize: parent.height * 0.325
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true
        }

        CustomSpinBox {
            id: hourSetter
            fillValue: true
            maxValue: 23
            minValue: 0
            Layout.preferredWidth: parent.width * 0.15
            Layout.preferredHeight: label.height
            Layout.alignment: Qt.AlignCenter

            onValueChanged: {
                root.value = hourSetter.value + ":" + minuteSetter.value
            }
        }

        NormalText {
            fontPixelSize: parent.height * 0.325
            Layout.preferredWidth: parent.width * 0.03
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Text.AlignHCenter
            text: ":"
        }

        CustomSpinBox {
            id: minuteSetter
            fillValue: true
            maxValue: 59
            minValue: 0
            Layout.preferredWidth: parent.width * 0.15
            Layout.preferredHeight: label.height
            Layout.alignment: Qt.AlignCenter

            onValueChanged: {
                root.value = hourSetter.value + ":" + minuteSetter.value
            }
        }
    }

    function setValue(value) {
        var timeValue = value.split(":")

        if (timeValue.length === 2) {
            hourSetter.setValue(timeValue[0])
            minuteSetter.setValue(timeValue[1])
        }
    }
}
