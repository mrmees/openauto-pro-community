import QtQuick 2.11
import OpenAuto 1.0
import QtQuick.Layouts 1.11
import "../../controls"
import "../../components"

SettingsApplicationMenu {
    id: root
    title: qsTr("Volume settings")

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
                labelText: qsTr("Volume step")

                from: 1
                to: 30
                value: ConfigurationController.volumeStep

                onPositionChanged: {
                    ConfigurationController.volumeStep = valueAt(position)
                }
            }

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Storage music Preamp")

                from: 0
                to: 100
                value: ConfigurationController.mediaStorageMusicVolumeLevel

                onPositionChanged: {
                    ConfigurationController.mediaStorageMusicVolumeLevel = valueAt(
                                position)
                }
            }

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Reverse gear volume")
                checked: ConfigurationController.rearGearVolumeLevelEnabled
                onCheckedChanged: {
                    ConfigurationController.rearGearVolumeLevelEnabled = checked
                }
            }

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Reverse gear volume level")
                visible: ConfigurationController.rearGearVolumeLevelEnabled

                from: 0
                to: 100
                value: ConfigurationController.rearGearVolumeLevel

                onPositionChanged: {
                    ConfigurationController.rearGearVolumeLevel = valueAt(
                                position)
                }
            }
        }
    }
}
