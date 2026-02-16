import QtQuick 2.11
import OpenAuto 1.0
import "../"

ApplicationBase {
    rootComponent: dashboardsMenuComponent

    Component {
        id: dashboardsMenuComponent

        DashboardsMenu {
            onSportDashboardClicked: {
                applicationsStack.push(sportDashboardMenuComponent, {
                                           "dashboardModel": ObdController.getDashboardModel(
                                                                 modelIndex),
                                           "dashboardTitle": dashboardTitle
                                       })
            }

            onDetailedDashboardClicked: {
                applicationsStack.push(detailedDashboardMenuComponent, {
                                           "dashboardModel": ObdController.getDashboardModel(
                                                                 modelIndex),
                                           "dashboardTitle": dashboardTitle
                                       })
            }

            onSimplifiedDashboardClicked: {
                applicationsStack.push(simplifiedDashboardMenuComponent, {
                                           "dashboardModel": ObdController.getDashboardModel(
                                                                 modelIndex),
                                           "dashboardTitle": dashboardTitle
                                       })
            }

            onSport2DashboardClicked: {
                applicationsStack.push(sport2DashboardMenuComponent, {
                                           "dashboardModel": ObdController.getDashboardModel(
                                                                 modelIndex),
                                           "dashboardTitle": dashboardTitle
                                       })
            }
        }
    }

    Component {
        id: detailedDashboardMenuComponent

        DetailedDashboardMenu {}
    }

    Component {
        id: simplifiedDashboardMenuComponent

        SimplifiedDashboardMenu {}
    }

    Component {
        id: sportDashboardMenuComponent

        SportDashboardMenu {}
    }

    Component {
        id: sport2DashboardMenuComponent

        Sport2DashboardMenu {}
    }

    function activate() {
        applicationsStack.replace(null, rootComponent)
    }
}
