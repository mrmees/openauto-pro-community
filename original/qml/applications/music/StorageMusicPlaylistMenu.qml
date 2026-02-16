import QtQuick 2.11
import OpenAuto 1.0
import "../../controls"
import "../../components/"

MusicApplicationMenu {
    signal fileSelected(string path)

    id: root
    title: view.folder
    titleOnly: true

    Explorer {
        id: view
        anchors.fill: parent
        folder: ConfigurationController.defaultMediaStoragePath
        fileIcon: "/images/ico_music_library.svg"
        folderSelectionIcon: "/images/ico_play_white.svg"
        selectionLabel: qsTr("[Play this directory]")
        filterExtensions: StorageMusicController.supportedFormats
        onSelected: {
            root.fileSelected(path)
        }
    }
}
