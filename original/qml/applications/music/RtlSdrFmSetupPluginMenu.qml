import QtQuick 2.11
import OpenAuto 1.0
import "../../controls"
import "../../components"

MusicApplicationMenu {
    signal validateSerialNumberClicked(var validationParams)

    title: qsTr("RTL-SDR FM serial number")
    id: root

    SpecialText {
        id: enterLicenseInformationText
        text: qsTr("Enter serial number")
        fontPixelSize: parent.height * 0.05
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.05
        anchors.horizontalCenter: parent.horizontalCenter
    }

    CustomTextField {
        id: textField
        width: parent.width * 0.75
        height: parent.height * 0.1
        anchors.top: enterLicenseInformationText.top
        anchors.topMargin: parent.height * 0.1
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: height * 0.6
        text: keyboard.inputText

        onTextChanged: {
            backgroundColor = "white"
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
        delimiter: "-"

        onOkClicked: {
            var validationParams = {
                "result": false,
                "serialNumber": inputText
            }

            validateSerialNumberClicked(validationParams)

            if (!validationParams.result) {
                textField.backgroundColor = "#e56161"
            }
        }
    }

}
