import QtQuick 2.11
import OpenAuto 1.0
import "../"
import "../../components"

ApplicationBase {
    property bool setupPluginMenuActive: false
    property bool connectMenuActive: false
    property bool connectedMenuActive: false

    id: root
    rootComponent: autoboxConnectMenuComponent

    function activate() {
        if (!LicenseController.autoboxPluginValid
                || !LicenseController.autoboxLicenseValid) {
            showSetupPluginMenu()
        } else if (AutoboxController.running) {
            showConnectedMenu()
        } else {
            showConnectMenu()
        }
    }

    function showConnectedMenu() {
        if (!root.connectedMenuActive) {
            root.connectedMenuActive = true
            applicationsStack.replace(null, autoboxConnectedMenuComponent)
        }
    }

    function showConnectMenu() {
        if (!root.connectMenuActive) {
            root.connectMenuActive = true
            applicationsStack.replace(null, autoboxConnectMenuComponent)
        }
    }

    function showSetupPluginMenu() {
        if (!root.setupPluginMenuActive) {
            root.setupPluginMenuActive = true
            applicationsStack.replace(null, autoboxSetupPluginMenuComponent)
        }
    }

    Component {
        id: autoboxConnectMenuComponent

        AutoboxConnectMenu {
            onConnectViaWifiClicked: {
                AutoboxController.connectWiFi()
            }

            onInfoClicked: {
                applicationsStack.push(autoboxDeviceInfoMenuComponent)
            }

            Component.onDestruction: {
                root.connectMenuActive = false
            }
        }
    }

    Component {
        id: autoboxConnectedMenuComponent

        AutoboxConnectedMenu {
            onResumeClicked: {
                AutoboxController.resume()
            }

            onInfoClicked: {
                applicationsStack.push(autoboxDeviceInfoMenuComponent)
            }

            Component.onDestruction: {
                root.connectedMenuActive = false
            }
        }
    }

    Component {
        id: autoboxSetupPluginMenuComponent

        AutoboxSetupPluginMenu {
            onBrowseClicked: {
                applicationsStack.push(autoboxBrowsePluginFileMenuComponent)
            }

            onEnterSerialNumberClicked: {
                applicationsStack.push(autoboxEnterSerialNumberMenuComponent)
            }

            onFinishSetupClicked: {
                root.showConnectMenu()
                LicenseController.activateAutoboxLicense()
            }

            Component.onDestruction: {
                root.setupPluginMenuActive = false
            }
        }
    }

    Component {
        id: autoboxBrowsePluginFileMenuComponent

        AutoboxBrowsePluginFileMenu {
            onFileSelected: {
                LicenseController.validateAutoboxPlugin(path)
                applicationsStack.pop()
            }
        }
    }

    Component {
        id: autoboxEnterSerialNumberMenuComponent

        AutoboxEnterSerialNumberMenu {
            onValidateSerialNumberClicked: {
                validationParams.result = LicenseController.validateAutoboxLicense(
                            validationParams.serialNumber)

                if (validationParams.result) {
                    applicationsStack.pop()
                }
            }
        }
    }

    Component {
        id: autoboxDeviceInfoMenuComponent

        AutoboxDeviceInfoMenu {}
    }
}
