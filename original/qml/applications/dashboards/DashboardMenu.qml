import QtQuick 2.11
import OpenAuto 1.0
import "../../components"
import "../../controls"

DashboardMenu {
    id: root
    title: dashboardTitle

    sourceComponent: Item {
        property int gaugeWidth: height * 0.45
        property int gaugeHeight: gaugeWidth
        property int gaugeHorizontalMargin: gaugeWidth * 0.15
        property int gaugeVerticalMargin: gaugeWidth * 0.01

        id: container

        anchors.fill: parent

        Gauge {
            id: leftGauge
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.1
            anchors.top: parent.top
            anchors.topMargin: container.gaugeVerticalMargin * 1.25
            width: parent.height * 0.75
            height: width
            label: root.dashboardModel.getProperty(0, "label")
            minValue: root.dashboardModel.getProperty(0, "minValue")
            maxValue: root.dashboardModel.getProperty(0, "maxValue")
            minLimit: root.dashboardModel.getProperty(0, "minLimit")
            maxLimit: root.dashboardModel.getProperty(0, "maxLimit")
            formula: root.dashboardModel.getProperty(0, "formula")
            precision: root.dashboardModel.getProperty(0, "precision")
            opacity: 0
        }

        Gauge {
            id: topGauge
            anchors.left: leftGauge.left
            anchors.leftMargin: leftGauge.width * 0.99
            anchors.top: parent.top
            width: container.gaugeWidth
            height: container.gaugeHeight
            label: root.dashboardModel.getProperty(1, "label")
            minValue: root.dashboardModel.getProperty(1, "minValue")
            maxValue: root.dashboardModel.getProperty(1, "maxValue")
            minLimit: root.dashboardModel.getProperty(1, "minLimit")
            maxLimit: root.dashboardModel.getProperty(1, "maxLimit")
            formula: root.dashboardModel.getProperty(1, "formula")
            precision: root.dashboardModel.getProperty(1, "precision")
            opacity: 0
        }

        Gauge {
            id: rightGauge
            anchors.left: leftGauge.right
            anchors.leftMargin: topGauge.width * 0.85
            anchors.top: parent.top
            anchors.topMargin: topGauge.height * 0.55
            width: container.gaugeWidth
            height: container.gaugeHeight
            label: root.dashboardModel.getProperty(2, "label")
            minValue: root.dashboardModel.getProperty(2, "minValue")
            maxValue: root.dashboardModel.getProperty(2, "maxValue")
            minLimit: root.dashboardModel.getProperty(2, "minLimit")
            maxLimit: root.dashboardModel.getProperty(2, "maxLimit")
            formula: root.dashboardModel.getProperty(2, "formula")
            precision: root.dashboardModel.getProperty(2, "precision")
            opacity: 0
        }

        Gauge {
            id: bottomGauge
            anchors.left: leftGauge.left
            anchors.leftMargin: leftGauge.width * 0.88
            anchors.top: rightGauge.top
            anchors.topMargin: rightGauge.height * 0.475
            width: container.gaugeWidth * 1.175
            height: container.gaugeHeight * 1.175
            label: root.dashboardModel.getProperty(3, "label")
            minValue: root.dashboardModel.getProperty(3, "minValue")
            maxValue: root.dashboardModel.getProperty(3, "maxValue")
            minLimit: root.dashboardModel.getProperty(3, "minLimit")
            maxLimit: root.dashboardModel.getProperty(3, "maxLimit")
            formula: root.dashboardModel.getProperty(3, "formula")
            precision: root.dashboardModel.getProperty(3, "precision")
            opacity: 0
        }

        SequentialAnimation {
            running: true

            GaugeEnterAnimation {
                target: leftGauge
            }

            GaugeEnterAnimation {
                target: topGauge
            }

            GaugeEnterAnimation {
                target: rightGauge
            }

            GaugeEnterAnimation {
                target: bottomGauge
            }
        }
    }
}
