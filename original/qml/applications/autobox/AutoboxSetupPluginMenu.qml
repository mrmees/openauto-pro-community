import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"

TelephoneApplicationMenu {
    property string contactName
    property string contactNumber
    signal dialClicked(string number)
    signal favoriteClicked(string number)

    id: root
    title: qsTr("Contact details")
    defaultControl: dialButton

    Item {
        width: parent.width * 0.8
        height: parent.height * 0.5
        anchors.centerIn: parent

        ControlBackground {
            radius: height * 0.05
        }

        Icon {
            id: personIcon
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.03
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.25
            anchors.bottom: parent.bottom
            anchors.bottomMargin: anchors.topMargin
            width: height
            source: "/images/ico_person.svg"
        }

        RowLayout {
            id: detailsContainer
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.05
            anchors.bottom: parent.bottom
            anchors.bottomMargin: anchors.topMargin
            anchors.right: favoritesIcon.left
            anchors.left: personIcon.right
            anchors.leftMargin: parent.width * 0.025

            ColumnLayout {
                Layout.preferredHeight: detailsContainer.height * 0.85
                Layout.preferredWidth: parent.width
                Layout.alignment: Qt.AlignVCenter
                spacing: parent.height * 0.075

                NormalText {
                    scrollableText: contactName
                    elide: Text.ElideRight
                    fontPixelSize: detailsContainer.height * 0.14
                    horizontalAlignment: Text.AlignHCenter
                    Layout.preferredWidth: parent.width
                }

                DescriptionText {
                    scrollableText: contactNumber
                    fontPixelSize: detailsContainer.height * 0.11
                    elide: Text.ElideRight
                    Layout.preferredWidth: parent.width
                    horizontalAlignment: Text.AlignHCenter
                }

                BarIcon {
                    id: dialButton
                    Layout.preferredHeight: detailsContainer.height * 0.3
                    Layout.preferredWidth: detailsContainer.height * 0.3
                    Layout.alignment: Qt.AlignHCenter
                    source: "/images/ico_answercall.svg"
                    colorize: false
                    onTriggered: {
                        dialClicked(contactNumber)
                    }
                }
            }
        }

        BarIcon {
            id: favoritesIcon
            anchors.bottomMargin: height * 0.1
            anchors.rightMargin: height * 0.1
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            source: TelephonyController.hasFavoriteContact(
                        contactNumber) ? "/images/ico_favorites.svg" : "/images/ico_favorites_inactive.svg"
            height: parent.height * 0.25
            width: height

            onTriggered: {
                favoriteClicked(contactNumber)
            }
        }

        Connections {
            target: TelephonyController
            onFavoriteContactsListChanged: {
                favoritesIcon.source = TelephonyController.hasFavoriteContact(
                            contactNumber) ? "/images/ico_favorites.svg" : "/images/ico_favorites_inactive.svg"
            }
        }
    }
}
