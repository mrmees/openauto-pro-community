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
            property double barWidth: parent.width / 17

            width: parent.width * 0.98
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.025
            height: parent.height * 0.75

            EqualizerBar {
                id: frequencyBar1
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                labelText: "50Hz"
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
                labelText: "100Hz"
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
                labelText: "156Hz"
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
                labelText: "220Hz"
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
                labelText: "311Hz"
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
                labelText: "440Hz"
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
                labelText: "622Hz"
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
                labelText: "880Hz"
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
                labelText: "1250Hz"
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
                labelText: "1750Hz"
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
                labelText: "2.5KHz"
                value: EqualizerController.frequencies.frequency11
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency11) {
                        EqualizerController.frequencies.frequency11 = value
                    }
                }
            }

            EqualizerBar {
                id: frequencyBar12
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                value: EqualizerController.frequencies.frequency12
                labelText: "3.5KHz"
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency12) {
                        EqualizerController.frequencies.frequency12 = value
                    }
                }
            }

            EqualizerBar {
                id: frequencyBar13
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                value: EqualizerController.frequencies.frequency13
                labelText: "5KHz"
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency13) {
                        EqualizerController.frequencies.frequency13 = value
                    }
                }
            }

            EqualizerBar {
                id: frequencyBar14
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                value: EqualizerController.frequencies.frequency14
                labelText: "10KHz"
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency14) {
                        EqualizerController.frequencies.frequency14 = value
                    }
                }
            }

            EqualizerBar {
                id: frequencyBar15
                Layout.preferredWidth: parent.barWidth
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                from: EqualizerController.minValue
                to: EqualizerController.maxValue
                value: EqualizerController.frequencies.frequency15
                labelText: "20KHz"
                onValueChanged: {
                    if (value !== EqualizerController.frequencies.frequency15) {
                        EqualizerController.frequencies.frequency15 = value
                    }
                }
            }

            Connections {
                target: EqualizerController
                onFrequenciesChanged: {
                    frequencyBar1.value = EqualizerController.frequencies.frequency1
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
                    frequencyBar12.value = EqualizerController.frequencies.frequency12
                    frequencyBar13.value = EqualizerController.frequencies.frequency13
                    frequencyBar14.value = EqualizerController.frequencies.frequency14
                    frequencyBar15.value = EqualizerController.frequencies.frequency15
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
