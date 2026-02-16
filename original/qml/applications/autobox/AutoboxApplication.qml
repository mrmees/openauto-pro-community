import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"

AutoboxApplicationMenu {
    title: qsTr("Autobox info")
    id: root

    Item {
        id: container
        anchors.centerIn: parent
        width: parent.width * 0.85
        height: parent.height * 0.55

        ControlBackground {
            radius: height * 0.025
        }

        ColumnLayout {
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.065
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.025
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.025
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.065
            spacing: parent.height * 0.05

            NormalText {
                fontPixelSize: container.width * 0.0225
                text: qsTr("<b>Firmware version:</b> %1").arg(AutoboxController.firmwareVersion)
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                Layout.preferredWidth: parent.width
                horizontalAlignment: Text.AlignHLeft
            }

            NormalText {
                fontPixelSize: container.width * 0.0225
                text: qsTr("<b>WiFi name:</b> %1").arg(AutoboxController.wifiName)
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                Layout.preferredWidth: parent.width
                horizontalAlignment: Text.AlignHLeft
            }

            NormalText {
                fontPixelSize: container.width * 0.0225
                text: qsTr("<b>Bluetooth name:</b> %1").arg(AutoboxController.bluetoothName)
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                Layout.preferredWidth: parent.width
                horizontalAlignment: Text.AlignHLeft
            }

            NormalText {
                fontPixelSize: container.width * 0.0225
                text: qsTr("<b>Recent device address:</b> %1").arg(AutoboxController.recentDeviceAddress)
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                Layout.preferredWidth: parent.width
                horizontalAlignment: Text.AlignHLeft
            }

            NormalText {
                fontPixelSize: container.width * 0.0225
                text: qsTr("<b>Recent device name:</b> %1").arg(AutoboxController.recentDeviceName)
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                Layout.preferredWidth: parent.width
                horizontalAlignment: Text.AlignHLeft
            }
        }

        CustomButton {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.065
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.025
            width: parent.width * 0.25
            height: parent.height * 0.175
            labelText: qsTr("Reset recent")

            onTriggered: {
                AutoboxController.resetRecentDevice()
            }
        }
    }
}
