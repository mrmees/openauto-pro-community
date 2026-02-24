import QtQuick 2.11
import OpenAuto 1.0

ControlBox {
    VolumeSlider {
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: parent.height * 0.85
    }

    Component.onCompleted: {
        NotificationsController.suspendChannel(
                    VolumeController.notificationsChannelId)
    }

    Component.onDestruction: {
        NotificationsController.resumeChannel(
                    VolumeController.notificationsChannelId)
    }
}
