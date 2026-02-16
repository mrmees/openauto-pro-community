import QtQuick 2.11
import OpenAuto 1.0
import "../../controls"
import "../../components"

AndroidAutoApplicationMenu {
    signal connectViaUSBClicked
    signal connectViaWifiClicked
    signal connectViaIpAddressClicked
    signal connectToGatewayClicked
    signal recentConnectionsClicked

    id: root
    title: qsTr("Connect to Android Auto")

    GridView {
        id: view
        visible: !androidAutoConnectingPopup.visible
                 && !androidAutoConnectionFailedPopup.visible
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.bottom: parent.bottom

        onVisibleChanged: {
            root.highlightDefaultControl()
        }

        model: ListModel {
            ListElement {
                name: qsTr("USB")
                iconPath: "/images/ico_usb.svg"
            }

            ListElement {
                name: qsTr("Wi-Fi")
                iconPath: "/images/ico_wifi.svg"
            }

            ListElement {
                name: qsTr("IP Address")
                iconPath: "/images/ico_wifi.svg"
            }

            ListElement {
                name: qsTr("Gateway")
                iconPath: "/images/ico_wifi.svg"
            }

            ListElement {
                name: qsTr("Recents")
                iconPath: "/images/ico_recent.svg"
            }
        }

        cellWidth: width / 5
        cellHeight: height / 2.9
        delegate: Item {
            width: view.cellWidth
            height: view.cellHeight

            Tile {
                anchors.centerIn: parent
                width: parent.width * 0.985
                height: parent.height * 0.985
                labelText: model.name
                iconPath: model.iconPath
                order: model.index

                onTriggered: {
                    if (model.index === 0) {
                        connectViaUSBClicked()
                    } else if (model.index === 1) {
                        connectViaWifiClicked()
                    } else if (model.index === 2) {
                        connectViaIpAddressClicked()
                    } else if (model.index === 3) {
                        connectToGatewayClicked()
                    } else if (model.index === 4) {
                        recentConnectionsClicked()
                    }
                }
            }
        }
    }

    AndroidAutoConnectingPopup {
        id: androidAutoConnectingPopup
        anchors.fill: parent
        onVisibleChanged: {
            root.highlightDefaultControl()
        }
    }

    AndroidAutoConnectionFailedPopup {
        id: androidAutoConnectionFailedPopup
        anchors.fill: parent
        onVisibleChanged: {
            root.highlightDefaultControl()
        }
    }

    Connections {
        target: AndroidAutoController

        onAndroidAutoConnecting: {
            androidAutoConnectionFailedPopup.visible = false
            androidAutoConnectingPopup.visible = true
        }

        onAndroidAutoConnectionFailed: {
            androidAutoConnectingPopup.visible = false
            androidAutoConnectionFailedPopup.visible = true
        }
    }
}
