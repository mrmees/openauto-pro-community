import QtQuick 2.11
import OpenAuto 1.0
import "../../controls"
import "../../components"

TelephoneApplicationMenu {
    id: root
    title: qsTr("Dial number")

    Item {
        id: container

        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.bottom: parent.bottom

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
            mode: KeyboardMode.DIALPAD
            height: parent.height * 0.75
            anchors.top: textField.bottom
            anchors.topMargin: parent.height * 0.05
            anchors.left: textField.left
            anchors.right: textField.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.05
            delimiter: "+"
            okButtonLabel: qsTr("Dial")
            onOkClicked: {
                VoiceCallController.dial(textField.text)
            }
        }
    }
}
