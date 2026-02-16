import QtQuick 2.11
import QtGraphicalEffects 1.0
import OpenAuto 1.0
import OpenAuto.Input 1.0
import "controls"
import "components"
import "applications"
import "applications/launcher"
import "applications/android_auto"
import "applications/settings"
import "applications/telephone"
import "applications/home"
import "applications/music"
import "applications/dashboards"
import "applications/equalizer"
import "applications/autobox"
import "../oainput/qml"

InputRoot {
    id: root
    active: true
    inputEventManager: globalInputEventManager

    Loader {
        id: sideWidgetLoader
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * (ConfigurationController.screenSplitPercentage / 100.0)
        state: ConfigurationController.handednessOfTraffic
               === HandednessOfTrafficType.LEFT_HAND_DRIVE ? "LEFT_HAND_DRIVE" : "RIGHT_HAND_DRIVE"
        active: ConfigurationController.screenType === ScreenType.WIDE
        visible: active && !AndroidAutoController.projectionActive
                 && !MirroringController.projectionActive
                 && !AutoboxController.projectionActive
        sourceComponent: SideWidget {
            anchors.fill: parent

            onGoLeft: {
                if (ConfigurationController.handednessOfTraffic
                        === HandednessOfTrafficType.LEFT_HAND_DRIVE) {
                    stack.currentItem.inputFocus = true
                }
            }

            onGoRight: {
                if (ConfigurationController.handednessOfTraffic
                        === HandednessOfTrafficType.RIGHT_HAND_DRIVE) {
                    stack.currentItem.inputFocus = true
                }
            }

            onMusicSourceClicked: {
                musicApplication.activateCurrentSourceMenu()
            }

            onNavigationClicked: {
                androidAutoApplication.activate()
                AndroidAutoController.resume()
            }

            onActiveCallClicked: {
                telephoneApplication.activate()
            }
        }

        states: [
            State {
                name: "LEFT_HAND_DRIVE"
                AnchorChanges {
                    target: sideWidgetLoader
                    anchors.left: undefined
                    anchors.right: parent.right
                }
            },
            State {
                name: "RIGHT_HAND_DRIVE"
                AnchorChanges {
                    target: sideWidgetLoader
                    anchors.left: parent.left
                    anchors.right: undefined
                }
            }
        ]
    }

    Item {
        id: mainContainer
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: sideWidgetLoader.active
               && sideWidgetLoader.visible ? parent.width - sideWidgetLoader.width : parent.width

        state: ConfigurationController.handednessOfTraffic
               === HandednessOfTrafficType.LEFT_HAND_DRIVE ? "LEFT_HAND_DRIVE" : "RIGHT_HAND_DRIVE"

        states: [
            State {
                name: "LEFT_HAND_DRIVE"
                AnchorChanges {
                    target: mainContainer
                    anchors.left: parent.left
                    anchors.right: undefined
                }
            },
            State {
                name: "RIGHT_HAND_DRIVE"
                AnchorChanges {
                    target: mainContainer
                    anchors.left: undefined
                    anchors.right: parent.right
                }
            }
        ]

        Wallpaper {
            anchors.top: parent.top
            anchors.topMargin: topBar.inactiveHeight
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: bottomBar.top
        }

        CustomStackView {
            id: stack
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: topBar.inactiveHeight
            anchors.bottom: bottomBar.top
            initialItem: homeApplication.rootComponent
            onCurrentItemChanged: {
                stack.currentItem.inputFocus = true
            }

            Connections {
                target: stack.currentItem

                onGoUp: {
                    if (NotificationsController.active) {
                        notificationMessage.inputFocus = true
                    } else {
                        topBar.inputFocus = true
                    }
                }

                onGoDown: {
                    bottomBar.inputFocus = true
                }

                onGoBack: {
                    root.goBack()
                }

                onGoRight: {
                    if (ConfigurationController.handednessOfTraffic
                            === HandednessOfTrafficType.LEFT_HAND_DRIVE) {
                        if (sideWidgetLoader.active
                                && sideWidgetLoader.visible) {
                            sideWidgetLoader.item.inputFocus = true
                        }
                    }
                }

                onGoLeft: {
                    if (ConfigurationController.handednessOfTraffic
                            === HandednessOfTrafficType.RIGHT_HAND_DRIVE) {
                        if (sideWidgetLoader.active
                                && sideWidgetLoader.visible) {
                            sideWidgetLoader.item.inputFocus = true
                        }
                    }
                }
            }
        }

        BottomBar {
            id: bottomBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.height * 0.14
            backButtonVisible: stack.depth > 1
            boxDelegate: {
                if (AndroidAutoController.projectionActive
                        || MirroringController.projectionActive
                        || AutoboxController.projectionActive) {
                    return null
                } else if (sideWidgetLoader.active) {
                    return volumeControlBoxComponent
                } else if (VoiceCallController.callState === CallState.ACTIVE) {
                    if (!telephoneApplication.isActiveCallMenuActive()) {
                        return activeCallControlBoxComponent
                    } else if (AndroidAutoController.navigationActive) {
                        return androidAutoNavigationControlBoxComponent
                    }
                } else if (AndroidAutoController.navigationActive) {
                    return androidAutoNavigationControlBoxComponent
                } else if (AudioFocusController.gainedStreamId === A2DPController.audioStreamId) {
                    if (!musicApplication.isA2DPMusicMenuActive()) {
                        return musicControlBoxComponent
                    }
                } else if (AudioFocusController.gainedStreamId
                           === AndroidAutoController.audioStreamId) {
                    if (!musicApplication.isAndroidAutoMusicMenuActive()) {
                        return musicControlBoxComponent
                    }
                } else if (AudioFocusController.gainedStreamId
                           === StorageMusicController.audioStreamId) {
                    if (!musicApplication.isStorageMusicMenuActive()) {
                        return musicControlBoxComponent
                    }
                } else if (AudioFocusController.gainedStreamId
                           === AutoboxController.audioStreamId) {
                    if (!musicApplication.isAutoboxMusicMenuActive()) {
                        return musicControlBoxComponent
                    }
                } else if (AudioFocusController.gainedStreamId
                           === RtlSdrFmController.audioStreamId) {
                    if (!musicApplication.isFmRadioMusicMenuActive()) {
                        return musicControlBoxComponent
                    }
                }

                return volumeControlBoxComponent
            }

            onBackClicked: {
                root.goBack()
            }

            onHomeClicked: {
                if (stack.currentItem.applicationType !== ApplicationType.HOME) {
                    homeApplication.activate()
                }
            }

            onPowerOffClicked: {
                if (stack.currentItem.applicationType !== ApplicationType.EXIT) {
                    stack.replace(null, exitMenuComponent)
                }
            }

            onNotificationsClicked: {
                if (stack.currentItem.applicationType !== ApplicationType.PHONE_NOTIFICATIONS) {
                    stack.replace(null, phoneNotificationsMenuComponent)
                }
            }

            onSettingsClicked: {
                if (stack.currentItem.applicationType !== ApplicationType.SETTINGS) {
                    settingsApplication.activate()
                }
            }

            onGoUp: {
                stack.currentItem.inputFocus = true
            }

            onGoBack: {
                stack.currentItem.inputFocus = true
            }

            onGoRight: {
                if (ConfigurationController.handednessOfTraffic
                        === HandednessOfTrafficType.LEFT_HAND_DRIVE) {
                    if (sideWidgetLoader.active && sideWidgetLoader.visible) {
                        sideWidgetLoader.item.inputFocus = true
                    }
                }
            }

            onGoLeft: {
                if (ConfigurationController.handednessOfTraffic
                        === HandednessOfTrafficType.RIGHT_HAND_DRIVE) {
                    if (sideWidgetLoader.active && sideWidgetLoader.visible) {
                        sideWidgetLoader.item.inputFocus = true
                    }
                }
            }
        }

        TopBar {
            id: topBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            inactiveHeight: DisplayController.availableGeometry.y
            activeHeight: Math.max(parent.height * 0.5, inactiveHeight)
            titleText: stack.currentItem.title
            titleOnly: stack.currentItem.titleOnly

            onActiveChanged: {
                if (!topBar.active
                        && ProjectionFocusController.willProjectionBeResumed(
                            )) {
                    stack.currentItem.inputFocus = true
                }
            }

            onGoDown: {
                if (!topBar.active) {
                    stack.currentItem.inputFocus = true
                }
            }

            onGoBack: {
                if (topBar.active) {
                    topBar.active = false
                } else {
                    stack.currentItem.inputFocus = true
                }
            }

            onGoUp: {

            }

            onGoRight: {
                if (ConfigurationController.handednessOfTraffic
                        === HandednessOfTrafficType.LEFT_HAND_DRIVE) {
                    if (sideWidgetLoader.active && sideWidgetLoader.visible) {
                        sideWidgetLoader.item.inputFocus = true
                    }
                }
            }

            onGoLeft: {
                if (ConfigurationController.handednessOfTraffic
                        === HandednessOfTrafficType.RIGHT_HAND_DRIVE) {
                    if (sideWidgetLoader.active && sideWidgetLoader.visible) {
                        sideWidgetLoader.item.inputFocus = true
                    }
                }
            }
        }

        Rectangle {
            id: topBarOverlay
            color: "black"
            opacity: topBar.opacity * 0.67
            anchors.top: topBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            visible: topBar.active

            TouchControl {
                anchors.fill: parent

                onReleased: {
                    topBar.active = false
                }
            }
        }

        NotificationMessage {
            id: notificationMessage
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * 0.21
            visible: !AndroidAutoController.projectionActive
                     && !MirroringController.projectionActive
                     && !AutoboxController.projectionActive && !topBar.active

            onGoDown: {
                stack.currentItem.inputFocus = true
            }

            onGoBack: {
                NotificationsController.dismiss()
            }

            onGoRight: {
                if (ConfigurationController.handednessOfTraffic
                        === HandednessOfTrafficType.LEFT_HAND_DRIVE) {
                    if (sideWidgetLoader.active && sideWidgetLoader.visible) {
                        sideWidgetLoader.item.inputFocus = true
                    }
                }
            }

            onGoLeft: {
                if (ConfigurationController.handednessOfTraffic
                        === HandednessOfTrafficType.RIGHT_HAND_DRIVE) {
                    if (sideWidgetLoader.active && sideWidgetLoader.visible) {
                        sideWidgetLoader.item.inputFocus = true
                    }
                }
            }

            onCloseClicked: {
                NotificationsController.dismiss()
            }

            Connections {
                target: NotificationsController

                onShowNotification: {
                    if (topBar.inputFocus) {
                        notificationMessage.inputFocus = true
                    }
                }

                onNotificationsEmptied: {
                    if (notificationMessage.inputFocus) {
                        stack.currentItem.inputFocus = true
                    }
                }
            }
        }
    }

    Loader {
        id: rearCameraLoader
        anchors.fill: parent
        active: RearCameraController.visible
                && ConfigurationController.rearCameraBackendType !== RearCameraBackendType.SCRIPT
        sourceComponent: RearCameraView {
            inputFocus: rearCameraLoader.status === Loader.Ready
            anchors.fill: parent
            onCloseClicked: {
                RearCameraController.hide()
                stack.currentItem.inputFocus = true
            }
        }
    }

    LauncherApplication {
        id: launcherApplication
        applicationsStack: stack
    }

    SettingsApplication {
        id: settingsApplication
        applicationsStack: stack

        onRetranslate: {
            homeApplication.activate()
        }
    }

    AndroidAutoApplication {
        id: androidAutoApplication
        applicationsStack: stack
    }

    TelephoneApplication {
        id: telephoneApplication
        applicationsStack: stack
    }

    MusicApplication {
        id: musicApplication
        applicationsStack: stack
    }

    HomeApplication {
        id: homeApplication
        applicationsStack: stack

        onMusicClicked: {
            musicApplication.activate()
        }

        onMirroringClicked: {
            if (MirroringController.running) {
                MirroringController.resume()
            } else {
                MirroringController.start()
            }
        }

        onSettingsClicked: {
            settingsApplication.activate()
        }

        onRearCameraClicked: {
            RearCameraController.show()
        }

        onTelephoneClicked: {
            telephoneApplication.activate()
        }

        onAndroidAutoClicked: {
            androidAutoApplication.activate()
        }

        onApplicationsClicked: {
            launcherApplication.activate()
        }

        onDashboardsClicked: {
            dashboardsApplication.activate()
        }

        onEqualizerClicked: {
            equalizerApplication.activate()
        }

        onAutoboxClicked: {
            autoboxApplication.activate()
        }
    }

    DashboardsApplication {
        id: dashboardsApplication
        applicationsStack: stack
    }

    EqualizerApplication {
        id: equalizerApplication
        applicationsStack: stack
    }

    AutoboxApplication {
        id: autoboxApplication
        applicationsStack: stack
    }

    Component {
        id: exitMenuComponent

        ExitMenu {
            onReturnToSystemClicked: {
                mainWindow.showMinimized()
                homeApplication.activate()
            }
        }
    }

    Component {
        id: phoneNotificationsMenuComponent

        PhoneNotificationsMenu {}
    }

    Component {
        id: musicControlBoxComponent

        MusicControlBox {
            onMusicSourceClicked: {
                musicApplication.activateCurrentSourceMenu()
            }
        }
    }

    Component {
        id: androidAutoNavigationControlBoxComponent

        AndroidAutoNavigationControlBox {
            onNavigationClicked: {
                androidAutoApplication.activate()
                AndroidAutoController.resume()
            }
        }
    }

    Component {
        id: volumeControlBoxComponent

        VolumeControlBox {}
    }

    Component {
        id: activeCallControlBoxComponent

        ActiveCallControlBox {
            onActiveCallClicked: {
                telephoneApplication.activate()
            }
        }
    }

    Connections {
        target: AndroidAutoController

        onRunningChanged: {
            if (AndroidAutoController.running) {
                androidAutoApplication.showConnectedMenu()
                topBar.active = false
                topBar.positionAtDefaultControl()
            } else {
                if (stack.currentItem.applicationType === ApplicationType.ANDROID_AUTO) {
                    androidAutoApplication.showConnectMenu()
                }
            }
        }

        onProjectionActiveChanged: {
            if (AndroidAutoController.projectionActive) {
                androidAutoApplication.activate()
            }
        }
    }

    Connections {
        target: MirroringController

        onProjectionActiveChanged: {
            if (MirroringController.projectionActive) {
                homeApplication.activate()
                stack.currentItem.inputFocus = true
            }
        }
    }

    Connections {
        target: AutoboxController

        onRunningChanged: {
            if (AutoboxController.running) {
                autoboxApplication.showConnectedMenu()
                topBar.active = false
                topBar.positionAtDefaultControl()
            } else {
                if (stack.currentItem.applicationType === ApplicationType.AUTOBOX) {
                    autoboxApplication.showConnectMenu()
                }
            }
        }

        onProjectionActiveChanged: {
            if (AutoboxController.projectionActive) {
                autoboxApplication.activate()
            }
        }
    }

    Connections {
        target: HotKeyController

        onHotKeyTriggered: {
            if (key == Qt.Key_F12) {
                mainWindow.bringToFront()
            } else if (key == Qt.Key_F6) {
                mainWindow.bringToFront()
                topBar.inputFocus = true
                topBar.active = !topBar.active
            } else if (key == Qt.Key_F7) {
                VolumeController.volume -= ConfigurationController.volumeStep
            } else if (key == Qt.Key_F8) {
                VolumeController.volume += ConfigurationController.volumeStep
            } else if (key == Qt.Key_F9) {
                BrightnessController.brightness--
            } else if (key == Qt.Key_F10) {
                BrightnessController.brightness++
            } else if (key == Qt.Key_F3) {
                if (root.canHandleKeyEvent()) {
                    if (!ModeController.next()) {
                        mainWindow.bringToFront()
                    }
                }
            } else if (key == Qt.Key_F11) {
                VolumeController.muted = !VolumeController.muted
            }
        }
    }

    onShortcutTriggered: {
        if (!root.canHandleKeyEvent()) {
            return
        }

        if (key === Qt.Key_H) {
            bottomBar.homeClicked()
        } else if (key === Qt.Key_G || key === Qt.Key_P) {
            if (VoiceCallController.callState === CallState.INCOMING) {
                VoiceCallController.answer()
            } else {
                telephoneApplication.activate()
            }
        } else if (key === Qt.Key_J) {
            musicApplication.activateCurrentSourceMenu()
        } else if (key === Qt.Key_O) {
            VoiceCallController.hangUp()
        } else if (key == Qt.Key_F2) {
            if (AndroidAutoController.projectionActive) {
                AndroidAutoController.toggleNightMode()
            }
        }
    }

    Component.onCompleted: {
        LicenseController.activateAndroidAutoLicense()
        LicenseController.activateAutoboxLicense()
        LicenseController.activateRtlSdrFmLicense()
    }

    function goBack() {
        if (stack.depth > 1) {
            stack.pop()
        } else {
            bottomBar.homeClicked()
        }
    }

    function canHandleKeyEvent() {
        return topBar.inputFocus || bottomBar.inputFocus
                || (stack.currentItem !== null && stack.currentItem.inputFocus)
                || (sideWidgetLoader.active && sideWidgetLoader.item.inputFocus)
    }
}
