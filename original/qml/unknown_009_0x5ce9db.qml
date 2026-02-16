import QtQuick 2.11
import OpenAuto 1.0

BaseContactsMenu {
    title: qsTr("Contacts")
    model: TelephonyController.phonebookModel
}
