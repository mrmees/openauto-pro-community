import QtQuick 2.11
import "../"

ApplicationBase {
    rootComponent: launcherMenuComponent

    Component {
        id: launcherMenuComponent

        LauncherMenu {}
    }

    function activate() {
        applicationsStack.replace(rootComponent)
    }
}
