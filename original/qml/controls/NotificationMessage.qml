import QtQuick 2.11
import OpenAuto 1.0
import "../controls"

Item {
    property var model: null
    property alias active: loader.active
    property string label

    id: root

    Loader {
        id: loader
        anchors.fill: parent
        sourceComponent: gaugesComponent

        states: [
            State {
                when: visible
                PropertyChanges {
                    target: loader
                    opacity: 1.0
                }
            },
            State {
                when: !visible
                PropertyChanges {
                    target: loader
                    opacity: 0.0
                }
            }
        ]

        transitions: Transition {
            NumberAnimation {
                property: "opacity"
                duration: 1000
            }
        }
    }

    Component {
        id: gaugesComponent

        Item {
            anchors.fill: parent

            NormalText {
                verticalAlignment: Text.AlignVCenter
                width: parent.width
                height: parent.height
                fontPixelSize: height * 0.6
                text: root.label
            }

            Component.onCompleted: {
                if (root.model !== null) {
                    for (var i = 0; i < root.model.rowCount(); i++) {
                        ObdController.startMonitorFormula(
                                    root.model.getProperty(i, "formula"))
                    }

                    root.refreshLabel()
                }
            }

            Component.onDestruction: {
                if (root.model !== null) {
                    for (var i = 0; i < root.model.rowCount(); i++) {
                        ObdController.stopMonitorFormula(root.model.getProperty(
                                                             i, "formula"))
                    }
                }
            }

            Connections {
                target: ObdController
                onFormulaValueChanged: {
                    if (root.model !== null) {
                        var changed = false

                        for (var i = 0; i < root.model.rowCount(); i++) {
                            if (root.model.getProperty(i,
                                                       "formula") === formula) {
                                changed = true
                                break
                            }
                        }

                        if (changed) {
                            root.refreshLabel()
                        }
                    }
                }

                onDeviceActiveChanged: {
                    root.refreshLabel()
                }
            }
        }
    }

    function clampValue(value, minValue, maxValue, precision) {
        var newValue = value

        if (value < minValue) {
            newValue = minValue
        } else if (value > maxValue) {
            newValue = maxValue
        }

        return newValue.toFixed(precision)
    }

    function refreshLabel() {
        var separator = "  •  "
        label = ""

        if (root.model !== null) {
            for (var i = 0; i < root.model.rowCount(); i++) {
                var formula = root.model.getProperty(i, "formula")
                var value = clampValue(ObdController.getFormulaValue(formula),
                                       root.model.getProperty(i, "minValue"),
                                       root.model.getProperty(i, "maxValue"),
                                       root.model.getProperty(i, "precision"))
                label += (value + " " + root.model.getProperty(i, "label"))

                if ((i + 1) < root.model.rowCount()) {
                    label += "  •  "
                }
            }
        }
    }
}
