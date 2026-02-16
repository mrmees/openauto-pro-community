import QtQuick 2.11
import QtGraphicalEffects 1.0

Item {
    property string startColor
    property string endColor
    id: root

    Item {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.5

        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(width, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: root.startColor }
                GradientStop { position: 1.0; color: root.endColor }
            }
        }
    }

    Item {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.5

        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(width, 0)
            gradient: Gradient {
                GradientStop { position: 0.0; color: root.endColor }
                GradientStop { position: 1.0; color: root.startColor }
            }
        }
    }
}
