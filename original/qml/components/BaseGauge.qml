import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../controls"

Item {
    property int mode: KeyboardMode.NUMERIC
    property string inputText: ""
    property string delimiter
    property alias okButtonLabel: buttonOK.text
    signal okClicked
    signal buttonClicked(string code)

    GridLayout {
        property real itemWidth: width / columns
        property real itemHeight: height / rows

        id: grid
        anchors.fill: parent
        columns: mode === KeyboardMode.HEX ? 5 : 3
        rows: mode === KeyboardMode.HEX ? 4 : 5
        columnSpacing: width * 0.01

        KeyboardButton {
            id: buttonA
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "A"
            visible: mode === KeyboardMode.HEX

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: buttonB
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "B"
            visible: mode === KeyboardMode.HEX

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: button7
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "7"

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: button8
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "8"

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: button9
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "9"

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: buttonC
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "C"
            visible: mode === KeyboardMode.HEX

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: buttonD
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "D"
            visible: mode == KeyboardMode.HEX

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: button4
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "4"

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: button5
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "5"

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: button6
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "6"

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: buttonE
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "E"
            visible: mode === KeyboardMode.HEX

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: buttonF
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "F"
            visible: mode === KeyboardMode.HEX

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: button1
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "1"

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: button2
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "2"

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: button3
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "3"

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: buttonClear
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: qsTr("Clear")
            visible: mode === KeyboardMode.HEX

            onTriggered: {
                inputText = ""
            }
        }

        KeyboardButton {
            id: buttonBackspace
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "<"

            onTriggered: {
                inputText = inputText.substring(0, inputText.length - 1)
            }
        }

        KeyboardButton {
            id: button0
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "0"

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: buttonTab
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: delimiter

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        Item {
            visible: mode === KeyboardMode.NUMERIC
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            opacity: 0
        }

        KeyboardButton {
            id: buttonStar
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "*"
            visible: mode === KeyboardMode.DIALPAD

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        KeyboardButton {
            id: buttonOK
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "OK"

            onTriggered: {
                okClicked()
            }
        }

        KeyboardButton {
            id: buttonHash
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "#"
            visible: mode === KeyboardMode.DIALPAD

            onTriggered: {
                inputText = inputText + text
                buttonClicked(text)
            }
        }

        Item {
            visible: mode === KeyboardMode.NUMERIC
            Layout.preferredWidth: parent.itemWidth
            Layout.preferredHeight: parent.itemHeight
            Layout.fillWidth: true
            Layout.fillHeight: true
            opacity: 0
        }
    }
}
