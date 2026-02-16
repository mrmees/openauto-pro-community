import QtQuick 2.11

SequentialAnimation {
    property var target: null
    property alias delay: pauseAnimation.duration

    id: root

    PauseAnimation {
        id: pauseAnimation
    }

    ParallelAnimation {
        PropertyAnimation {
            target: root.target
            property: "opacity"
            from: 0
            to: 1
            duration: 300
        }

        PropertyAnimation {
            target: root.target
            property: "scale"
            from: 0.9
            to: 1
            duration: 300
        }
    }
}
