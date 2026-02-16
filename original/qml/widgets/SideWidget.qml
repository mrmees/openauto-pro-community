import QtQuick 2.11
import OpenAuto 1.0
import "../controls"

ListView {
    property int itemWidth: height * 0.9

    id: root
    width: (itemWidth * StatusIconsController.statusIconsCount)
           + (StatusIconsController.statusIconsCount
              > 1 ? (spacing * (StatusIconsController.statusIconsCount - 1)) : 0)
    model: StatusIconsController.statusIconsModel
    orientation: Qt.Horizontal
    interactive: false
    delegate: Item {
        height: root.height
        width: itemWidth

        Icon {
            source: model.display
            height: parent.width
            width: height
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
