import QtQuick 2.11
import OpenAuto 1.0
import QtQuick.Layouts 1.11
import "../../controls"
import "../../components"

SettingsApplicationMenu {
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

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Show clock")
                checked: ConfigurationController.showClockInOpenAuto

                onCheckedChanged: {
                    ConfigurationController.showClockInOpenAuto = checked
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("OBD bar display mode")
                buttonLabels: [qsTr("None"), qsTr("Projection"), qsTr("Always")]
                buttonValues: [ConfigurationController.obdBarDisplayModeType
                    === ObdBarDisplayModeType.NONE, ConfigurationController.obdBarDisplayModeType
                    === ObdBarDisplayModeType.PROJECTION, ConfigurationController.obdBarDisplayModeType
                    === ObdBarDisplayModeType.ALWAYS]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.obdBarDisplayModeType = ObdBarDisplayModeType.NONE
                    } else if (index === 1) {
                        ConfigurationController.obdBarDisplayModeType
                                = ObdBarDisplayModeType.PROJECTION
                    } else if (index === 2) {
                        ConfigurationController.obdBarDisplayModeType = ObdBarDisplayModeType.ALWAYS
                    }
                }
            }

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Font scale")

                from: -100
                to: 100
                value: ConfigurationController.fontScale

                onPositionChanged: {
                    ConfigurationController.fontScale = valueAt(position)
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Tile style")
                buttonLabels: [qsTr("Big"), qsTr("Small"), qsTr("Circle")]
                buttonValues: [ConfigurationController.tileStyle
                    === TileStyle.BIG, ConfigurationController.tileStyle
                    === TileStyle.SMALL, ConfigurationController.tileStyle === TileStyle.CIRCLE]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.tileStyle = TileStyle.BIG
                    } else if (index === 1) {
                        ConfigurationController.tileStyle = TileStyle.SMALL
                    } else if (index === 2) {
                        ConfigurationController.tileStyle = TileStyle.CIRCLE
                    }
                }
            }
        }
    }
}
