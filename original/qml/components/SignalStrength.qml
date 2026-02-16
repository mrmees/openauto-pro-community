import QtQuick 2.11
import OpenAuto 1.0
import "../controls"

Item {
    signal hide

    id: root

    VolumeSlider {
        id: volumeSlider
        width: parent.width
        height: parent.height * 0.2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: height * 0.25
    }

    BrightnessSlider {
        id: brightnessSlider
        width: parent.width
        height: parent.height * 0.2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: volumeSlider.bottom
        anchors.topMargin: height * 0.5
    }

    CustomButton {
        id: toggleAndroidAutoNightModeButton
        width: parent.width
        height: parent.height * 0.15
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: brightnessSlider.bottom
        anchors.topMargin: height * 0.5
        labelText: qsTr("Toggle Android Auto night mode")
        visible: AndroidAutoController.running
                 && ConfigurationController.androidAutoDayNightModeController
                 === DayNightModeControllerType.MANUAL
        onTriggered: {
            AndroidAutoController.toggleNightMode()
            root.hide()
        }
    }

    CustomButton {
        id: stopMirroringButton
        width: parent.width
        height: parent.height * 0.15
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: brightnessSlider.bottom
        anchors.topMargin: height * 0.5
        labelText: qsTr("Stop mirroring")
        visible: MirroringController.running
        onTriggered: {
            MirroringController.stop()
            root.hide()
        }
    }

    Component.onCompleted: {
        NotificationsController.suspendChannel(
                    BrightnessController.notificationsChannelId)
        NotificationsController.suspendChannel(
                    VolumeController.notificationsChannelId)
    }

    Component.onDestruction: {
        NotificationsController.resumeChannel(
                    BrightnessController.notificationsChannelId)
        NotificationsController.resumeChannel(
                    VolumeController.notificationsChannelId)
    }
}
