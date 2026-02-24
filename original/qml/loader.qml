import QtQuick 2.11
import "../../controls"

DashboardsApplicationMenu {
    property alias sourceComponent: loader.sourceComponent
    property var dashboardModel
    property string dashboardTitle

    Loader {
        id: loader
        active: false
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.bottom: parent.bottom

        onLoaded: {
            loadingMessage.visible = false
        }
    }

    Timer {
        id: loadingTimer
        interval: 1000
        running: true
        onTriggered: {
            loader.active = true
        }
    }

    LoadingMessage {
        id: loadingMessage
        width: parent.width * 0.25
        height: parent.height * 0.25
        anchors.centerIn: parent
        messageText: qsTr("Loading...")
    }
}
