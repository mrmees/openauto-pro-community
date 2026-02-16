import QtQuick 2.11
import OpenAuto 1.0
import QtQuick.Layouts 1.11
import "../../controls"

SettingsApplicationMenu {
    id: root
    title: qsTr("Mirroring settings")

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
            height: container.parameterBoxSize * 2

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Resolution width")

                from: 800
                to: 1920
                value: ConfigurationController.mirroringResolutionWidth

                onPositionChanged: {
                    ConfigurationController.mirroringResolutionWidth = valueAt(
                                position)
                }
            }

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Resolution height")

                from: 480
                to: 1080
                value: ConfigurationController.mirroringResolutionHeight

                onPositionChanged: {
                    ConfigurationController.mirroringResolutionHeight = valueAt(
                                position)
                }
            }

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Show Top Bar in Mirroring")
                checked: ConfigurationController.showTopBarInMirroring

                onCheckedChanged: {
                    ConfigurationController.showTopBarInMirroring = checked
                }
            }

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Show clock in Mirroring")
                checked: ConfigurationController.showClockInMirroring

                onCheckedChanged: {
                    ConfigurationController.showClockInMirroring = checked
                }
            }
        }
    }
}
