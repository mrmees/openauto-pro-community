import QtQuick 2.11
import OpenAuto 1.0

Text {
    property alias scrollableText: scroller.text
    property var fontPixelSize

    id: root
    font.family: "Noto Sans, Noto Sans Korean, Noto Color Emoji"
    font.pixelSize: fontPixelSize * (1.0 + (ConfigurationController.fontScale / 100.0))
    text: scroller.currentText

    onFontPixelSizeChanged: {
        scroller.reset();
    }

    TextScroller {
        id: scroller
        truncated: root.truncated
    }
}
