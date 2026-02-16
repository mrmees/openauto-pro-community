import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../../controls"

SettingsApplicationMenu {
    signal selected

    id: root
    title: qsTr("Language settings")

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

        model: LanguageController.model
        delegate: ListItemButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: listView.width * 0.95
            height: listView.height / 7
            text: model.modelData
            order: model.index
            active: model.index === LanguageController.currentLanguageIndex

            onTriggered: {
                ConfigurationController.language = model.modelData
                root.selected()
            }
        }

        ScrollBar.vertical: CustomScrollBar {
            id: scrollBar
            active: true
            visible: listView.count > 7
            anchors.top: parent.top
        }
    }
}
