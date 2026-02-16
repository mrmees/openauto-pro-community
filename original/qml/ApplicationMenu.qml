import QtQuick 2.11
import OpenAuto 1.0
import "../controls"
import "../components"

ApplicationMenu {
    signal returnToSystemClicked

    id: root
    applicationType: ApplicationType.EXIT
    title: qsTr("Exit")

    GridView {
        id: view
        visible: !confirmationPopup.visible
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
                labelText: model.text
                iconPath: model.icon
                order: model.index
                onTriggered: {
                    if (model.index === 0) {
                        root.returnToSystemClicked()
                    } else if (model.index === 1) {
                        confirmationPopup.yesCallback = function () {
                            Qt.quit()
                        }
                        confirmationPopup.visible = true
                    } else if (model.index === 2) {
                        confirmationPopup.yesCallback = function () {
                            PowerController.reboot()
                        }
                        confirmationPopup.visible = true
                    } else if (model.index === 3) {
                        confirmationPopup.yesCallback = function () {
                            PowerController.shutdown()
                        }
                        confirmationPopup.visible = true
                    }
                }
            }
        }

        model: ListModel {
            ListElement {
                property string text: qsTr("Return")
                property string icon: "/images/ico_redo.svg"
            }

            ListElement {
                property string text: qsTr("Exit")
                property string icon: "/images/ico_exit.svg"
            }

            ListElement {
                property string text: qsTr("Reboot")
                property string icon: "/images/ico_return.svg"
            }

            ListElement {
                property string text: qsTr("Shutdown")
                property string icon: "/images/ico_poweroff.svg"
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
