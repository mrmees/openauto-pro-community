import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"

SettingsApplicationMenu {
    id: root
    title: qsTr("Android Auto video settings")
    defaultControl: videoResolutionGroup.getActiveButton()

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
                id: videoResolutionGroup
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Video resolution")
                buttonLabels: [qsTr("480p"), qsTr("720p"), qsTr("1080p")]
                buttonValues: [ConfigurationController.videoResolution
                    === VideoResolution.RESOLUTION_480p, ConfigurationController.videoResolution
                    === VideoResolution.RESOLUTION_720p, ConfigurationController.videoResolution
                    === VideoResolution.RESOLUTION_1080p]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.videoResolution = VideoResolution.RESOLUTION_480p
                    } else if (index === 1) {
                        ConfigurationController.videoResolution = VideoResolution.RESOLUTION_720p
                    } else if (index === 2) {
                        ConfigurationController.videoResolution = VideoResolution.RESOLUTION_1080p
                    }
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Video FPS")
                buttonLabels: [qsTr("30FPS"), qsTr("60FPS")]
                buttonValues: [ConfigurationController.videoFPS
                    === VideoFPS.FPS_30, ConfigurationController.videoFPS === VideoFPS.FPS_60]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.videoFPS = VideoFPS.FPS_30
                    } else if (index === 1) {
                        ConfigurationController.videoFPS = VideoFPS.FPS_60
                    }
                }
            }

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Vertical margin")

                from: 0
                to: 2000
                value: ConfigurationController.verticalMargin

                onPositionChanged: {
                    ConfigurationController.verticalMargin = valueAt(position)
                }
            }

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Horizontal margin")

                from: 0
                to: 2000
                value: ConfigurationController.horizontalMargin

                onPositionChanged: {
                    ConfigurationController.horizontalMargin = valueAt(position)
                }
            }

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Screen DPI")

                from: 0
                to: 500
                value: ConfigurationController.screenDPI

                onPositionChanged: {
                    ConfigurationController.screenDPI = valueAt(position)
                }
            }
        }
    }
}
