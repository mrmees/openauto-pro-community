import QtQuick 2.11
import OpenAuto 1.0
import "../../components"
import "../../controls"

DashboardMenu {
    id: root
    title: dashboardTitle
    sourceComponent: Item {
        GridView {
            id: view
            width: parent.width
            height: parent.height * 0.8
            anchors.centerIn: parent
            model: root.dashboardModel

            cellWidth: view.width / 4
            cellHeight: view.height / 2
            delegate: Item {
                id: delegateItem
                property int value: clampValue(ObdController.getFormulaValue(
                                                   model.formula), model)

                width: view.cellWidth * 0.99
                height: view.cellHeight * 0.99
                opacity: 0

                ControlBackground {
                    radius: height * 0.05
                }

                NormalText {
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: height * 0.25
                    width: parent.width
                    height: parent.height * 0.5
                    fontPixelSize: height * 0.35
                    text: delegateItem.value
                }

                NormalText {
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: parent.height * 0.5
                    fontPixelSize: height * 0.25
                    minimumPixelSize: height * 0.2
                    fontSizeMode: Text.Fit
                    text: model.label
                }

                Connections {
                    target: ObdController
                    onFormulaValueChanged: {
                        if (model.formula === formula) {
                            delegateItem.value = clampValue(value, model)
                        }
                    }

                    onDeviceActiveChanged: {
                        delegateItem.value = ObdController.getFormulaValue(
                                    model.formula).toFixed(model.precision)
                    }
                }

                Component.onCompleted: {
                    ObdController.startMonitorFormula(model.formula)
                }

                Component.onDestruction: {
                    ObdController.stopMonitorFormula(model.formula)
                }

                Behavior on value {
                    SmoothedAnimation {
                        duration: 500
                        velocity: -1
                    }
                }
            }

            populate: Transition {
                id: populateTransition

                GaugeEnterAnimation {
                    delay: (populateTransition.ViewTransition.index + 1) * 300
                }
            }
        }
    }

    function clampValue(value, model) {
        var newValue = value

        if (value < model.minValue) {
            newValue = model.minValue
        } else if (value > model.maxValue) {
            newValue = model.maxValue
        }

        return newValue.toFixed(model.precision)
    }
}
