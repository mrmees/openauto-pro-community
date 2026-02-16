import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"

SettingsApplicationMenu {
    id: root
    title: qsTr("System settings")

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
            height: container.parameterBoxSize

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Download cover art")
                checked: ConfigurationController.showCoverart

                onCheckedChanged: {
                    ConfigurationController.showCoverart = checked
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Touchscreen type")
                buttonLabels: [qsTr("Single"), qsTr("Multi")]
                buttonValues: [ConfigurationController.touchscreenType
                    === TouchscreenType.SINGLE_TOUCH, ConfigurationController.touchscreenType
                    === TouchscreenType.MULTI_TOUCH]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.touchscreenType = TouchscreenType.SINGLE_TOUCH
                    } else if (index === 1) {
                        ConfigurationController.touchscreenType = TouchscreenType.MULTI_TOUCH
                    }
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Projection orientation")
                buttonLabels: ["0°", "90°", "180°", "270°"]
                buttonValues: [ConfigurationController.projectionOrientation
                    === OrientationType.ORIENTATION_0, ConfigurationController.projectionOrientation
                    === OrientationType.ORIENTATION_90, ConfigurationController.projectionOrientation
                    === OrientationType.ORIENTATION_180, ConfigurationController.projectionOrientation
                    === OrientationType.ORIENTATION_270]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.projectionOrientation
                                = OrientationType.ORIENTATION_0
                    } else if (index === 1) {
                        ConfigurationController.projectionOrientation
                                = OrientationType.ORIENTATION_90
                    } else if (index === 2) {
                        ConfigurationController.projectionOrientation
                                = OrientationType.ORIENTATION_180
                    } else if (index === 3) {
                        ConfigurationController.projectionOrientation
                                = OrientationType.ORIENTATION_270
                    }
                }
            }

//            RadioButtonsGroup {
//                Layout.preferredWidth: parent.width
//                Layout.preferredHeight: container.parameterBoxSize
//                labelText: qsTr("FM Bandwith")
//                buttonLabels: [qsTr("EU"), qsTr("JP"), qsTr("US"), qsTr(
//                        "ITU 1"), qsTr("ITU 2")]
//                buttonValues: [ConfigurationController.fmBandwithType
//                    === FMBandwithType.EU, ConfigurationController.fmBandwithType
//                    === FMBandwithType.JP, ConfigurationController.fmBandwithType
//                    === FMBandwithType.US, ConfigurationController.fmBandwithType
//                    === FMBandwithType.ITU1, , ConfigurationController.fmBandwithType
//                    === FMBandwithType.ITU2]

//                onButtonValueChanged: {
//                    if (index === 0) {
//                        ConfigurationController.fmBandwith = FMBandwithType.EU
//                    } else if (index === 1) {
//                        ConfigurationController.fmBandwith = FMBandwithType.JP
//                    } else if (index === 2) {
//                        ConfigurationController.fmBandwith = FMBandwithType.US
//                    } else if (index === 3) {
//                        ConfigurationController.fmBandwith = FMBandwithType.ITU1
//                    } else if (index === 4) {
//                        ConfigurationController.fmBandwith = FMBandwithType.ITU2
//                    }
//                }
//            }
        }
    }
}
