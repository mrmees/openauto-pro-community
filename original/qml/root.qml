import QtQuick 2.11

Item {
    property alias interval: pressAndHoldTimer.interval

    signal released
    signal pressed
    signal canceled
    signal entered
    signal exited
    property alias hoverEnabled: mouseArea.hoverEnabled
    property alias controlTouchEvents: mouseArea.enabled

    id: root

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onPressed: {
            if(interval > 0)
            {
                pressAndHoldTimer.start();
            }
            else
            {
                root.pressed();
            }

            mouse.accepted = true;
        }

        onReleased: {
            canceled();
            root.released();
            mouse.accepted = true;
        }

        onCanceled: {
            if(pressAndHoldTimer.running) {
                pressAndHoldTimer.stop();
            } else {
                root.canceled();
            }
        }

        onEntered: {
            root.entered();
        }

        onExited: {
            root.exited();
        }
    }

    Timer {
        id: pressAndHoldTimer
        interval: 0
        onTriggered: {
            root.focused();
        }
    }
}
