import QtQuick 2.11
import "../../controls"
import "../../components/"

SettingsApplicationMenu {
    signal fileSelected(string path, int browsingId)
    property int browsingId
    property alias filterExtensions: view.filterExtensions
    property alias fileIcon: view.fileIcon

    id: root
    title: view.folder
    titleOnly: true

    Explorer {
        id: view
        anchors.fill: parent
        filterExtensions: [".mp3", ".wma", ".wav"]
        onSelected: {
            root.fileSelected(path, root.browsingId)
        }
    }
}
