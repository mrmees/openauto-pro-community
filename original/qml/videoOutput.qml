import QtQuick 2.11
import OpenAuto 1.0
import QtMultimedia 5.9

Item {
    VideoOutput {
        id: videoOutput
        source: mediaPlayer
        anchors.fill: parent
        fillMode: VideoOutput.Stretch
        orientation: RearCameraController.getOrientation()
    }

    MediaPlayer {
        id: mediaPlayer
        source: RearCameraController.deviceId
        Component.onCompleted: {
            mediaPlayer.play()
        }
    }
}
