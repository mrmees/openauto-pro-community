import QtQuick 2.11

Item {
    signal backClicked
    signal homeClicked
    signal powerOffClicked
    signal notificationsClicked
    signal settingsClicked

    property bool backButtonVisible: false
    property var boxDelegate: null
    property var defaultControl: null
}
