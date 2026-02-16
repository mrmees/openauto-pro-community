import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

Item {
    property alias labelText: label.text
    property alias buttonLabels: repeater.model
    property alias backgroundOpacity: background.opacity
    property var buttonValues
    signal buttonValueChanged(int index)

    id: root

    ControlBackground {
        id: background
        radius: height * 0.15
    }

    NormalText {
        id: label
        fontPixelSize: parent.height * 0.325
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.01
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 0.15
        height: label.height
        verticalAlignment: Qt.AlignVCenter
    }

    RowLayout {
        id: container
        anchors.left: label.right
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.01
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        ButtonGroup {
            id: buttonGroup
        }

        Item {
            Layout.fillWidth: true
        }

        Repeater {
            id: repeater

            delegate: CustomRadioButton {
                id: delegate
                Layout.alignment: Qt.AlignRight
                Layout.preferredHeight: parent.height * 0.65
                text: modelData
                fontPixelSize: parent.height * 0.27
                group: buttonGroup
                checked: root.buttonValues[index]
                onCheckedChanged: {
                    if (delegate.checked !== root.buttonValues[index]) {
                        root.buttonValues[index] = delegate.checked
                        root.buttonValueChanged(index)
                    }
                }

                Connections {
                    target: root
                    onButtonValuesChanged: {
                        if (delegate.checked !== root.buttonValues[index]) {
                            delegate.checked = root.buttonValues[index]
                        }
                    }
                }
            }
        }
    }

    function getActiveButton() {
        for (var i = 0; i < repeater.count; ++i) {
            var item = repeater.itemAt(i)
            if (item.checked) {
                return item
            }
        }

        return null
    }
}
