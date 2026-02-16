import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../../controls"
import "../../components/"

MusicApplicationMenu {
    signal selected(int frequency)

    id: root
    title: qsTr("Presets")

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

        model: RtlSdrFmController.allPresetsListModel
        delegate: Item {
            width: listView.width
            height: listView.height / 7

            IconedListItemButton {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.95
                height: parent.height
                text: model.modelData
                order: model.index
                active: model.frequency === RtlSdrFmController.currentFrequency
                iconSource: "/images/ico_radio.svg"

                onTriggered: {
                    root.selected(model.frequency)
                }
            }
        }

        ScrollBar.vertical: CustomScrollBar {
            id: scrollBar
            active: true
            visible: listView.count > 8
            anchors.top: parent.top
        }
    }
}
