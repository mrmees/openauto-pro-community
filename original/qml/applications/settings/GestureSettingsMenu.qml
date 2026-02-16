import QtQuick 2.11
import OpenAuto 1.0
import QtQuick.Layouts 1.11
import "../../controls"
import "../../components"

SettingsApplicationMenu {
    signal browseForRingtoneClicked
    signal browseForSplashAudioClicked
    signal browseForPhoneNotificationClicked

    id: root
    title: qsTr("Audio settings")

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
                labelText: qsTr("Play music automatically after startup")
                checked: ConfigurationController.autoplay
                onCheckedChanged: {
                    ConfigurationController.autoplay = checked
                }
            }

            FileSetting {
                id: splashAudioFileSetting
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Splash audio")
                pathLabelText: ConfigurationController.audioSplashFilePath

                onBrowseClicked: {
                    root.browseForSplashAudioClicked()
                }

                onResetClicked: {
                    ConfigurationController.audioSplashFilePath = ""
                }
            }

            FileSetting {
                id: ringtoneFileSetting
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Ringtone")
                pathLabelText: ConfigurationController.ringtoneFilePath

                onBrowseClicked: {
                    root.browseForRingtoneClicked()
                }

                onResetClicked: {
                    ConfigurationController.ringtoneFilePath = ""
                }
            }

            FileSetting {
                id: phoneNotificationFileSetting
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Phone notification")
                pathLabelText: ConfigurationController.phoneNotificationFilePath

                onBrowseClicked: {
                    root.browseForPhoneNotificationClicked()
                }

                onResetClicked: {
                    ConfigurationController.phoneNotificationFilePath = ""
                }
            }
        }
    }
}
