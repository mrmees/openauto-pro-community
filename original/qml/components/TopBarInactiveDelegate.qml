import QtQuick 2.11
import OpenAuto 1.0
import OpenAuto.Input 1.0
import "../controls"
import "../../oainput/qml"

InputScope {
    property bool active: false
    property real inactiveHeight
    property real activeHeight
    property string titleText
    property bool titleOnly: false

    id: root
    height: root.active ? root.activeHeight : root.inactiveHeight
    defaultControl: expandTopBarButton

    onInputFocusChanged: {
        if (root.inputFocus) {
            root.highlightDefaultControl()
        } else {
            root.active = false
        }
    }

    onActiveChanged: {
        if (root.active) {
            root.inputFocus = true
            ProjectionFocusController.suspend()
        } else {
            if (topBar.inputFocus) {
                topBar.highlightDefaultControl()
            }

            ProjectionFocusController.resume()
        }
    }

    BarBackground {
        opacity: 1
    }

    TouchControl {
        anchors.fill: parent

        onReleased: {
            if (!active) {
                active = true
            }
        }
    }

    Loader {
        anchors.left: parent.left
        anchors.leftMargin: root.active ? (expandTopBarButton.width + expandTopBarButton.anchors.rightMargin) : expandTopBarButton.anchors.rightMargin
        anchors.right: expandTopBarButton.left
        anchors.rightMargin: expandTopBarButton.width * 0.25
        anchors.top: parent.top
        height: root.active ? root.activeHeight : root.inactiveHeight
        sourceComponent: root.active ? topBarActiveDelegateComponent : topBarInactiveDelegateComponent
    }

    ExpandTopBarButton {
        id: expandTopBarButton
        anchors.right: parent.right
        anchors.rightMargin: height * 0.25
        anchors.bottom: parent.bottom
        width: inactiveHeight
        height: width
        active: root.active

        onTriggered: {
            root.active = !root.active
        }
    }

    Behavior on height {
        SmoothedAnimation {
            id: animation
            duration: 200
        }
    }

    Component {
        id: topBarActiveDelegateComponent

        TopBarActiveDelegate {
            onHide: {
                root.active = false
            }
        }
    }

    Component {
        id: topBarInactiveDelegateComponent

        TopBarInactiveDelegate {
            titleText: root.titleText
            titleOnly: root.titleOnly
        }
    }
}
