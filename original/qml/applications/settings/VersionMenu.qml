import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"

SettingsApplicationMenu {
    id: root
    title: qsTr("Android Auto system settings")

    Item {
        property real parameterBoxSize: height * 0.14
        property real parameterFontSize: height * 0.04

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
            height: container.parameterBoxSize * 3

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Start Android Auto automatically")
                checked: ConfigurationController.androidAutoAutostart

                onCheckedChanged: {
                    ConfigurationController.androidAutoAutostart = checked
                }
            }

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Wireless Android Auto")
                checked: ConfigurationController.wirelessEnabled

                onCheckedChanged: {
                    ConfigurationController.wirelessEnabled = checked
                }
            }

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Use touchscreen in Android Auto")
                checked: ConfigurationController.hasTouchscreen

                onCheckedChanged: {
                    ConfigurationController.hasTouchscreen = checked
                }
            }

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Show Top Bar in Android Auto")
                checked: ConfigurationController.showTopBarInAndroidAuto

                onCheckedChanged: {
                    ConfigurationController.showTopBarInAndroidAuto = checked
                }
            }

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Show clock in Android Auto")
                checked: ConfigurationController.showClockInAndroidAuto

                onCheckedChanged: {
                    ConfigurationController.showClockInAndroidAuto = checked
                }
            }
        }
    }
}
