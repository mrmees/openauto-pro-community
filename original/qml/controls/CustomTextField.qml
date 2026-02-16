import QtQuick 2.11
import QtQuick.Controls 2.4
import OpenAuto 1.0
import "../controls"

StackView {
    id: root
    pushEnter: enterTransition
    pushExit: exitTransition
    popEnter: enterTransition
    popExit: exitTransition
    replaceEnter: enterTransition
    replaceExit: exitTransition

    Transition {
        id: enterTransition

        PropertyAnimation {
            property: "scale"
            from: 0.9
            to: 1
            duration: 300
        }

        PropertyAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: 300
        }
    }

    Transition {
        id: exitTransition
    }
}
