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
            anchors.fill: parent
            model: root.dashboardModel

            cellWidth: view.width / 4
            cellHeight: view.height / 2
            delegate: Item {
                property int gaugeWidth: width * 0.85
                property int gaugeHeight: gaugeWidth

                width: view.cellWidth
                height: view.cellWidth
                opacity: 0

                Gauge {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.gaugeWidth
                    height: parent.gaugeHeight
                    label: model.label
                    minValue: model.minValue
                    maxValue: model.maxValue
                    minLimit: model.minLimit
                    maxLimit: model.maxLimit
                    formula: model.formula
                    precision: model.precision
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
}
