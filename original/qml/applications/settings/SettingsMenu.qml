import QtQuick 2.11
import OpenAuto 1.0
import QtQuick.Layouts 1.11
import "../../controls"
import "../../components"

SettingsApplicationMenu {
    signal optionsTriggered

    id: root
    title: qsTr("Rear camera settings")

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

            LabeledSpinBox {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("GPIO Pin")
                minValue: 0
                maxValue: 50
                onValueChanged: {
                    ConfigurationController.rearCameraGpioPin = value
                }

                Component.onCompleted: {
                    setValue(ConfigurationController.rearCameraGpioPin)
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Backend type")
                buttonLabels: ["V4L2", "Finder", "Script"]
                buttonValues: [ConfigurationController.rearCameraBackendType
                    === RearCameraBackendType.V4L2, ConfigurationController.rearCameraBackendType
                    === RearCameraBackendType.VIEW_FINDER, ConfigurationController.rearCameraBackendType
                    === RearCameraBackendType.SCRIPT]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.rearCameraBackendType = RearCameraBackendType.V4L2
                    } else if (index === 1) {
                        ConfigurationController.rearCameraBackendType
                                = RearCameraBackendType.VIEW_FINDER
                    } else if (index === 2) {
                        ConfigurationController.rearCameraBackendType = RearCameraBackendType.SCRIPT
                    }
                }
            }

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Show guide line")
                checked: ConfigurationController.showRearCameraGuideLine
                visible: ConfigurationController.rearCameraBackendType
                         !== RearCameraBackendType.SCRIPT

                onCheckedChanged: {
                    ConfigurationController.showRearCameraGuideLine = checked
                }
            }

            RadioButtonsGroup {
                id: rearCameraOrientationGroup
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Orientation")
                buttonLabels: ["0°", "90°", "180°", "270°"]
                visible: ConfigurationController.rearCameraBackendType
                         !== RearCameraBackendType.SCRIPT
                buttonValues: [ConfigurationController.rearCameraOrientation
                    === OrientationType.ORIENTATION_0, ConfigurationController.rearCameraOrientation
                    === OrientationType.ORIENTATION_90, ConfigurationController.rearCameraOrientation
                    === OrientationType.ORIENTATION_180, ConfigurationController.rearCameraOrientation
                    === OrientationType.ORIENTATION_270]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.rearCameraOrientation
                                = OrientationType.ORIENTATION_0
                    } else if (index === 1) {
                        ConfigurationController.rearCameraOrientation
                                = OrientationType.ORIENTATION_90
                    } else if (index === 2) {
                        ConfigurationController.rearCameraOrientation
                                = OrientationType.ORIENTATION_180
                    } else if (index === 3) {
                        ConfigurationController.rearCameraOrientation
                                = OrientationType.ORIENTATION_270
                    }
                }
            }

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Resolution width")

                from: 320
                to: 1920
                value: ConfigurationController.rearCameraResolutionWidth
                visible: ConfigurationController.rearCameraBackendType
                         === RearCameraBackendType.VIEW_FINDER

                onPositionChanged: {
                    ConfigurationController.rearCameraResolutionWidth = valueAt(
                                position)
                }
            }

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Resolution height")

                from: 240
                to: 1080
                value: ConfigurationController.rearCameraResolutionHeight
                visible: ConfigurationController.rearCameraBackendType
                         === RearCameraBackendType.VIEW_FINDER

                onPositionChanged: {
                    ConfigurationController.rearCameraResolutionHeight = valueAt(
                                position)
                }
            }
        }
    }
}
