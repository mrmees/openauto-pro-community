import QtQuick 2.11
import OpenAuto 1.0
import OpenAuto.Input 1.0
import "../controls"
import "../../oainput/qml"

InputScope {
    signal backClicked
    signal homeClicked
    signal powerOffClicked
    signal notificationsClicked
    signal settingsClicked
    property bool backButtonVisible: false
    property var boxDelegate: null

    id: root
    defaultControl: delegate.item != null ? delegate.item.defaultControl : null

    onBackButtonVisibleChanged: {
        root.positionAtDefaultControl()
    }

    onBoxDelegateChanged: {
        root.positionAtDefaultControl()
    }

    BarBackground {
        opacity: 1
    }

    Rectangle {
        color: ThemeController.barShadowColor
        anchors.top: parent.top
        height: parent.height * 0.005
        width: parent.width
    }

    TouchControl {
        anchors.fill: parent
    }

    Loader {
        id: delegate
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.12
        sourceComponent: ConfigurationController.handednessOfTraffic
                         === HandednessOfTrafficType.LEFT_HAND_DRIVE ? leftHandDriveBottomBarDelegateComponent : rightHandDriveBottomBarDelegateComponent
    }

    Connections {
        target: delegate.item

        onBackClicked: {
            root.backClicked()
        }

        onHomeClicked: {
            root.homeClicked()
        }

        onPowerOffClicked: {
            root.powerOffClicked()
        }

        onNotificationsClicked: {
            root.notificationsClicked()
        }

        onSettingsClicked: {
            root.settingsClicked()
        }
    }

    Component {
        id: leftHandDriveBottomBarDelegateComponent

        LeftHandDriveBottomBarDelegate {
            backButtonVisible: root.backButtonVisible
            boxDelegate: root.boxDelegate
        }
    }

    Component {
        id: rightHandDriveBottomBarDelegateComponent

        RightHandDriveBottomBarDelegate {
            backButtonVisible: root.backButtonVisible
            boxDelegate: root.boxDelegate
        }
    }
}
