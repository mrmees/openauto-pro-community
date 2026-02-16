import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import OpenAuto.Input 1.0
import "../oainput/qml"
import "controls"

InputRoot {
    signal languageSelected

    id: root
    active: true
    inputEventManager: globalInputEventManager

    InputScope {
        anchors.fill: parent
        inputFocus: true

        Item {
            id: titleContainer
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.01
            height: parent.height * 0.1
            width: parent.width * 0.9
            anchors.horizontalCenter: parent.horizontalCenter

            SpecialText {
                id: titleLabel
                anchors.fill: parent
                text: qsTr("Select language")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                fontPixelSize: parent.height * 0.75
            }
        }

        onScrollRight: {
            listView.incrementCurrentIndex()
        }

        onScrollLeft: {
            listView.decrementCurrentIndex()
        }

        ListView {
            id: listView
            anchors.topMargin: parent.height * 0.05
            anchors.top: titleContainer.bottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.05
            width: parent.width
            spacing: height * 0.01
            clip: true

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
                    ConfigurationController.save()

                    root.languageSelected()
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
}
