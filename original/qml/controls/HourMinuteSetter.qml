import QtQuick 2.11

Item {
    property string iconSource
    property alias from: slider.from
    property alias to: slider.to
    property alias value: slider.value
    property alias position: slider.position
    property alias snapMode: slider.snapMode
    property alias pressed: slider.pressed
    property alias scrollingActive: slider.scrollingActive
    property alias stepSize: slider.stepSize
    property bool clickableIcon: false
    property alias readOnly: slider.readOnly
    signal iconTriggered

    id: root

    Loader {
        id: iconContainer
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        width: parent.height
        height: parent.height
        sourceComponent: root.clickableIcon ? clickableIconComponent : iconComponent

        Component {
            id: iconComponent

            Icon {
                source: root.iconSource
                anchors.centerIn: parent
                width: height
                height: parent.height
            }
        }

        Component {
            id: clickableIconComponent

            BarIcon {
                anchors.centerIn: parent
                width: height
                height: parent.height
                source: root.iconSource
                onTriggered: {
                    root.iconTriggered()
                }
            }
        }
    }

    CustomSlider {
        id: slider
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: iconContainer.right
        anchors.leftMargin: parent.height * 0.25
        anchors.right: parent.right
        height: parent.height * 0.75
    }

    function valueAt(position) {
        var value = (to - from) * position
        return from + (value + 0.5)
    }
}
