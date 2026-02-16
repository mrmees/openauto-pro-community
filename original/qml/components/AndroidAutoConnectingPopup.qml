import QtQuick 2.11
import OpenAuto 1.0
import "../controls"

ControlBox {
    signal navigationClicked
    id: root

    BarIcon {
        id: icon
        rounded: true
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.05
        height: parent.height * 0.85
        width: height
        anchors.verticalCenter: parent.verticalCenter
        source: AndroidAutoController.navigationManeuverImageUrl
        colorize: true
        onTriggered: {
            root.navigationClicked()
        }
    }

    NormalText {
        id: label
        anchors.left: icon.right
        anchors.leftMargin: icon.width * 0.3
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.05
        height: parent.height * 0.9
        text: AndroidAutoController.navigationManeuverDistance + " • " + scroller.currentText
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        fontPixelSize: parent.height * 0.4

        onFontPixelSizeChanged: {
            scroller.reset();
        }
    }

    TextScroller {
        id: scroller
        text: AndroidAutoController.navigationManeuverDescription
        truncated: label.truncated
    }
}
