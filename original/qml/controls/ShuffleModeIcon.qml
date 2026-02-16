import QtQuick 2.11
import OpenAuto 1.0
import QtGraphicalEffects 1.0

Item {
    property alias radius: inner.radius
    property alias border: inner.border
    property var color

    id: root

    Rectangle {
        id: inner
        color: Qt.darker(root.color, 4)
        anchors.fill: parent
        radius: root.radius
    }

    RadialGradient {
        cached: true
        anchors.fill: parent
        source: inner
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: root.color
            }
            GradientStop {
                position: 0.9
                color: Qt.darker(root.color, 2)
            }
        }
    }
}
