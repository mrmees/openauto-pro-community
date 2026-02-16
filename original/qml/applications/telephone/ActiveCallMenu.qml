import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"
import "../../components"

TelephoneApplicationMenu {
    id: root
    title: qsTr("Paired devices")

    ListView {
        property int animationDuration: 500

        id: listView
        visible: !confirmationPopup.visible
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.bottom: parent.bottom
        model: BluetoothController.piredDeviceListModel

        onVisibleChanged: {
            root.highlightDefaultControl()
        }

        delegate: Item {
            width: listView.width
            height: listView.height / 5

            PairedDevice {
                width: parent.width * 0.975
                height: parent.height * 0.95
                nameText: model.name
                addressText: model.address
                order: model.index
                onRemoveTriggered: {
                    confirmationPopup.yesCallback = function () {
                        BluetoothController.removeDevice(model.address)
                    }
                    confirmationPopup.visible = true
                }
            }
        }

        ScrollBar.vertical: CustomScrollBar {
            id: scrollBar
            active: true
            visible: listView.count > 4
            anchors.top: parent.top
        }

        add: Transition {
            NumberAnimation {
                properties: "x"
                from: listView.width / 2
                duration: listView.animationDuration
            }
        }

        addDisplaced: Transition {
            NumberAnimation {
                properties: "x"
                duration: listView.animationDuration * 2
            }
        }

        move: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: listView.animationDuration * 2
            }
        }

        moveDisplaced: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: listView.animationDuration * 2
            }
        }

        remove: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity"
                    to: 0
                    duration: listView.animationDuration
                }
                NumberAnimation {
                    properties: "x"
                    to: listView.width / 2
                    duration: listView.animationDuration
                }
            }
        }

        removeDisplaced: Transition {
            NumberAnimation {
                properties: "x"
                duration: listView.animationDuration
            }
        }
    }

    YesNoPopup {
        property var yesCallback

        id: confirmationPopup
        anchors.fill: parent
        messageText: qsTr("Do you want to proceed?")
        onVisibleChanged: {
            root.highlightDefaultControl()
        }

        onYesClicked: {
            confirmationPopup.visible = false
            yesCallback()
        }

        onNoClicked: {
            confirmationPopup.visible = false
        }
    }
}
