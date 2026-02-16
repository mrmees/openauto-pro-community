import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import OpenAuto.Input 1.0
import "../oainput/qml"
import "controls"

InputRoot {
    signal termsOfServiceAccepted
    signal termsOfServiceAcceptedPermanently
    signal termsOfServiceRejected

    id: root
    active: true
    inputEventManager: globalInputEventManager

    Item {
        id: titleContainer
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.01
        height: parent.height * 0.1
        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter

        SpecialText {
            id: titleLabel
            anchors.fill: parent
            text: qsTr("Terms of service")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            fontPixelSize: parent.height * 0.75
        }
    }

    InputScope {
        anchors.top: titleContainer.bottom
        anchors.topMargin: parent.height * 0.01
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.01
        anchors.left: parent.left
        anchors.right: parent.right
        inputFocus: true

        ScrollableText {
            id: textContainer
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.9
            height: parent.height * 0.885

            text: qsTr("Please read and accept below information before you start using this software.<br><br>You confirm, that software key used for activation of this product has been purchased from official distribution. Using illegal software key will cause the 500 EUR fine. If you suspect that your software key is illegal please contact us at <b>contact@bluewavestudio.io</b>.<br><br>This software is for educational purposes and personal use only. Do not attempt to operate this software while driving. Distraction may cause accidents. Always concentrate on driving and obey local Traffic Regulations. You assume total responsibility and risk for using this software.<br><br>Android Auto implementation is not certified by Google Inc. It is created for R&D purposes and may not work as expected by the original authors. Do not use while driving.<br><br><b>Please use this software with care.</b><br><br>In case of any queries please visit our website at <b>www.bluewavestudio.io.</b>")
            font.family: "Noto Sans, Noto Sans Korean, Noto Color Emoji"
            font.pixelSize: textContainer.height * 0.0425
            color: "white"
        }

        RowLayout {
            anchors.top: textContainer.bottom
            anchors.topMargin: parent.height * 0.025
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            CustomCheckbox {
                id: rememberChoiceCheckbox
                Layout.preferredWidth: parent.width * 0.25
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Remember my choice")
                font.pixelSize: parent.height
            }

            CustomButton {
                id: rejectButton
                Layout.preferredWidth: parent.width * 0.3
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                labelText: qsTr("Reject")

                onTriggered: {
                    termsOfServiceRejected()
                }
            }

            CustomButton {
                id: acceptButton
                Layout.preferredWidth: parent.width * 0.3
                Layout.preferredHeight: parent.height
                Layout.alignment: Qt.AlignHCenter
                labelText: qsTr("Accept")

                onTriggered: {
                    if (rememberChoiceCheckbox.checked) {
                        termsOfServiceAcceptedPermanently()
                    } else {
                        termsOfServiceAccepted()
                    }
                }
            }
        }
    }
}
