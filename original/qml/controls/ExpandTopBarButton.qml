import QtQuick 2.11
import OpenAuto 1.0
import "../../oainput/qml"

Item {
    signal removeTriggered

    property alias nameText: name.scrollableText
    property alias addressText: address.scrollableText
    property int order

    id: root

    ControlBackground {
        id: background
        radius: height * 0.1
    }

    Item {
        anchors.fill: parent

        Icon {
            id: icon
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.025
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height * 0.75
            width: height
            source: "/images/ico_phone_device.svg"
        }

        NormalText {
            id: name
            fontPixelSize: parent.height * 0.26
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.11
            anchors.left: icon.right
            anchors.leftMargin: parent.width * 0.025
            anchors.right: removeButton.left
            anchors.rightMargin: parent.width * 0.015
            elide: Text.ElideRight
        }

        DescriptionText {
            id: address
            fontPixelSize: parent.height * 0.24
            anchors.top: name.bottom
            anchors.topMargin: parent.height * 0.01
            anchors.left: icon.right
            anchors.leftMargin: parent.width * 0.025
            anchors.right: removeButton.left
            anchors.rightMargin: parent.width * 0.015
            elide: Text.ElideRight
        }

        CloseButton {
            id: removeButton
            order: (root.order * 2) + 1
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.0075
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height * 0.5
            width: height
            onTriggered: {
                root.removeTriggered()
            }
        }
    }
}
