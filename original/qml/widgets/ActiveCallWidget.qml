import QtQuick 2.11
import OpenAuto 1.0
import "../controls"
import "../components"

Item {
    signal activeCallClicked

    id: root

    Item {
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.1
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        GridView {
            id: view
            anchors.fill: parent
            model: ObdController.sideWidgetModel

            cellWidth: view.width / 2
            cellHeight: view.cellWidth
            delegate: Item {
                property int gaugeWidth: width * 0.9
                property int gaugeHeight: gaugeWidth

                width: view.cellWidth
                height: view.cellWidth

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
        }
    }
}
