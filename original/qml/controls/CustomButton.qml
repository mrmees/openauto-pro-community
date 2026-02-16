import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../oainput/qml"

InputControl {
    property alias name: nameLabel.scrollableText
    property string number: ""
    property string dateTime: ""
    property int type

    property string descriptionText: ""

    id: root
    hightlight: Item {
        Rectangle {
            color: "transparent"
            border.color: ThemeController.highlightColor
            border.width: height * 0.05
            anchors.fill: parent
            radius: height * 0.15
        }
    }

    ControlBackground {
        radius: height * 0.15
    }

    Item {
        id: container
        anchors.fill: parent

        Icon {
            id: callTypeMarker
            anchors.left: parent.left
            anchors.leftMargin: parent.height * 0.15
            width: height
            height: parent.height * 0.6
            anchors.verticalCenter: parent.verticalCenter
            colorize: false
            source: {
                if (root.type === CallType.RECEIVED) {
                    return "/images/ico_call_received.svg"
                } else if (root.type === CallType.DIALED) {
                    return "/images/ico_call_made.svg"
                } else if (root.type === CallType.MISSED) {
                    return "/images/ico_call_missed.svg"
                }

                return ""
            }
        }

        ColumnLayout {
            id: detailsLayout
            anchors.left: callTypeMarker.right
            anchors.right: parent.right
            height: parent.height * 0.75

            NormalText {
                id: nameLabel
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height * 0.6
                Layout.alignment: Qt.AlignHCenter
                fontPixelSize: (parent.height * 0.6) * 0.7
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }

            DescriptionText {
                id: detailsLabel
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height * 0.4
                Layout.alignment: Qt.AlignHCenter
                fontPixelSize: parent.height * 0.35
                elide: Text.ElideRight
                text: dateTime + " :: " + number
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
