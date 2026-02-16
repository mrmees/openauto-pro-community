import QtQuick 2.11
import QtGraphicalEffects 1.0
import OpenAuto 1.0
import OpenAuto.Input 1.0
import "../controls"
import "../../oainput/qml"

InputScope {
    signal closeClicked
    property bool controlsVisible: false

    id: root

    Rectangle {
        anchors.fill: parent
        color: "black"

        TouchControl {
            anchors.fill: parent
            onPressed: {
                root.showControls()
            }
        }

        Loader {
            id: videoSource
            anchors.fill: parent
            sourceComponent: {
                if (ConfigurationController.rearCameraBackendType === RearCameraBackendType.V4L2) {
                    return rearCameraV4L2OutputComponent
                } else if (ConfigurationController.rearCameraBackendType
                           === RearCameraBackendType.VIEW_FINDER) {
                    return rearCameraViewFinderOutputComponent
                } else {
                    return null
                }
            }
        }

        CloseButton {
            id: closeButton
            anchors.top: parent.top
            anchors.right: parent.right
            width: parent.width * 0.06
            height: width
            colorize: false
            onTriggered: {
                if (root.controlsVisible) {
                    root.closeClicked()
                }
            }

            Background {
                opacity: 0.5
            }

            PropertyAnimation {
                target: closeButton
                property: "opacity"
                running: root.controlsVisible
                from: 0
                to: 1
                duration: 400
            }

            PropertyAnimation {
                target: closeButton
                property: "opacity"
                running: !root.controlsVisible
                from: 1
                to: 0
                duration: 400
            }
        }

        RearCameraLanes {
            anchors.fill: parent
            visible: ConfigurationController.showRearCameraGuideLine
        }

        RearCameraLanes {
            anchors.fill: parent
            flip: true
            visible: ConfigurationController.showRearCameraGuideLine
        }

        Item {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: parent.height * 0.085

            Background {
                opacity: 0.5
            }

            Row {
                spacing: width * 0.05
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter

                Icon {
                    height: parent.height
                    width: parent.height
                    source: "/images/ico_warning.svg"
                    anchors.verticalCenter: parent.verticalCenter
                    colorize: false
                }

                SpecialText {
                    id: safetyText
                    text: qsTr("Please check surroundings for safety")
                    fontPixelSize: parent.height * 0.65
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    Timer {
        id: hideControlsTimer
        repeat: false
        running: false
        interval: 4000
        onTriggered: {
            root.controlsVisible = false
        }
    }

    Component {
        id: rearCameraV4L2OutputComponent

        RearCameraV4L2Output {}
    }

    Component {
        id: rearCameraViewFinderOutputComponent

        RearCameraViewFinderOutput {}
    }

    onGoDown: {
        root.showControls()
    }

    onGoUp: {
        root.showControls()
    }

    onGoLeft: {
        root.showControls()
    }

    onGoRight: {
        root.showControls()
    }

    onGoBack: {
        root.closeClicked()
    }

    onScrollLeft: {
        root.showControls()
    }

    onScrollRight: {
        root.showControls()
    }

    function showControls() {
        root.controlsVisible = true
        hideControlsTimer.running = true
    }
}
