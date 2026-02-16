import QtQuick 2.11
import OpenAuto 1.0
import "../tools/MathTools.js" as MathTools

BaseGauge {
    property double minLimit: minValue
    property double maxLimit: maxValue
    property string scaleLimitColor: "#890000"
    property string scaleNormalColor: "#258000"
    property string indicatorColor: ThemeController.gaugeIndicatorColor

    id: root
    onIndicatorPaint: {
        ctx.setLineDash([0.15, 0.15])

        ctx.beginPath()
        ctx.strokeStyle = "gray"
        ctx.lineWidth = lineWidth * 2.5
        ctx.arc(width / 2, height / 2, (width / 2) - (lineWidth * 2.5),
                MathTools.toRadians(getFromRadius()), MathTools.toRadians(
                    getToRadius()))
        ctx.stroke()

        ctx.strokeStyle = indicatorColor
        ctx.lineWidth = lineWidth * 2.5

        ctx.beginPath()
        ctx.arc(width / 2, height / 2, (width / 2) - (lineWidth * 2.5),
                MathTools.toRadians(getFromRadius()), MathTools.toRadians(
                    calculateToRadius(value)))
        ctx.stroke()
        ctx.setLineDash([1, 0])

        ctx.strokeStyle = scaleNormalColor
        ctx.lineWidth = lineWidth * 1.5
        ctx.beginPath()

        ctx.arc(width / 2, height / 2, (width / 2) - (lineWidth * 1.75),
                MathTools.toRadians(getStartNormalScaleRadius(
                                        )), MathTools.toRadians(getEndNormalScaleRadius()))
        ctx.stroke()

        ctx.strokeStyle = scaleLimitColor
        ctx.lineWidth = lineWidth * 1.5

        ctx.beginPath()
        ctx.arc(width / 2, height / 2, (width / 2) - (lineWidth * 1.75),
                MathTools.toRadians(getFromRadius()), MathTools.toRadians(getStartNormalScaleRadius()))
        ctx.stroke()

        ctx.beginPath()
        ctx.arc(width / 2, height / 2, (width / 2) - (lineWidth * 1.75),
                MathTools.toRadians(getEndNormalScaleRadius()), MathTools.toRadians(getToRadius()))
        ctx.stroke()
    }

    onValueChanged: {
        var hasMinLimit = !MathTools.areTheSame(minValue, minLimit, precision)
        var hasMaxLimit = !MathTools.areTheSame(maxValue, maxLimit, precision)

        if ((hasMinLimit && value <= minLimit) || (hasMaxLimit && value >= maxLimit)) {
            warningAnimation.start()
        } else {
            warningAnimation.stop()
        }
    }

    SequentialAnimation {
        id: warningAnimation
        alwaysRunToEnd: true
        loops: Animation.Infinite

        ColorAnimation {
            target: root
            property: "backgroundColor"
            from: "black"
            to: scaleLimitColor
            duration: 500
        }

        ColorAnimation {
            target: root
            property: "backgroundColor"
            from: scaleLimitColor
            to: "black"
            duration: 500
        }
    }

    function getStartNormalScaleRadius() {
        var percentageLimit = calculatePercentageValue(minLimit)
        return getFromRadius() + (getRadiusLength() * percentageLimit)
    }

    function getEndNormalScaleRadius() {
        var percentageLimit = calculatePercentageValue(maxLimit)
        return getFromRadius() + (getRadiusLength() * percentageLimit)
    }

//    function calculateLowToRadius(currentValue) {
//        return Math.min(getToRadius(), getFromRadius(
//                            ) + (getRadiusLength() * calculatePercentageValue(
//                                     currentValue)))
//    }
}
