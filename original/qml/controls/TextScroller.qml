import QtQuick 2.11
import OpenAuto 1.0
import "../../oainput/qml"

Item {
    signal closeTriggered

    property alias titleText: title.scrollableText
    property alias messageText: message.scrollableText
    property alias timeText: time.text
    property alias primaryIconSource: primaryIcon.source
    property alias secondaryIconSource: secondaryIcon.source
    property int order

    id: root

    ControlBackground {
        id: background
        radius: height * 0.1
    }

    Item {
        anchors.fill: parent

        Icon {
            id: primaryIcon
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.025
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height * 0.75
            width: height
            rounded: true
        }

        Icon {
            id: secondaryIcon
            anchors.right: primaryIcon.right
            anchors.bottom: primaryIcon.bottom
            height: parent.height * 0.3
            width: height
            rounded: true
        }

        NormalText {
            id: title
            fontPixelSize: parent.height * 0.26
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.11
            anchors.left: primaryIcon.right
            anchors.leftMargin: parent.width * 0.025
            anchors.right: time.left
            anchors.rightMargin: parent.width * 0.015
            elide: Text.ElideRight
        }

        DescriptionText {
            id: message
            fontPixelSize: parent.height * 0.24
            anchors.top: title.bottom
            anchors.topMargin: parent.height * 0.01
            anchors.left: primaryIcon.right
            anchors.leftMargin: parent.width * 0.025
            anchors.right: time.left
            anchors.rightMargin: parent.width * 0.015
            elide: Text.ElideRight
        }

        NormalText {
            id: time
            anchors.right: closeButton.left
            anchors.rightMargin: parent.width * 0.015
            anchors.verticalCenter: parent.verticalCenter
            fontPixelSize: parent.height * 0.23
        }

        CloseButton {
            id: closeButton
            order: (root.order * 2) + 1
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.0075
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height * 0.5
            width: height
            onTriggered: {
                root.closeTriggered()
            }
        }
    }
}
