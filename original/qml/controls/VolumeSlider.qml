import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../controls"

IconedSlider {
    id: root
    from: BrightnessController.getMinBrightness()
    to: BrightnessController.getMaxBrightness()
    value: BrightnessController.brightness
    iconSource: "/images/ico_brightness.svg"
    snapMode: Slider.SnapAlways

    onPositionChanged: {
        if (root.pressed) {
            BrightnessController.brightness = valueAt(root.position)
        }
    }

    onValueChanged: {
        BrightnessController.brightness = root.value
    }

    Component.onCompleted: {
        root.value = BrightnessController.brightness
    }

    Connections {
        target: BrightnessController
        onBrightnessChanged: {
            root.value = BrightnessController.brightness
        }
    }
}
