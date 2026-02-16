import QtQuick 2.11
import QtGraphicalEffects 1.0
import OpenAuto 1.0
import "../controls"
import "../tools/MathTools.js" as MathTools

Item {
    property string dashColor: "silver"
    property string ringColor: "gray"
    property string backgroundColor: "black"
    property int lineWidth: width * 0.04
    property int precision: 1

    property double minValue: 0
    property double maxValue: 0
    property double value: 0

    property alias label: unitLabel.text
    signal indicatorPaint(var ctx)

    id: root

    onVisibleChanged: {
        if (!borderCanvas.painted) {
            borderCanvas.requestPaint()
        }

        indicatorCanvas.requestPaint()
    }

    onValueChanged: {
        indicatorCanvas.requestPaint()
    }

    Canvas {
        property bool painted: false

        id: borderCanvas
        anchors.fill: parent
        z: 2

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.beginPath()
            ctx.strokeStyle = dashColor
            ctx.lineWidth = lineWidth * 0.75
            ctx.shadowColor = "black"
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 3
            ctx.shadowBlur = 5

            ctx.arc(width / 2, height / 2,
                    (width / 2) - (lineWidth), MathTools.toRadians(
                        getFromRadius()), MathTools.toRadians(getToRadius()))
            ctx.stroke()
            painted = true
        }
    }

    Canvas {
        property bool painted: false

        id: ringCanvas
        anchors.fill: parent
        z: 2

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.beginPath()
            ctx.strokeStyle = ringColor
            ctx.lineWidth = lineWidth / 1.75
            ctx.shadowColor = "black"
            ctx.shadowOffsetX = 0
            ctx.shadowOffsetY = 0
            ctx.shadowBlur = 1

            ctx.arc(width / 2, height / 2, (width / 2) - (lineWidth / 2.5),
                    MathTools.toRadians(0), MathTools.toRadians(360))
            ctx.stroke()
            painted = true
        }
    }

    Canvas {
        id: indicatorCanvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")

            ctx.clearRect(0, 0, width, height)
            indicatorPaint(ctx)
        }
    }

    function calculateTotal() {
        return maxValue - minValue
    }

    function calculatePercentageValue(currentValue) {
        var total = calculateTotal()
        return (currentValue - minValue) / total
    }

    function calculateToRadius(currentValue) {
        return Math.min(getToRadius(), getFromRadius(
                            ) + (getRadiusLength() * calculatePercentageValue(
                                     currentValue)))
    }

    function getRadiusLength() {
        return getToRadius() - getFromRadius()
    }

    function getFromRadius() {
        return 163
    }

    function getToRadius() {
        return 376
    }

    NormalText {
        id: valueLabel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.35
        fontPixelSize: parent.width * 0.13
        font.bold: true
        text: value.toFixed(precision)
        color: "white"
    }

    NormalText {
        id: minValueLabel
        anchors.top: valueLabel.bottom
        anchors.topMargin: parent.width * 0.085
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.09
        fontPixelSize: parent.width * 0.08
        font.bold: true
        text: minValue.toFixed(precision)
        color: "white"
    }

    NormalText {
        id: maxValueLabel
        anchors.top: valueLabel.bottom
        anchors.topMargin: parent.width * 0.085
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.09
        fontPixelSize: parent.width * 0.08
        font.bold: true
        text: maxValue.toFixed(precision)
        color: "white"
    }

    NormalText {
        id: unitLabel
        anchors.top: minValueLabel.bottom
        anchors.topMargin: parent.width * 0.025
        anchors.horizontalCenter: parent.horizontalCenter
        fontPixelSize: parent.width * 0.075
        font.bold: true
        color: ThemeController.gaugeIndicatorColor//"white"
    }

    Behavior on value {
        SmoothedAnimation {
            duration: 500
            velocity: -1
        }
    }

    Background {
        anchors.centerIn: parent
        anchors.fill: null
        width: parent.width * 0.975
        height: parent.height * 0.975
        color: root.backgroundColor
        radius: parent.width * 0.5
        opacity: ConfigurationController.controlsOpacity / 100
    }
}
