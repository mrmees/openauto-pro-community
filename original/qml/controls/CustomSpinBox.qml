import QtQuick 2.11
import OpenAuto 1.0
import "../../oainput/qml"

TouchControl {
    property alias source: icon.source
    signal clicked

    id: root

    Rectangle {
        id: body
        anchors.centerIn: parent
        width: parent.height
        height: parent.height
        radius: height * 0.5
        color: "transparent"
        border.color: "transparent"
        border.width: height * 0.085

        Icon {
            id: icon
            anchors.fill: parent
        }
    }

    Item {
        id: privateProperties
        property bool autoRepeat: false

        onAutoRepeatChanged: {
            if (privateProperties.autoRepeat) {
                repeatTimer.start()
            }
        }
    }

    onPressed: {
        root.clicked()
        startRepeatTimer.start()
        body.border.color = ThemeController.highlightColor
    }

    onReleased: {
        startRepeatTimer.stop()
        repeatTimer.stop()
        privateProperties.autoRepeat = false
        body.border.color = "transparent"
    }

    Timer {
        id: startRepeatTimer
        interval: 500
        onTriggered: {
            privateProperties.autoRepeat = true
        }
    }

    Timer {
        id: repeatTimer
        interval: 50
        repeat: true

        onTriggered: {
            if (privateProperties.autoRepeat) {
                root.clicked()
            }
        }
    }
}
