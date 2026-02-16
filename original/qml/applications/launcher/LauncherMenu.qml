import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../"
import "../../controls"

EqualizerApplicationMenu {
    id: root
    defaultControl: presetGroup.getActiveButton()

    Item {
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        height: parent.height * 0.9
        anchors.verticalCenter: parent.verticalCenter

        ControlBackground {
            radius: height * 0.05
        }

        RadioButtonsGroup {
            id: presetGroup
            labelText: qsTr("Preset")
            buttonLabels: [qsTr("Flat"), qsTr("Rock"), qsTr("Jazz"), qsTr(
                    "Classic"), qsTr("Pop"), qsTr("Custom")]
            buttonValues: [EqualizerController.preset
                === EqualizerPreset.FLAT, EqualizerController.preset
                === EqualizerPreset.ROCK, EqualizerController.preset
                === EqualizerPreset.JAZZ, EqualizerController.preset
                === EqualizerPreset.CLASSIC, EqualizerController.preset
                === EqualizerPreset.POP, EqualizerController.preset === EqualizerPreset.CUSTOM]
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.0255
            height: parent.height * 0.15
            backgroundOpacity: 0

            onButtonValueChanged: {
                if (index === 0) {
                    EqualizerController.preset = EqualizerPreset.FLAT
                } else if (index === 1) {
                    EqualizerController.preset = EqualizerPreset.ROCK
                } else if (index === 2) {
                    EqualizerController.preset = EqualizerPreset.JAZZ
                } else if (index === 3) {
                    EqualizerController.preset = EqualizerPreset.CLASSIC
                } else if (index === 4) {
                    EqualizerController.preset = EqualizerPreset.POP
                } else if (index === 5) {
                    EqualizerController.preset = EqualizerPreset.CUSTOM
                }
            }
        }

        RowLayout {
            property double barWidth: parent.width / 15

            width: parent.width * 0.98
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.025
            height: parent.height * 0.75

            EqualizerBar {
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                value: EqualizerController.preamp
                labelText: "Preamp"
                onValueChanged: {
                    if (value !== EqualizerController.preamp) {
                        EqualizerController.preamp = value
                    }
                }
            }

            EqualizerBar {
                id: dcBar
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                labelText: "DC"
                value: EqualizerController.frequencies.frequency1
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency1) {
                        EqualizerController.frequencies.frequency1 = value
                    }
                }
            }

            EqualizerBar {
                id: frequencyBar2
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                labelText: "30Hz"
                value: EqualizerController.frequencies.frequency2
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency2) {
                        EqualizerController.frequencies.frequency2 = value
                    }
                }
            }

            EqualizerBar {
                id: frequencyBar3
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                labelText: "60Hz"
                value: EqualizerController.frequencies.frequency3
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency3) {
                        EqualizerController.frequencies.frequency3 = value
                    }
                }
            }

            EqualizerBar {
                id: frequencyBar4
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                labelText: "125Hz"
                value: EqualizerController.frequencies.frequency4
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency4) {
                        EqualizerController.frequencies.frequency4 = value
                    }
                }
            }

            EqualizerBar {
                id: frequencyBar5
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                labelText: "250Hz"
                value: EqualizerController.frequencies.frequency5
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency5) {
                        EqualizerController.frequencies.frequency5 = value
                    }
                }
            }

            EqualizerBar {
                id: frequencyBar6
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                labelText: "500Hz"
                value: EqualizerController.frequencies.frequency6
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency6) {
                        EqualizerController.frequencies.frequency6 = value
                    }
                }
            }

            EqualizerBar {
                id: frequencyBar7
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                labelText: "1KHz"
                value: EqualizerController.frequencies.frequency7
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency7) {
                        EqualizerController.frequencies.frequency7 = value
                    }
                }
            }

            EqualizerBar {
                id: frequencyBar8
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                labelText: "2KHz"
                value: EqualizerController.frequencies.frequency8
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency8) {
                        EqualizerController.frequencies.frequency8 = value
                    }
                }
            }

            EqualizerBar {
                id: frequencyBar9
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                labelText: "4KHz"
                value: EqualizerController.frequencies.frequency9
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency9) {
                        EqualizerController.frequencies.frequency9 = value
                    }
                }
            }

            EqualizerBar {
                id: frequencyBar10
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                labelText: "8KHz"
                value: EqualizerController.frequencies.frequency10
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency10) {
                        EqualizerController.frequencies.frequency10 = value
                    }
                }
            }

            EqualizerBar {
                id: frequencyBar11
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                labelText: "16KHz"
                value: EqualizerController.frequencies.frequency11
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency11) {
                        EqualizerController.frequencies.frequency11 = value
                    }
                }
            }

            EqualizerBar {
                id: codaBar
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                value: EqualizerController.frequencies.frequency12
                labelText: "Coda"
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency12) {
                        EqualizerController.frequencies.frequency12 = value
                    }
                }
            }

            Connections {
                target: EqualizerController
                onFrequenciesChanged: {
                    dcBar.value = EqualizerController.frequencies.frequency1
                    frequencyBar2.value = EqualizerController.frequencies.frequency2
                    frequencyBar3.value = EqualizerController.frequencies.frequency3
                    frequencyBar4.value = EqualizerController.frequencies.frequency4
                    frequencyBar5.value = EqualizerController.frequencies.frequency5
                    frequencyBar6.value = EqualizerController.frequencies.frequency6
                    frequencyBar7.value = EqualizerController.frequencies.frequency7
                    frequencyBar8.value = EqualizerController.frequencies.frequency8
                    frequencyBar9.value = EqualizerController.frequencies.frequency9
                    frequencyBar10.value = EqualizerController.frequencies.frequency10
                    frequencyBar11.value = EqualizerController.frequencies.frequency11
                    codaBar.value = EqualizerController.frequencies.frequency12
                }

                onPresetChanged: {
                    presetGroup.buttonValues
                            = [EqualizerController.preset
                               === EqualizerPreset.FLAT, EqualizerController.preset
                               === EqualizerPreset.ROCK, EqualizerController.preset
                               === EqualizerPreset.JAZZ, EqualizerController.preset
                               === EqualizerPreset.CLASSIC, EqualizerController.preset
                               === EqualizerPreset.POP, EqualizerController.preset
                               === EqualizerPreset.CUSTOM]
                }
            }
        }
    }
}
