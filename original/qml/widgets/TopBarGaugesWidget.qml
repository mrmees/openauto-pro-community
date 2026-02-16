import QtQuick 2.11
import OpenAuto 1.0
import "../controls"
import "../tools/ClockTools.js" as ClockTools

CustomText {
    id: root
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    color: ThemeController.normalFontColor
    font.family: "Noto Sans, Noto Sans Korean, Noto Color Emoji"
    font.weight: Font.Bold
    font.bold: true

    function updateTime() {
        var date = new Date

        if (ConfigurationController.timeFormat === TimeFormat.FORMAT_12H) {
            text = ClockTools.get12HTime(date)
        } else {
            text = ClockTools.get24HTime(date)
        }
    }

    Connections {
        target: ConfigurationController
        onTimeFormatChanged: {
            updateTime()
        }
    }

    Component.onCompleted: {
        updateTime()
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            updateTime()
        }
    }
}
