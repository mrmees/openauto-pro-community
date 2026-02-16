import QtQuick 2.11
import "../tools/Runes.js" as Runes

Item {
    property string text
    property string currentText: root.text
    property bool truncated: false

    id: root

    Timer {
        property string currentText: root.text
        property string poppedCharacters: ""
        property bool backward: true
        readonly property int scrollInterval: 200
        readonly property int scrollDelayInterval: 4000

        id: timer
        interval: timer.scrollDelayInterval
        repeat: true
        running: root.text.length > 0

        onTriggered: {
            if (timer.backward) {
                if (root.truncated) {
                    timer.interval = timer.scrollInterval
                    timer.poppedCharacters = Runes.substring(
                                timer.currentText, 0,
                                1) + timer.poppedCharacters
                    timer.currentText = Runes.substring(
                                timer.currentText, 1, timer.currentText.length)
                } else {
                    timer.backward = false
                    timer.interval = timer.scrollDelayInterval
                }
            } else {
                if (timer.poppedCharacters.length > 0) {
                    timer.interval = timer.scrollInterval
                    var charToAdd = Runes.substring(timer.poppedCharacters, 0,
                                                    1)
                    timer.currentText = charToAdd + timer.currentText
                    timer.poppedCharacters = Runes.substring(
                                timer.poppedCharacters, 1,
                                timer.poppedCharacters.length)
                } else {
                    timer.backward = true
                    timer.interval = timer.scrollDelayInterval
                }
            }

            root.currentText = timer.currentText
        }
    }

    onTextChanged: {
        root.reset()
    }

    function reset() {
        root.currentText = root.text
        timer.currentText = root.text
        timer.backward = true
        timer.poppedCharacters = ""
        timer.interval = timer.scrollDelayInterval
        timer.restart()
    }
}
