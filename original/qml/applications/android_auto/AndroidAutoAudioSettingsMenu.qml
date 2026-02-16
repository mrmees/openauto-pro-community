import QtQuick 2.11
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
        fileIcon: "/images/ico_file.svg"
        filterExtensions: [".zip"]
        onSelected: {
            root.fileSelected(path)
        }
    }
}
