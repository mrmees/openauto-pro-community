import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"

SettingsApplicationMenu {
    id: root
    title: qsTr("Version")

    Item {
        id: container
        anchors.centerIn: parent
        width: parent.width * 0.85
        height: parent.height * 0.725

        ControlBackground {
            radius: height * 0.025
        }

        ColumnLayout {
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.065
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.025
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.025
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.065
            spacing: parent.height * 0.05

            SpecialText {
                fontPixelSize: container.width * 0.035
                font.bold: true
                text: "OpenAuto Pro 16.1"
                Layout.alignment: Qt.AlignTop
                Layout.preferredWidth: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            NormalText {
                fontPixelSize: container.width * 0.025
                text: qsTr("Author and maintainer of this software is BlueWave Studio.")
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                Layout.preferredWidth: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            NormalText {
                fontPixelSize: container.width * 0.025
                text: qsTr("In case of updates, support or any other queries contact us at <b>contact@bluewavestudio.io</b> or visit our web page at <b>www.bluewavestudio.io</b>")
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                Layout.preferredWidth: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            NormalText {
                fontPixelSize: container.width * 0.025
                text: qsTr("Copyright (c) 2024 BlueWave Studio. All rights reserved.")
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                Layout.preferredWidth: parent.width
                Layout.alignment: Qt.AlignBottom
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
