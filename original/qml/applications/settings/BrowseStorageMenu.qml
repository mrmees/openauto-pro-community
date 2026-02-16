import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"

SettingsApplicationMenu {
    id: root
    title: qsTr("Day/Night settings")
    defaultControl: openAutoDayNightModeControllerGroup.getActiveButton()

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
                id: openAutoDayNightModeControllerGroup
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: "OpenAuto"
                buttonLabels: [qsTr("Sensor"), qsTr("Clock"), qsTr(
                        "GPIO"), qsTr("Manual")]
                buttonValues: [ConfigurationController.openAutoDayNightModeController
                    === DayNightModeControllerType.SENSOR, ConfigurationController.openAutoDayNightModeController
                    === DayNightModeControllerType.CLOCK, ConfigurationController.openAutoDayNightModeController
                    === DayNightModeControllerType.GPIO, ConfigurationController.openAutoDayNightModeController
                    === DayNightModeControllerType.MANUAL]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.openAutoDayNightModeController
                                = DayNightModeControllerType.SENSOR
                    } else if (index === 1) {
                        ConfigurationController.openAutoDayNightModeController
                                = DayNightModeControllerType.CLOCK
                    } else if (index === 2) {
                        ConfigurationController.openAutoDayNightModeController
                                = DayNightModeControllerType.GPIO
                    } else if (index === 3) {
                        ConfigurationController.openAutoDayNightModeController
                                = DayNightModeControllerType.MANUAL
                    }
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Android Auto")
                buttonLabels: [qsTr("Sensor"), qsTr("Clock"), qsTr(
                        "GPIO"), qsTr("Manual")]
                buttonValues: [ConfigurationController.androidAutoDayNightModeController
                    === DayNightModeControllerType.SENSOR, ConfigurationController.androidAutoDayNightModeController
                    === DayNightModeControllerType.CLOCK, ConfigurationController.androidAutoDayNightModeController
                    === DayNightModeControllerType.GPIO, ConfigurationController.androidAutoDayNightModeController
                    === DayNightModeControllerType.MANUAL]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.androidAutoDayNightModeController
                                = DayNightModeControllerType.SENSOR
                    } else if (index === 1) {
                        ConfigurationController.androidAutoDayNightModeController
                                = DayNightModeControllerType.CLOCK
                    } else if (index === 2) {
                        ConfigurationController.androidAutoDayNightModeController
                                = DayNightModeControllerType.GPIO
                    } else if (index === 3) {
                        ConfigurationController.androidAutoDayNightModeController
                                = DayNightModeControllerType.MANUAL
                    }
                }
            }

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Sensor threshold")

                from: 0
                to: 100
                value: ConfigurationController.lightSensorThreshold
                visible: ConfigurationController.openAutoDayNightModeController
                         === DayNightModeControllerType.SENSOR
                         || ConfigurationController.androidAutoDayNightModeController
                         === DayNightModeControllerType.SENSOR
                onPositionChanged: {
                    ConfigurationController.lightSensorThreshold = valueAt(
                                position)
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Default Android Auto mode")
                buttonLabels: [qsTr("None"), qsTr("Day"), qsTr("Night")]
                buttonValues: [ConfigurationController.defaultAndroidAutoDayNightMode
                    === DayNightModeType.NONE, ConfigurationController.defaultAndroidAutoDayNightMode
                    === DayNightModeType.DAY, ConfigurationController.defaultAndroidAutoDayNightMode
                    === DayNightModeType.NIGHT]
                visible: ConfigurationController.androidAutoDayNightModeController
                         === DayNightModeControllerType.MANUAL

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.defaultAndroidAutoDayNightMode
                                = DayNightModeType.NONE
                    } else if (index === 1) {
                        ConfigurationController.defaultAndroidAutoDayNightMode
                                = DayNightModeType.DAY
                    } else if (index === 2) {
                        ConfigurationController.defaultAndroidAutoDayNightMode
                                = DayNightModeType.NIGHT
                    }
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Open Auto mode")
                buttonLabels: [qsTr("Day"), qsTr("Night")]
                buttonValues: [ConfigurationController.openAutoDayNightMode
                    === DayNightModeType.DAY, ConfigurationController.openAutoDayNightMode
                    === DayNightModeType.NIGHT]
                visible: ConfigurationController.openAutoDayNightModeController
                         === DayNightModeControllerType.MANUAL

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.openAutoDayNightMode = DayNightModeType.DAY
                    } else if (index === 1) {
                        ConfigurationController.openAutoDayNightMode = DayNightModeType.NIGHT
                    }
                }
            }

            HourMinuteSetter {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Sunrise time")
                visible: ConfigurationController.openAutoDayNightModeController
                         === DayNightModeControllerType.CLOCK
                         || ConfigurationController.androidAutoDayNightModeController
                         === DayNightModeControllerType.CLOCK
                minHour: 0
                maxHour: 11

                onValueChanged: {
                    ConfigurationController.sunriseTime = value
                }

                Component.onCompleted: {
                    setValue(ConfigurationController.sunriseTime)
                }
            }

            HourMinuteSetter {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Sunset time")
                visible: ConfigurationController.openAutoDayNightModeController
                         === DayNightModeControllerType.CLOCK
                         || ConfigurationController.androidAutoDayNightModeController
                         === DayNightModeControllerType.CLOCK
                minHour: 12
                maxHour: 23

                onValueChanged: {
                    ConfigurationController.sunsetTime = value
                }

                Component.onCompleted: {
                    setValue(ConfigurationController.sunsetTime)
                }
            }

            LabeledSpinBox {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("GPIO Pin")
                minValue: 1
                maxValue: 50
                visible: ConfigurationController.openAutoDayNightModeController
                         === DayNightModeControllerType.GPIO
                         || ConfigurationController.androidAutoDayNightModeController
                         === DayNightModeControllerType.GPIO
                onValueChanged: {
                    ConfigurationController.dayNightGpioPin = value
                }

                Component.onCompleted: {
                    setValue(ConfigurationController.dayNightGpioPin)
                }
            }
        }
    }
}
