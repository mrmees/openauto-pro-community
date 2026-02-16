import QtQuick 2.11
import OpenAuto 1.0
import "../../controls"

DashboardsApplicationMenu {
    signal tripDashboardClicked
    signal sportDashboardClicked(int modelIndex, string dashboardTitle)
    signal detailedDashboardClicked(int modelIndex, string dashboardTitle)
    signal simplifiedDashboardClicked(int modelIndex, string dashboardTitle)
    signal sport2DashboardClicked(int modelIndex, string dashboardTitle)

    id: root
    title: qsTr("Dashboards")

    onMoveToNextControl: {
        view.moveCurrentIndexRight()
    }

    onMoveToPreviousControl: {
        view.moveCurrentIndexLeft()
    }

    onActivated: {
        view.currentIndex = 0
        view.positionViewAtBeginning()
    }

    GridView {
        id: view
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.bottom: parent.bottom
        cellWidth: width / 5
        cellHeight: height / 2.9
        delegate: Item {
            width: view.cellWidth
            height: view.cellHeight

            Tile {
                id: delegate
                anchors.centerIn: parent
                width: parent.width * 0.985
                height: parent.height * 0.985
                labelText: modelData
                iconPath: {
                    if (model.type === ObdDashboardType.SPORT
                            || model.type === ObdDashboardType.SPORT_2) {
                        return "/images/ico_race.svg"
                    } else {
                        return "/images/ico_charts.svg"
                    }
                }
                order: model.index
                onTriggered: {
                    if (model.type === ObdDashboardType.SPORT) {
                        root.sportDashboardClicked(model.index, model.title)
                    } else if (model.type === ObdDashboardType.DETAILED) {
                        root.detailedDashboardClicked(model.index, model.title)
                    } else if (model.type === ObdDashboardType.SIMPLIFIED) {
                        root.simplifiedDashboardClicked(model.index,
                                                        model.title)
                    } else if (model.type === ObdDashboardType.SPORT_2) {
                        root.sport2DashboardClicked(model.index, model.title)
                    }
                }
            }
        }

        model: ObdController.dashboardsModel
    }
}
