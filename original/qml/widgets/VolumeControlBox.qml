import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../controls"

Item {
    signal selected(string path)
    property int visibleItemsCount: 8
    property var inputScope: parent
    property alias model: view.model
    property string fileIcon: "/images/ico_file.svg"
    property string folderSelectionIcon: "/images/ico_file.svg"
    property alias filterExtensions: folderModel.filterExtensions
    property alias folder: folderModel.folder
    property alias selectionLabel: folderModel.selectionLabel

    id: root

    ListView {
        id: view
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.bottom: parent.bottom
        spacing: height * 0.01
        model: folderModel

        ScrollBar.vertical: CustomScrollBar {
            id: scrollBar
            active: true
            visible: view.count > visibleItemsCount
            anchors.top: parent.top
        }

        delegate: IconedListItemButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: view.width * 0.95
            height: (view.height / root.visibleItemsCount)
            text: name
            iconSource: {
                if (type === FileType.GO_UP) {
                    return "/images/ico_goup.svg"
                } else if (type === FileType.FOLDER) {
                    return "/images/ico_folder.svg"
                } else if (type === FileType.FOLDER_SELECTION) {
                    return root.folderSelectionIcon
                } else {
                    return root.fileIcon
                }
            }

            order: model.index
            onTriggered: {
                if (type === FileType.GO_UP) {
                    folderModel.goUp()
                } else if (type === FileType.FOLDER) {
                    folderModel.folder = path
                } else {
                    root.selected(path)
                }
            }
        }
    }

    model: FolderListModel {
        id: folderModel
        onFolderLoaded: {
            view.currentIndex = 0
            view.positionViewAtBeginning()

            if (root.inputScope != null
                    && root.inputScope.highlightDefaultControl !== undefined) {
                root.inputScope.highlightDefaultControl()
            }
        }
    }

    Connections {
        target: root.inputScope

        onMoveToNextControl: {
            view.incrementCurrentIndex()
        }

        onMoveToPreviousControl: {
            view.decrementCurrentIndex()
        }

        onActivated: {
            view.currentIndex = 0
            view.positionViewAtBeginning()
        }
    }
}
