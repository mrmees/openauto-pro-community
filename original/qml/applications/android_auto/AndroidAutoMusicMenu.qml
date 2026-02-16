import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../../controls"
import "../../components/"

MusicApplicationMenu {
    signal selected
    property int type

    id: root
    title: qsTr("Playlist")

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
        highlightRangeMode: ListView.StrictlyEnforceRange

        model: StorageMusicController.playlistFiles
        delegate: Item {
            width: listView.width
            height: listView.height / 8

            IconedListItemButton {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.95
                height: parent.height
                text: model.modelData
                order: model.index
                active: model.index === StorageMusicController.currentTrackIndex
                iconSource: "/images/ico_music_library.svg"

                onTriggered: {
                    StorageMusicController.currentTrackIndex = model.index
                    root.selected()
                }
            }
        }

        ScrollBar.vertical: CustomScrollBar {
            id: scrollBar
            active: true
            visible: listView.count > 9
            anchors.top: parent.top
        }

        Component.onCompleted: {
            var highlightMoveVelocityBackup = listView.highlightMoveVelocity
            listView.highlightMoveVelocity = -1

            listView.positionViewAtIndex(
                        StorageMusicController.currentTrackIndex,
                        ListView.Center)
            listView.currentIndex = StorageMusicController.currentTrackIndex
            root.defaultControl = listView.currentItem

            listView.highlightMoveVelocity = highlightMoveVelocityBackup
        }
    }
}
