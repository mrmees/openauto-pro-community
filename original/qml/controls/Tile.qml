import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import OpenAuto.Input 1.0
import "../../oainput/qml"

InputControl {
    property alias text: textArea.text
    property alias font: textArea.font
    property alias color: textArea.color
    property var fontPixelSize

    id: root
    hightlight: highlightComponent
    scrollingHighlight: highlightComponent

    onTriggered: {
        root.scrollingActive = !root.scrollingActive
    }

    onScrollLeft: {
        flickable.flick(0, root.height * 0.5)
    }

    onScrollRight: {
        flickable.flick(0, -(root.height * 0.5))
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        TextArea.flickable: TextArea {
            id: textArea
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: fontPixelSize
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
        }

        ScrollBar.vertical: CustomScrollBar {
            policy: ScrollBar.AlwaysOn
            parent: flickable.parent
            anchors.top: flickable.top
            anchors.left: flickable.right
            anchors.bottom: flickable.bottom
        }
    }

    Component {
        id: highlightComponent

        Item {
            Rectangle {
                color: "transparent"
                border.color: ThemeController.highlightColor
                border.width: height * 0.0075
                anchors.fill: parent
                radius: height * 0.01
                opacity: root.scrollingActive ? 1 : 0.5
            }
        }
    }
}
