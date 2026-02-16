import QtQuick 2.11
import OpenAuto 1.0
import QtMultimedia 5.9

Item {
    VideoOutput {
        id: videoOutput
        source: camera
        anchors.fill: parent
        fillMode: VideoOutput.Stretch
        orientation: RearCameraController.getOrientation()
    }

    Camera {
        id: camera
        captureMode: Camera.CaptureViewfinder
        deviceId: RearCameraController.deviceId
        viewfinder.resolution: Qt.size(
                                   ConfigurationController.rearCameraResolutionWidth,
                                   ConfigurationController.rearCameraResolutionHeight)
    }
}
