import QtQuick 2.11
import OpenAuto 1.0
import "../controls"

Item {
    property double percent: TelephonyController.signalStrength / 100

    onPercentChanged: {
        background.requestPaint()
        indicator.requestPaint()
    }

    Connections {
        target: ThemeController
        onIconColorChanged: {
            background.requestPaint()
            indicator.requestPaint()
        }
    }

    Canvas {
        id: background
        anchors.fill: parent
        opacity: 0.5
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            ctx.fillStyle = ThemeController.iconColor
            drawIndicator(ctx)
            ctx.fill()
        }
    }

    Canvas {
        id: indicator
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            drawIndicator(ctx)
            ctx.clip()

            ctx.fillStyle = ThemeController.iconColor
            var indicatorWidth = (width * 0.65) * percent
            ctx.fillRect(width * 0.35, 0, indicatorWidth, height)
        }
    }

    SpecialText {
        id: technologyLabel
        anchors.top: parent.top
        anchors.left: parent.left
        fontPixelSize: parent.height * 0.45
        text: TelephonyController.technology
    }

    function drawIndicator(ctx) {
        ctx.beginPath()
        ctx.moveTo(width, height)
        ctx.lineTo(width, 0)
        ctx.lineTo(width * 0.35, height)
        ctx.lineTo(width, height)
        ctx.closePath()
    }
}
