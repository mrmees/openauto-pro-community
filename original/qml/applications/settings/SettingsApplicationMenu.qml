import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../../controls"

SettingsApplicationMenu {
    signal selected

    id: root
    title: qsTr("Manage gestures")

    onScrollRight: {
        listView.incrementCurrentIndex()
    }

    onScrollLeft: {
        listView.decrementCurrentIndex()
    }

    ListView {
        id: listView
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.bottom: parent.bottom
        spacing: height * 0.01

        model: ListModel {
            ListElement {
                property string text: qsTr("Next track")
            }

            ListElement {
                property string text: qsTr("Previous track")
            }

            ListElement {
                property string text: qsTr("Answer call")
            }

            ListElement {
                property string text: qsTr("Hang-up call")
            }

            ListElement {
                property string text: qsTr("Volume up")
            }

            ListElement {
                property string text: qsTr("Volume down")
            }

            ListElement {
                property string text: qsTr("Toggle play")
            }
        }

        delegate: LabeledSwitcher {
            anchors.horizontalCenter: parent.horizontalCenter
            width: listView.width * 0.95
            height: listView.height / 7
            labelText: model.text
            order: model.index
            checked: {
                if (model.index === 0) {
                    return ConfigurationController.nextTrackGestureEnabled
                } else if (model.index === 1) {
                    return ConfigurationController.previousTrackGestureEnabled
                } else if (model.index === 2) {
                    return ConfigurationController.answerCallGestureEnabled
                } else if (model.index === 3) {
                    return ConfigurationController.hangUpCallGestureEnabled
                } else if (model.index === 4) {
                    return ConfigurationController.volumeUpGestureEnabled
                } else if (model.index === 5) {
                    return ConfigurationController.volumeDownGestureEnabled
                } else if (model.index === 6) {
                    return ConfigurationController.togglePlayGestureEnabled
                }

                return false
            }

            onCheckedChanged: {
                if (model.index === 0) {
                    ConfigurationController.nextTrackGestureEnabled = checked
                } else if (model.index === 1) {
                    ConfigurationController.previousTrackGestureEnabled = checked
                } else if (model.index === 2) {
                    ConfigurationController.answerCallGestureEnabled = checked
                } else if (model.index === 3) {
                    ConfigurationController.hangUpCallGestureEnabled = checked
                } else if (model.index === 4) {
                    ConfigurationController.volumeUpGestureEnabled = checked
                } else if (model.index === 5) {
                    ConfigurationController.volumeDownGestureEnabled = checked
                } else if (model.index === 6) {
                    ConfigurationController.togglePlayGestureEnabled = checked
                }
            }
        }

        ScrollBar.vertical: CustomScrollBar {
            id: scrollBar
            active: true
            anchors.top: parent.top
        }
    }
}
