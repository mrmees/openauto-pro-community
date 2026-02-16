import QtQuick 2.11
import OpenAuto 1.0
import "../../controls"
import "../../components"

SettingsApplicationMenu {
    id: root
    title: qsTr("Android Auto Bluetooth settings")
    defaultControl: adapterTypeButtonsGroup.getActiveButton()

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

        RadioButtonsGroup {
            id: adapterTypeButtonsGroup
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: container.parameterBoxSize
            labelText: qsTr("Adapter type")
            buttonLabels: [qsTr("None"), qsTr("Local"), qsTr("Remote")]
            buttonValues: [ConfigurationController.bluetoothAdapterType
                === BluetoothAdapterType.NONE, ConfigurationController.bluetoothAdapterType
                === BluetoothAdapterType.LOCAL, ConfigurationController.bluetoothAdapterType
                === BluetoothAdapterType.REMOTE]

            onButtonValueChanged: {
                if (index === 0) {
                    ConfigurationController.bluetoothAdapterType = BluetoothAdapterType.NONE
                } else if (index === 1) {
                    ConfigurationController.bluetoothAdapterType = BluetoothAdapterType.LOCAL
                } else if (index === 2) {
                    ConfigurationController.bluetoothAdapterType = BluetoothAdapterType.REMOTE
                }
            }
        }

        CustomTextField {
            property bool active: false

            id: textField
            width: parent.width * 0.75
            height: parent.height * 0.1
            anchors.top: adapterTypeButtonsGroup.bottom
            anchors.topMargin: parent.height * 0.05
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: height * 0.6
            text: keyboard.inputText
            visible: ConfigurationController.bluetoothAdapterType === BluetoothAdapterType.REMOTE

            onActiveChanged: {
                backgroundColor = active ? "#5f9b29" : "white"
            }

            onTextChanged: {
                textField.active = false
            }

            Component.onCompleted: {
                if (text !== "") {
                    textField.active = true
                }
            }
        }

        CustomKeyboard {
            id: keyboard
            height: parent.height * 0.75
            anchors.top: textField.bottom
            anchors.topMargin: parent.height * 0.05
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.05
            width: textField.width
            anchors.horizontalCenter: parent.horizontalCenter
            mode: KeyboardMode.HEX
            inputText: ConfigurationController.bluetoothRemoteAdapterAddress
            visible: ConfigurationController.bluetoothAdapterType === BluetoothAdapterType.REMOTE
            delimiter: ":"

            onOkClicked: {
                textField.active = true
                ConfigurationController.bluetoothRemoteAdapterAddress = inputText
            }
        }
    }

    Connections {
        target: adapterTypeButtonsGroup
        onButtonValueChanged: {
            textField.visible = ConfigurationController.bluetoothAdapterType
                    === BluetoothAdapterType.REMOTE
            keyboard.visible = ConfigurationController.bluetoothAdapterType
                    === BluetoothAdapterType.REMOTE
        }
    }
}
