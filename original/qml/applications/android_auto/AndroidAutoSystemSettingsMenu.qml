import QtQuick 2.11
import OpenAuto 1.0
import QtQuick.Layouts 1.11
import "../../controls"

SettingsApplicationMenu {
    signal manageGesturesClicked

    id: root
    title: qsTr("Gesture settings")

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

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Enable gestures")
                checked: ConfigurationController.gesturesEnabled
                onCheckedChanged: {
                    ConfigurationController.gesturesEnabled = checked
                }
            }

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Inactivity timeout")

                from: 0
                to: 60
                value: ConfigurationController.gesturesInactivityTimeout

                onPositionChanged: {
                    ConfigurationController.gesturesInactivityTimeout = valueAt(
                                position)
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Sensor orientation")
                buttonLabels: ["0°", "90°", "180°", "270°"]
                buttonValues: [ConfigurationController.gestureSensorOrientation
                    === OrientationType.ORIENTATION_0, ConfigurationController.gestureSensorOrientation
                    === OrientationType.ORIENTATION_90, ConfigurationController.gestureSensorOrientation
                    === OrientationType.ORIENTATION_180, ConfigurationController.gestureSensorOrientation
                    === OrientationType.ORIENTATION_270]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.gestureSensorOrientation
                                = OrientationType.ORIENTATION_0
                    } else if (index === 1) {
                        ConfigurationController.gestureSensorOrientation
                                = OrientationType.ORIENTATION_90
                    } else if (index === 2) {
                        ConfigurationController.gestureSensorOrientation
                                = OrientationType.ORIENTATION_180
                    } else if (index === 3) {
                        ConfigurationController.gestureSensorOrientation
                                = OrientationType.ORIENTATION_270
                    }
                }
            }

            NextLevelButton {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Manage gestures")
                onTriggered: {
                    root.manageGesturesClicked()
                }
            }
        }
    }
}
