import QtQuick 2.11
import OpenAuto 1.0
import "../../controls"

TelephoneApplicationMenu {
    signal contactsClicked
    signal dialClicked
    signal callHistoryClicked
    signal favoritesClicked
    signal addDeviceClicked
    signal pairedDevicesClicked

    id: root
    title: TelephonyController.phoneConnected ? qsTr("Telephone (%1)").arg(
                                                    TelephonyController.phoneName) : qsTr(
                                                    "Telephone")

    GridView {
        id: view
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.bottom: parent.bottom
        model: ListModel {
            ListElement {
                name: qsTr("Favorites")
                iconPath: "/images/ico_favorites.svg"
            }

            ListElement {
                name: qsTr("Contacts")
                iconPath: "/images/ico_contacts.svg"
            }

            ListElement {
                name: qsTr("Dial")
                iconPath: "/images/ico_dialpad.svg"
            }

            ListElement {
                name: qsTr("Call history")
                iconPath: "/images/ico_recent.svg"
            }

            ListElement {
                name: qsTr("Add")
                iconPath: "/images/ico_phone_device.svg"
            }

            ListElement {
                name: qsTr("Paired")
                iconPath: "/images/ico_bluetooth_connected.svg"
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
                        favoritesClicked()
                    } else if (model.index === 1) {
                        contactsClicked()
                    } else if (model.index === 2) {
                        dialClicked()
                    } else if (model.index === 3) {
                        callHistoryClicked()
                    } else if (model.index === 4) {
                        addDeviceClicked()
                    } else if (model.index === 5) {
                        pairedDevicesClicked()
                    }
                }
            }
        }
    }
}
