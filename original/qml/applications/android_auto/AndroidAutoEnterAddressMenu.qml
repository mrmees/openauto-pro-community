import QtQuick 2.11
import OpenAuto 1.0
import "../"
import "../../components"

ApplicationBase {
    property bool connectMenuActive: false
    property bool connectedMenuActive: false

    id: root
    rootComponent: androidAutoConnectMenuComponent

    function activate() {
        if (AndroidAutoController.running) {
            showConnectedMenu()
        } else {
            showConnectMenu()
        }
    }

    function showConnectedMenu() {
        if (!root.connectedMenuActive) {
            root.connectedMenuActive = true
            applicationsStack.replace(null, androidAutoConnectedMenuComponent)
        }
    }

    function showConnectMenu() {
        if (!root.connectMenuActive) {
            root.connectMenuActive = true
            applicationsStack.replace(null, androidAutoConnectMenuComponent)
        }
    }

    Component {
        id: androidAutoConnectMenuComponent

        AndroidAutoConnectMenu {
            onConnectViaUSBClicked: {
                AndroidAutoController.connectUSB()
            }

            onConnectViaWifiClicked: {
                AndroidAutoController.connectWiFi()
            }

            onConnectViaIpAddressClicked: {
                applicationsStack.push(androidAutoEnterAddressMenuComponent)
            }

            onConnectToGatewayClicked: {
                AndroidAutoController.connectToGateway()
            }

            onRecentConnectionsClicked: {
                applicationsStack.push(
                            androidAutoRecentConnectionsMenuComponent)
            }

            Component.onDestruction: {
                root.connectMenuActive = false
            }
        }
    }

    Component {
        id: androidAutoConnectedMenuComponent

        AndroidAutoConnectedMenu {
            onResumeClicked: {
                AndroidAutoController.resume()
            }

            onToggleDayNightClicked: {
                AndroidAutoController.toggleNightMode()
                AndroidAutoController.resume()
            }

            Component.onDestruction: {
                root.connectedMenuActive = false
            }
        }
    }

    Component {
        id: androidAutoRecentConnectionsMenuComponent

        AndroidAutoRecentConnectionsMenu {
            onAddressSelected: {
                applicationsStack.pop()
                AndroidAutoController.connectToAddress(address)
            }
        }
    }

    Component {
        id: androidAutoEnterAddressMenuComponent

        AndroidAutoEnterAddressMenu {
            onIpAddressEntered: {
                applicationsStack.pop()
                AndroidAutoController.connectToAddress(address)
            }
        }
    }
}
