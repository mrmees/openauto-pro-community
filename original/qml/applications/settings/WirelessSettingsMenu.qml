import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"

SettingsApplicationMenu {
    signal cancelClicked
    signal saveClicked(int colorId, string value)
    property string startColor
    property string defaultColor
    property int colorId

    id: root
    title: qsTr("Select color")

    Item {
        id: container
        anchors.centerIn: parent
        width: parent.width * 0.95
        height: parent.height * 0.75

        ControlBackground {
            radius: height * 0.025
        }

        Item {
            id: colorSetContainer
            anchors.top: parent.top
            width: parent.width
            height: parent.height * 0.75

            Rectangle {
                id: colorIndicator
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.1
                anchors.verticalCenter: parent.verticalCenter
                width: container.height * 0.4
                height: colorIndicator.width
                color: root.startColor
            }

            ColumnLayout {
                anchors.left: colorIndicator.right
                anchors.leftMargin: parent.width * 0.1
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.1
                height: parent.height * 0.9
                anchors.verticalCenter: parent.verticalCenter

                ColorSlider {
                    id: redSlider
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height * 0.15
                    stepSize: 1
                    from: 0
                    to: 255
                    value: root.hexToRgb(root.startColor).r
                    label: "R:"

                    onPositionChanged: {
                        colorIndicator.color = root.rgbToHex({
                                                                 "r": redSlider.value,
                                                                 "g": greenSlider.value,
                                                                 "b": blueSlider.value
                                                             })
                    }
                }

                ColorSlider {
                    id: greenSlider
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height * 0.15
                    stepSize: 1
                    from: 0
                    to: 255
                    value: root.hexToRgb(root.startColor).g
                    label: "G:"

                    onPositionChanged: {
                        colorIndicator.color = root.rgbToHex({
                                                                 "r": redSlider.value,
                                                                 "g": greenSlider.value,
                                                                 "b": blueSlider.value
                                                             })
                    }
                }

                ColorSlider {
                    id: blueSlider
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height * 0.15
                    stepSize: 1
                    from: 0
                    to: 255
                    value: root.hexToRgb(root.startColor).b
                    label: "B:"

                    onPositionChanged: {
                        colorIndicator.color = root.rgbToHex({
                                                                 "r": redSlider.value,
                                                                 "g": greenSlider.value,
                                                                 "b": blueSlider.value
                                                             })
                    }
                }
            }
        }

        RowLayout {
            anchors.top: colorSetContainer.bottom
            anchors.topMargin: parent.height * 0.075
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.05
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            CustomButton {
                labelText: qsTr("Cancel")
                Layout.preferredWidth: parent.width * 0.25
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter

                onTriggered: {
                    root.cancelClicked()
                }
            }

            CustomButton {
                labelText: qsTr("Default")
                Layout.preferredWidth: parent.width * 0.25
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter

                onTriggered: {
                    var rgbDefault = root.hexToRgb(root.defaultColor)
                    redSlider.value = rgbDefault.r
                    greenSlider.value = rgbDefault.g
                    blueSlider.value = rgbDefault.b
                }
            }

            CustomButton {
                labelText: qsTr("Save")
                Layout.preferredWidth: parent.width * 0.25
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter

                onTriggered: {
                    root.saveClicked(root.colorId, root.rgbToHex({
                                                                     "r": redSlider.value,
                                                                     "g": greenSlider.value,
                                                                     "b": blueSlider.value
                                                                 }))
                }
            }
        }
    }

    function rgbToHex(value) {
        var toHex = function (value) {
            var hexValue = value.toString(16)
            return hexValue.length === 1 ? "0" + hexValue : hexValue
        }

        return "#" + toHex(value.r) + toHex(value.g) + toHex(value.b)
    }

    function hexToRgb(hex) {
        var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
        return result ? {
                            "r": parseInt(result[1], 16),
                            "g": parseInt(result[2], 16),
                            "b": parseInt(result[3], 16)
                        } : {
            "r": 0,
            "g": 0,
            "b": 0
        }
    }
}
