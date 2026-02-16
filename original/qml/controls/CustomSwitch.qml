import QtQuick 2.11
import QtQuick.Controls 2.4
import "../../oainput/qml"

TextField {
    property alias backgroundColor: textFieldBackground.color
    id: root
    readOnly: true
    color: "black"
    horizontalAlignment: TextInput.AlignHCenter

    background: Rectangle {
        id: textFieldBackground
        opacity: 0.7
        color: "white"
        border.color: "gray"
    }

    TouchControl {
        anchors.fill: parent
    }
}
