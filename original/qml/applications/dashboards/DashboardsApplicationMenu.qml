import QtQuick 2.11
import OpenAuto 1.0
import OpenAuto 1.0
import "../../controls"

HomeApplicationMenu {
    signal telephoneClicked
    signal androidAutoClicked
    signal applicationsClicked
    signal musicClicked
    signal radioClicked
    signal mirroringClicked
    signal myCarClicked
    signal settingsClicked
    signal rearCameraClicked
    signal dashboardsClicked
    signal equalizerClicked
    signal autoboxClicked

    title: qsTr("Home")
    id: root

    onMoveToNextControl: {
        view.moveCurrentIndexRight()
    }

    onMoveToPreviousControl: {
        view.moveCurrentIndexLeft()
    }

    onActivated: {
        view.currentIndex = 0
        view.positionViewAtBeginning()
    }

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
                name: qsTr("Telephone")
                iconPath: "/images/ico_telephone.svg"
            }

            ListElement {
                name: qsTr("Android Auto")
                iconPath: "/images/ico_androidauto.svg"
            }

            ListElement {
                name: qsTr("Autobox")
                iconPath: "/images/ico_autobox.svg"
            }

            ListElement {
                name: qsTr("Mirroring")
                iconPath: "/images/ico_mirroring.svg"
            }

            ListElement {
                name: qsTr("Rear camera")
                iconPath: "/images/ico_rear_camera.svg"
            }

            ListElement {
                name: qsTr("Dashboards")
                iconPath: "/images/ico_gauges.svg"
            }

            ListElement {
                name: qsTr("Music")
                iconPath: "/images/ico_music.svg"
            }

            ListElement {
                name: qsTr("Equalizer")
                iconPath: "/images/ico_equalizer.svg"
            }

            ListElement {
                name: qsTr("Applications")
                iconPath: "/images/ico_applications.svg"
            }
        }

        cellWidth: (width / 5) // - (scrollBar.width / 2.5)
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
                        telephoneClicked()
                    } else if (model.index === 1) {
                        androidAutoClicked()
                    } else if (model.index === 2) {
                        autoboxClicked()
                    } else if (model.index === 3) {
                        mirroringClicked()
                    } else if (model.index === 4) {
                        rearCameraClicked()
                    } else if (model.index === 5) {
                        dashboardsClicked()
                    } else if (model.index === 6) {
                        musicClicked()
                    } else if (model.index === 7) {
                        equalizerClicked()
                    } else if (model.index === 8) {
                        applicationsClicked()
                    }
                }
            }
        }

        //        ScrollBar.vertical: CustomScrollBar {
        //            id: scrollBar
        //            active: true
        //            visible: view.count > 8
        //            anchors.top: parent.top
        //        }
    }
}
