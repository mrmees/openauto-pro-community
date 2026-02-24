import QtQuick 2.11
import OpenAuto 1.0
import "../../components"
import "../../controls"

AndroidAutoApplicationMenu {
    signal ipAddressEntered(string address)

    title: qsTr("Enter Android Auto device address")

    CustomTextField {
        id: textField
        width: parent.width * 0.6
        height: parent.height * 0.1
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: height * 0.6
        text: keyboard.inputText
    }

    CustomKeyboard {
        id: keyboard
        height: parent.height * 0.75
        anchors.top: textField.bottom
        anchors.topMargin: parent.height * 0.05
        anchors.left: textField.left
        anchors.right: textField.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.05
        delimiter: "."
        onOkClicked: {
            ipAddressEntered(textField.text)
        }
    }
}
