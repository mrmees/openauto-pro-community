import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../oainput/qml"

InputControl {
    property alias name: nameLabel.scrollableText
    property alias number: numberLabel.scrollableText

    property string descriptionText: ""

    id: root

    hightlight: Item {
        Rectangle {
            color: "transparent"
            border.color: ThemeController.highlightColor
            border.width: height * 0.035
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

        ColumnLayout {
            width: parent.width
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
                id: numberLabel
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: parent.height * 0.4
                Layout.alignment: Qt.AlignHCenter
                fontPixelSize: parent.height * 0.35
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
