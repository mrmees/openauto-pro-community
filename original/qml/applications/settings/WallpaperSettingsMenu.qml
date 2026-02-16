import QtQuick 2.11
import OpenAuto 1.0
import QtQuick.Layouts 1.11
import "../../controls"
import "../../components"

SettingsApplicationMenu {
    signal moreClicked

    id: root
    title: qsTr("Appearance settings")

    Item {
        property real parameterBoxSize: height * 0.14

        id: container

        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.bottom: parent.bottom

        ColumnLayout {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Time format")
                buttonLabels: ["12h", "24h"]
                buttonValues: [ConfigurationController.timeFormat
                    === TimeFormat.FORMAT_12H, ConfigurationController.timeFormat
                    === TimeFormat.FORMAT_24H]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.timeFormat = TimeFormat.FORMAT_12H
                    } else if (index === 1) {
                        ConfigurationController.timeFormat = TimeFormat.FORMAT_24H
                    }
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Temperature unit")
                buttonLabels: ["°C", "°F"]
                buttonValues: [ConfigurationController.temperatureUnit
                    === TemperatureUnit.CELCIUS, ConfigurationController.temperatureUnit
                    === TemperatureUnit.FAHRENHEIT]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.temperatureUnit = TemperatureUnit.CELCIUS
                    } else if (index === 1) {
                        ConfigurationController.temperatureUnit = TemperatureUnit.FAHRENHEIT
                    }
                }
            }

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Show temperature")
                checked: ConfigurationController.showTemperature

                onCheckedChanged: {
                    ConfigurationController.showTemperature = checked
                }
            }

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Controls opacity")

                from: 0
                to: 100
                value: ConfigurationController.controlsOpacity

                onPositionChanged: {
                    ConfigurationController.controlsOpacity = valueAt(position)
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Handedness of traffic")
                buttonLabels: [qsTr("Left"), qsTr("Right")]
                buttonValues: [ConfigurationController.handednessOfTraffic
                    === HandednessOfTrafficType.LEFT_HAND_DRIVE, ConfigurationController.handednessOfTraffic
                    === HandednessOfTrafficType.RIGHT_HAND_DRIVE]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.handednessOfTraffic
                                = HandednessOfTrafficType.LEFT_HAND_DRIVE
                    } else if (index === 1) {
                        ConfigurationController.handednessOfTraffic
                                = HandednessOfTrafficType.RIGHT_HAND_DRIVE
                    }
                }
            }

            NextLevelButton {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("More...")
                onTriggered: {
                    root.moreClicked()
                }
            }
        }
    }
}
