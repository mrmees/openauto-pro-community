import QtQuick 2.11
import OpenAuto 1.0
import "../tools/MathTools.js" as MathTools

BaseGauge {
    property string indicatorColor: ThemeController.gaugeIndicatorColor

    id: root
    onIndicatorPaint: {
        ctx.setLineDash([0.15, 0.15])

        ctx.beginPath()

        ctx.strokeStyle = "gray"
        ctx.lineWidth = lineWidth * 2.5
        ctx.arc(width / 2, height / 2, (width / 2) - (lineWidth * 1.75),
                MathTools.toRadians(getFromRadius()), MathTools.toRadians(
                    getToRadius()))
        ctx.stroke()

        ctx.strokeStyle = indicatorColor
        ctx.lineWidth = lineWidth * 2.5
        ctx.beginPath()

        ctx.arc(width / 2, height / 2, (width / 2) - (lineWidth * 1.75),
                MathTools.toRadians(getFromRadius()), MathTools.toRadians(
                    calculateToRadius(root.value)))
        ctx.stroke()

        ctx.setLineDash([])
    }
}
