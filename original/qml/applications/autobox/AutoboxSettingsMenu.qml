import QtQuick 2.11
import OpenAuto 1.0
import QtQuick.Layouts 1.11
import "../../controls"
import "../../components"

SettingsApplicationMenu {
    signal optionsClicked

    id: root
    title: qsTr("Wireless settings")

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
                id: wirelessHotspotSwitcher
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Hotspot")
                checked: ConfigurationController.wirelessHotspotEnabled

                onCheckedChanged: {
                    ConfigurationController.wirelessHotspotEnabled = checked
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Hotspot band")
                buttonLabels: ["2.4GHz", "5GHz"]
                buttonValues: [ConfigurationController.wirelessHotspotBand
                    === HotspotBand.BAND_2p4GHz, ConfigurationController.wirelessHotspotBand
                    === HotspotBand.BAND_5GHz]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.wirelessHotspotBand = HotspotBand.BAND_2p4GHz
                    } else if (index === 1) {
                        ConfigurationController.wirelessHotspotBand = HotspotBand.BAND_5GHz
                    }
                }
            }
        }
    }

    Connections {
        target: ConfigurationController
        onWirelessHotspotEnabledChanged: {
            wirelessHotspotSwitcher.checked = ConfigurationController.wirelessHotspotEnabled
        }
    }
}
