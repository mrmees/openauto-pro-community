import QtQuick 2.11
import OpenAuto 1.0
import "../controls"

Item {
    signal navigationClicked
    id: root

    Item {
        anchors.fill: parent
        visible: !AndroidAutoController.navigationActive

        NormalText {
            text: qsTr("No active navigation at the moment.")
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.95
            height: parent.height
            font.italic: true
            fontPixelSize: width * 0.05
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }
    }

    Item {
        anchors.fill: parent
        visible: AndroidAutoController.navigationActive

        BarIcon {
            id: icon
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.2
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.3
            height: width
            source: AndroidAutoController.navigationManeuverImageUrl
            colorize: true
            onTriggered: {
                root.navigationClicked()
            }
        }

        NormalText {
            id: distanceLabel
            anchors.top: icon.bottom
            anchors.topMargin: icon.width * 0.2
            height: parent.width * 0.1
            width: parent.width
            text: AndroidAutoController.navigationManeuverDistance
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            fontPixelSize: width * 0.085
        }

        NormalText {
            id: descriptionLabel
            anchors.top: distanceLabel.bottom
            anchors.topMargin: icon.width * 0.3
            height: parent.width * 0.1
            width: parent.width
            scrollableText: AndroidAutoController.navigationManeuverDescription
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            fontPixelSize: width * 0.065
        }
    }
}
