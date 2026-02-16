import QtQuick 2.11
import OpenAuto 1.0
import QtQuick.Layouts 1.11
import "../../controls"

SettingsApplicationMenu {
    id: root
    title: qsTr("Autobox settings")

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

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Screen DPI")

                from: 0
                to: 500
                value: ConfigurationController.autoboxDPI

                onPositionChanged: {
                    ConfigurationController.autoboxDPI = valueAt(position)
                }
            }

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Show Top Bar in Autobox")
                checked: ConfigurationController.showTopBarInAutobox

                onCheckedChanged: {
                    ConfigurationController.showTopBarInAutobox = checked
                }
            }

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Show clock in Autobox")
                checked: ConfigurationController.showClockInAutobox

                onCheckedChanged: {
                    ConfigurationController.showClockInAutobox = checked
                }
            }

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Automatic wireless connection")
                checked: ConfigurationController.autoboxAutomaticWirelessConnection

                onCheckedChanged: {
                    ConfigurationController.autoboxAutomaticWirelessConnection = checked
                }
            }
        }
    }
}
