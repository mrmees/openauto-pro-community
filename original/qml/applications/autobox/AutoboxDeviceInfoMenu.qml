import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"

AutoboxApplicationMenu {
    signal browseClicked
    signal enterSerialNumberClicked
    signal finishSetupClicked

    title: qsTr("Setup Autobox plugin")
    id: root

    Item {
        id: container
        anchors.centerIn: parent
        width: parent.width * 0.95
        height: parent.height * 0.7

        ControlBackground {
            radius: height * 0.025
        }

        NormalText {
            id: titleText
            fontPixelSize: height * 0.38
            text: qsTr("Setup your instance of plugin in order to use <b>Autobox</b> device with OpenAuto Pro.<br><b>Do not have the plugin yet? </b>Visit our web page at <b>www.bluewavestudio.io</b> to get it!")
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            textFormat: Text.RichText
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.125
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.025
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.05
            height: parent.height * 0.15
        }

        RowLayout {
            id: pluginDetailsContainer
            anchors.top: titleText.bottom
            anchors.topMargin: parent.height * 0.15
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height * 0.5
            width: parent.width * 0.9

            Item {
                NormalText {
                    id: selectPluginFileText
                    anchors.top: parent.top
                    anchors.topMargin: height * 0.1
                    width: parent.width
                    height: parent.height * 0.25
                    fontPixelSize: height * 0.41
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("1. Select plugin file")
                }

                Item {
                    anchors.top: selectPluginFileText.bottom
                    anchors.bottom: browseButton.top
                    width: parent.width

                    Image {
                        width: parent.height * 0.6
                        height: width
                        anchors.centerIn: parent
                        source: LicenseController.autoboxPluginValid ? "/images/ico_done.svg" : "/images/ico_fail.svg"
                    }
                }

                CustomButton {
                    id: browseButton
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: height * 0.1
                    width: parent.width * 0.9
                    height: parent.height * 0.25
                    anchors.horizontalCenter: parent.horizontalCenter
                    labelText: qsTr("Browse...")

                    onTriggered: {
                        root.browseClicked()
                    }
                }

                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.width * 0.25
            }

            Item {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.width * 0.05

                Image {
                    width: parent.width
                    height: parent.height * 0.2
                    anchors.centerIn: parent
                    source: "/images/ico_arrow_right.png"
                }
            }

            Item {
                NormalText {
                    id: enterSerialNumberText
                    anchors.top: parent.top
                    anchors.topMargin: height * 0.1
                    width: parent.width
                    height: parent.height * 0.25
                    fontPixelSize: height * 0.41
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("2. Enter serial number")
                }

                Item {
                    anchors.top: enterSerialNumberText.bottom
                    anchors.bottom: enterSerialNumberButton.top
                    width: parent.width

                    Image {
                        width: parent.height * 0.6
                        height: width
                        anchors.centerIn: parent
                        source: (LicenseController.autoboxPluginValid
                                 && LicenseController.autoboxLicenseValid) ? "/images/ico_done.svg" : "/images/ico_fail.svg"
                    }
                }

                CustomButton {
                    id: enterSerialNumberButton
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: height * 0.1
                    width: parent.width * 0.9
                    height: parent.height * 0.25
                    anchors.horizontalCenter: parent.horizontalCenter
                    labelText: qsTr("Enter serial...")

                    onTriggered: {
                        if (LicenseController.autoboxPluginValid) {
                            root.enterSerialNumberClicked()
                        }
                    }
                }

                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.width * 0.25
            }

            Item {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.width * 0.05

                Image {
                    width: parent.width
                    height: parent.height * 0.2
                    anchors.centerIn: parent
                    source: "/images/ico_arrow_right.png"
                }
            }

            Item {
                NormalText {
                    id: finishSetupText
                    anchors.top: parent.top
                    anchors.topMargin: height * 0.1
                    width: parent.width
                    height: parent.height * 0.25
                    fontPixelSize: height * 0.41
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("3. Finish setup")
                }

                Item {
                    anchors.top: finishSetupText.bottom
                    anchors.bottom: finishSetupButton.top
                    width: parent.width

                    Image {
                        width: parent.height * 0.6
                        height: width
                        anchors.centerIn: parent
                        source: (LicenseController.autoboxPluginValid
                                 && LicenseController.autoboxLicenseValid) ? "/images/ico_done.svg" : "/images/ico_fail.svg"
                    }
                }

                CustomButton {
                    id: finishSetupButton
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: height * 0.1
                    width: parent.width * 0.9
                    height: parent.height * 0.25
                    anchors.horizontalCenter: parent.horizontalCenter
                    labelText: qsTr("Finish setup...")

                    onTriggered: {
                        if (LicenseController.autoboxPluginValid
                                && LicenseController.autoboxLicenseValid) {
                            root.finishSetupClicked()
                        }
                    }
                }

                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.width * 0.25
            }
        }
    }
}
