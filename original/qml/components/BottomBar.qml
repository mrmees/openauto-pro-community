import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../controls"

IconedSlider {
    id: root
    from: VolumeController.getMinVolume()
    to: VolumeController.getMaxVolume()
    readOnly: ConfigurationController.rearGearVolumeLevelEnabled
              && VolumeController.volumeMode === VolumeMode.REAR_GEAR

    iconSource: {
        if (VolumeController.muted) {
            return "/images/ico_volume_muted.svg"
        } else if (VolumeController.volumeMode === VolumeMode.TELEPHONE) {
            return "/images/ico_telephone.svg"
        } else if (VolumeController.volumeMode === VolumeMode.REAR_GEAR) {
            return "/images/ico_rear_camera.svg"
        }

        return "/images/ico_volume.svg"
    }

    snapMode: Slider.SnapAlways
    clickableIcon: true
    stepSize: ConfigurationController.volumeStep

    onPositionChanged: {
        if (root.pressed) {
            VolumeController.volume = valueAt(root.position)
        }
    }

    onValueChanged: {
        VolumeController.volume = root.value
    }

    onIconTriggered: {
        VolumeController.muted = !VolumeController.muted
    }

    Component.onCompleted: {
        root.value = VolumeController.volume
    }

    Connections {
        target: VolumeController
        onVolumeChanged: {
            root.value = VolumeController.volume
        }
    }
}
