import QtQuick 2.11
import OpenAuto 1.0
import QtQuick.Layouts 1.11
import "../../controls"

SettingsApplicationMenu {
    id: root
    title: qsTr("Android Auto audio settings")

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
                labelText: qsTr("Multimedia audio channel")
                checked: ConfigurationController.musicAudioChannelEnabled
                onCheckedChanged: {
                    ConfigurationController.musicAudioChannelEnabled = checked
                }
            }

            LabeledSwitcher {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Speech audio channel")
                checked: ConfigurationController.speechAudioChannelEnabled
                onCheckedChanged: {
                    ConfigurationController.speechAudioChannelEnabled = checked
                }
            }
        }
    }
}
