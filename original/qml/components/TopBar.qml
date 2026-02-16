import QtQuick 2.11
import OpenAuto 1.0
import OpenAuto.Input 1.0
import "../controls"
import "../../oainput/qml"

Item {
    id: root
    visible: false

    ControlBackground {
        opacity: 1
    }

    TouchControl {
        anchors.fill: parent
    }
}
