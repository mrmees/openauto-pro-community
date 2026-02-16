import QtQuick 2.11
import QtQuick.Layouts 1.11
import "../controls"

Item {
    signal browseClicked
    signal resetClicked
    property alias labelText: label.text
    property alias pathLabelText: pathLabel.scrollableText

    id: root

    ControlBackground {
        radius: height * 0.15
    }

    NormalText {
        id: label
        fontPixelSize: parent.height * 0.325
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.01
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 0.3
        height: label.height
        verticalAlignment: Text.AlignVCenter
    }

    RowLayout {
        anchors.left: label.right
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.01
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 0.6
        height: parent.height * 0.6

        NormalText {
            id: pathLabel
            fontPixelSize: root.height * 0.25
            Layout.preferredWidth: parent.width * 0.6
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignRight
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        CustomButton {
            id: browseButton
            labelText: qsTr("Browse...")
            Layout.preferredWidth: parent.width * 0.15
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignRight

            onTriggered: {
                root.browseClicked()
            }
        }

        CustomButton {
            id: resetButton
            labelText: qsTr("Reset")
            Layout.preferredWidth: parent.width * 0.15
            Layout.preferredHeight: parent.height
            Layout.alignment: Qt.AlignRight

            onTriggered: {
                root.resetClicked()
            }
        }
    }
}
