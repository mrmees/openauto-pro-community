import QtQuick 2.11
import OpenAuto 1.0
import "../"
import "."

ApplicationBase {
    id: root
    rootComponent: telephoneMenuComponent

    Component {
        id: telephoneMenuComponent

        TelephoneMenu {
            onDialClicked: {
                applicationsStack.push(dialpadMenuComponent)
            }

            onContactsClicked: {
                applicationsStack.push(contactsMenuComponent)
            }

            onCallHistoryClicked: {
                applicationsStack.push(callHistoryMenuComponent)
            }

            onFavoritesClicked: {
                applicationsStack.push(favoritecontactsMenuComponent)
            }

            onAddDeviceClicked: {
                applicationsStack.push(addDeviceMenuComponent)
            }

            onPairedDevicesClicked: {
                applicationsStack.push(pairedDevicesMenuComponent)
            }
        }
    }

    Component {
        id: dialpadMenuComponent

        DialpadMenu {}
    }

    Component {
        id: contactsMenuComponent

        ContactsMenu {
            onContactSelected: {
                applicationsStack.push(contactDetailsMenuComponent, {
                                           "contactName": name,
                                           "contactNumber": number
                                       })
            }
        }
    }

    Component {
        id: contactDetailsMenuComponent

        ContactDetailsMenu {
            onDialClicked: {
                VoiceCallController.dial(number)
            }

            onFavoriteClicked: {
                TelephonyController.manageFavoriteContact(number)
            }
        }
    }

    Component {
        id: callHistoryMenuComponent

        CallHistoryMenu {
            onEntrySelected: {
                applicationsStack.push(contactDetailsMenuComponent, {
                                           "contactName": name,
                                           "contactNumber": number
                                       })
            }
        }
    }

    Component {
        id: activeCallMenuComponent

        ActiveCallMenu {
            onHangUpClicked: {
                VoiceCallController.hangUp()
                popActiveCallMenu()
            }

            onAnswerClicked: {
                VoiceCallController.answer()
            }
        }
    }

    Component {
        id: favoritecontactsMenuComponent

        FavoriteContactsMenu {
            onContactSelected: {
                applicationsStack.push(contactDetailsMenuComponent, {
                                           "contactName": name,
                                           "contactNumber": number
                                       })
            }
        }
    }

    Component {
        id: addDeviceMenuComponent

        AddDeviceMenu {
            onPairingDone: {
                applicationsStack.pop()
            }
        }
    }

    Component {
        id: pairedDevicesMenuComponent

        PairedDevicesMenu {

        }
    }

    function activate() {
        if (VoiceCallController.callState !== CallState.NONE) {
            if (!root.isActiveCallMenuActive()) {
                applicationsStack.replace(null, activeCallMenuComponent)
            }
        } else {
            applicationsStack.replace(null, telephoneMenuComponent)
        }
    }

    Connections {
        target: VoiceCallController
        onCallAdded: {
            if (!AndroidAutoController.projectionActive
                    && !AutoboxController.projectionActive
                    && !MirroringController.projectionActive) {
                applicationsStack.replace(null, activeCallMenuComponent)
            }
        }

        onCallRemoved: {
            popActiveCallMenu()
        }
    }

    function popActiveCallMenu() {
        if (root.isActiveCallMenuActive()) {
            applicationsStack.replace(null, rootComponent)
        }
    }

    function isActiveCallMenuActive() {
        return applicationsStack.currentItem.objectName === "ActiveCallMenu"
    }
}
