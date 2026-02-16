import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"

TelephoneApplicationMenu {
    signal pairingDone
    property string deviceName: ""
    property string passkey: ""

    id: root
    title: qsTr("Add device")

    Item {
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.05
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.925
        height: parent.height * 0.325

        ControlBackground {
            radius: height * 0.1
        }

        Image {
            id: pairingGuideIcon
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.025
            anchors.verticalCenter: parent.verticalCenter
            height: parent.width * 0.075
            width: height
            source: "/images/ico_info.svg"
        }

        NormalText {
            id: pairingGuide
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.025
            anchors.bottom: parent.bottom
            anchors.bottomMargin: pairingGuide.topMargin
            anchors.left: pairingGuideIcon.right
            anchors.leftMargin: parent.width * 0.012
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.015
            fontPixelSize: parent.width * 0.0225
            text: qsTr("Please use your phone to start searching for Bluetooth devices.<br><br>This device will identify itself as <b>%1</b>").arg(BluetoothController.adapterName)
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Loader {
        id: pinConfirmationContainer
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.075
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.6
        height: parent.height * 0.5
        active: false

        onActiveChanged: {
            root.highlightDefaultControl()
        }

        sourceComponent: Item {
            anchors.fill: parent

            ControlBackground {
                radius: height * 0.05
            }

            NormalText {
                id: passkeyConfirmation
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.1
                anchors.bottom: buttonsContainer.top
                anchors.bottomMargin: passkeyConfirmation.topMargin
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.015
                anchors.right: parent.right
                anchors.rightMargin: passkeyConfirmation.leftMargin
                fontPixelSize: parent.height * 0.09
                text: qsTr("Device <b>%1</b> wants to connect.<br><br>Does code <b>%2</b> match on the device?").arg(root.deviceName).arg(root.passkey)
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                horizontalAlignment: Text.AlignHCenter
            }

            RowLayout {
                id: buttonsContainer
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.1
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.6
                height: parent.height * 0.23
                spacing: width * 0.1

                CustomButton {
                    id: noButton
                    Layout.preferredWidth: parent.width * 0.4
                    Layout.preferredHeight: parent.height
                    labelText: qsTr("No")

                    onTriggered: {
                        root.passkey = ""
                        root.deviceName = ""
                        pinConfirmationContainer.active = false
                        BluetoothController.reject()
                    }
                }

                CustomButton {
                    id: yesButton
                    Layout.preferredWidth: parent.width * 0.4
                    Layout.preferredHeight: parent.height
                    labelText: qsTr("Yes")

                    onTriggered: {
                        root.pairingDone()
                        BluetoothController.confirm()
                    }
                }
            }
        }
    }

    Connections {
        target: BluetoothController

        onConfirmationRequested: {
            root.passkey = passkey
            root.deviceName = deviceName
            pinConfirmationContainer.active = true
        }
    }

    Component.onCompleted: {
        BluetoothController.beginPairing()
    }

    Component.onDestruction: {
        BluetoothController.endPairing()
    }
}
