import QtQuick 2.11

Item {
    property bool flip: false
    property var startWidth: flip ? parent.width * 0.95 : parent.width * 0.05
    property var endWidth: flip ? parent.width * 0.7 : parent.width * 0.3
    property var startHeight: parent.height * 0.9
    property var endHeight: parent.height * 0.2

    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.strokeStyle = "yellow"
            ctx.lineWidth = parent.width * 0.01
            ctx.beginPath()
            ctx.moveTo(startWidth, startHeight)
            ctx.lineTo(endWidth, endHeight)
            ctx.stroke()
        }
    }

    Repeater {
        anchors.fill: parent
        model: [parent.height * 0.8, parent.height * 0.6, parent.height * 0.4, parent.height * 0.2]
        delegate: Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                ctx.strokeStyle = "yellow"
                ctx.lineWidth = parent.width * 0.0075
                ctx.beginPath()
                var lineWidth = parent.width * 0.004

                if (flip) {
                    var startX = calculateIntersectionX(modelData) + lineWidth
                    ctx.moveTo(startX - (parent.width * 0.075), modelData)
                    ctx.lineTo(startX, modelData)
                } else {
                    var startX = calculateIntersectionX(modelData) - lineWidth
                    ctx.moveTo(startX, modelData)
                    ctx.lineTo(startX + (parent.width * 0.075), modelData)
                }

                ctx.stroke()
            }
        }
    }

    function calculateIntersectionX(height) {
        var x1 = startWidth
        var y1 = startHeight
        var x2 = endWidth
        var y2 = endHeight

        var dx = x2 - x1
        var dy = y2 - y1
        var m1 = dy / dx
        var c1 = y1 - m1 * x1

        var px1 = 0
        var py1 = height
        var px2 = parent.width
        var py2 = height
        var pdx = px2 - px1
        var pdy = py2 - py1
        var pm1 = pdy / pdx
        var pc1 = py1 - pm1 * px1

        return (pc1 - c1) / (m1 - pm1)
    }
}
