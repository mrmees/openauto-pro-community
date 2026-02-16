import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../../controls"

SettingsApplicationMenu {
    signal backgroundColorClicked
    signal highlightColorClicked
    signal controlBackgroundColorClicked
    signal controlForegroundColorClicked
    signal normalFontColorClicked
    signal specialFontColorClicked
    signal descriptionFontColorClicked
    signal barBackgroundColorClicked
    signal controlBoxBackgroundColorClicked
    signal gaugeIndicatorColorClicked
    signal iconColorClicked
    signal sideWidgetBackgroundColorClicked
    signal barShadowColorClicked

    id: root
    title: qsTr("Color settings - %1").arg(
               ThemeController.theme === DayNightModeType.DAY ? qsTr("Day") : qsTr(
                                                                    "Night"))

    onMoveToNextControl: {
        listView.incrementCurrentIndex()
    }

    onMoveToPreviousControl: {
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

        delegate: ListItemButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: listView.width * 0.95
            height: listView.height / 7
            text: model.text
            order: model.index
            horizontalAlignement: Text.AlignLeft
            hasNextLevel: model.text !== ""

            onTriggered: {
                if(model.index === 0) {
                    root.backgroundColorClicked()
                } else if(model.index === 1) {
                    root.highlightColorClicked()
                } else if(model.index === 2) {
                    root.controlBackgroundColorClicked()
                } else if(model.index === 3) {
                    root.controlForegroundColorClicked()
                } else if(model.index === 4) {
                    root.normalFontColorClicked()
                } else if(model.index === 5) {
                    root.specialFontColorClicked()
                } else if(model.index === 6) {
                    root.descriptionFontColorClicked()
                } else if(model.index === 7) {
                    root.barBackgroundColorClicked()
                } else if(model.index === 8) {
                    root.controlBoxBackgroundColorClicked()
                } else if(model.index === 9) {
                    root.gaugeIndicatorColorClicked()
                } else if(model.index === 10) {
                    root.iconColorClicked()
                } else if(model.index === 11) {
                    root.sideWidgetBackgroundColorClicked()
                } else if(model.index === 12) {
                    root.barShadowColorClicked()
                }
            }
        }

        ScrollBar.vertical: CustomScrollBar {
            id: scrollBar
            active: true
            visible: listView.count > 7
            anchors.top: parent.top
        }

        model: ListModel {
            ListElement {
                property string text: qsTr("Background color")
            }

            ListElement {
                property string text: qsTr("Highlight color")
            }

            ListElement {
                property string text: qsTr("Control background color")
            }

            ListElement {
                property string text: qsTr("Control foreground color")
            }

            ListElement {
                property string text: qsTr("Normal font color")
            }

            ListElement {
                property string text: qsTr("Special font color")
            }

            ListElement {
                property string text: qsTr("Description font color")
            }

            ListElement {
                property string text: qsTr("Bar background color")
            }

            ListElement {
                property string text: qsTr("Control box background color")
            }

            ListElement {
                property string text: qsTr("Gauge indicator color")
            }

            ListElement {
                property string text: qsTr("Icon color")
            }

            ListElement {
                property string text: qsTr("Side widget background color")
            }

            ListElement {
                property string text: qsTr("Bar shadow color")
            }
        }
    }
}
