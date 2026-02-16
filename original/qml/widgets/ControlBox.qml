import QtQuick 2.11
import OpenAuto 1.0
import "../tools/MathTools.js" as MathTools

Item {
    property int precision
    property double minValue
    property double maxValue
    property double minLimit: root.minValue
    property double maxLimit: root.maxValue
    property string label
    property string formula

    id: root

    Loader {
        id: loader
        anchors.fill: parent
        sourceComponent: {
            var hasMinLimit = !MathTools.areTheSame(minValue, minLimit, precision)
            var hasMaxLimit = !MathTools.areTheSame(maxValue, maxLimit, precision)

            if(hasMinLimit || hasMaxLimit) {
                return limitedGaugeComponent
            } else {
                return unlimitedGaugeComponent
            }
        }
        asynchronous: true
        onItemChanged: {
            if (loader.item != null) {
                loader.item.value = ObdController.getFormulaValue(root.formula)
            }
        }
    }

    Component {
        id: limitedGaugeComponent

        LimitedGauge {
            precision: root.precision
            minValue: root.minValue
            maxValue: root.maxValue
            minLimit: root.minLimit
            maxLimit: root.maxLimit
            label: root.label
        }
    }

    Component {
        id: unlimitedGaugeComponent

        UnlimitedGauge {
            precision: root.precision
            minValue: root.minValue
            maxValue: root.maxValue
            label: root.label
        }
    }

    Connections {
        target: ObdController
        onFormulaValueChanged: {
            if (root.formula === formula && loader.item != null) {
                var newValue = value

                if (value < loader.item.minValue) {
                    newValue = loader.item.minValue
                } else if (value > loader.item.maxValue) {
                    newValue = loader.item.maxValue
                }

                loader.item.value = newValue
            }
        }

        onDeviceActiveChanged: {
            if (loader.item != null) {
                loader.item.value = ObdController.getFormulaValue(root.formula)
            }
        }
    }

    Component.onCompleted: {
        ObdController.startMonitorFormula(root.formula)
    }

    Component.onDestruction: {
        ObdController.stopMonitorFormula(root.formula)
    }
}
