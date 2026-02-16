import QtQuick 2.11
import OpenAuto 1.0
import "../controls"

CustomText {
    property int value: TemperatureSensorController.temperature

    id: root
    color: ThemeController.normalFontColor
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.family: "Noto Sans, Noto Sans Korean, Noto Color Emoji"
    font.weight: Font.Bold
    font.bold: true

    onValueChanged: {
        displayValue()
    }

    function displayValue() {
        var unit = ConfigurationController.temperatureUnit
                === TemperatureUnit.FAHRENHEIT ? "°F" : "°C"

        var labelValue = value

        if (ConfigurationController.temperatureUnit === TemperatureUnit.FAHRENHEIT) {
            labelValue = Math.round((value * 1.8) + 32)
        }

        root.text = labelValue + unit
    }

    Connections {
        target: ConfigurationController
        onTemperatureUnitChanged: {
            displayValue()
        }
    }

    Component.onCompleted: {
        displayValue()
    }
}
