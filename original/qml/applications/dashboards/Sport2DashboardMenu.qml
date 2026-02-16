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
        property int gaugeHorizontalMargin: gaugeWidth * 0.2
        property int gaugeVerticalMargin: gaugeWidth * 0.075

        id: container
        anchors.fill: parent

        Gauge {
            id: centerGauge
            anchors.centerIn: parent
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
            id: topLeftGauge
            anchors.left: parent.left
            anchors.leftMargin: container.gaugeHorizontalMargin
            anchors.top: parent.top
            anchors.topMargin: container.gaugeVerticalMargin
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
            id: topRightGauge
            anchors.right: parent.right
            anchors.rightMargin: container.gaugeHorizontalMargin
            anchors.top: parent.top
            anchors.topMargin: container.gaugeVerticalMargin
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
            id: bottomLeftGauge
            anchors.left: parent.left
            anchors.leftMargin: container.gaugeHorizontalMargin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: container.gaugeVerticalMargin
            width: container.gaugeWidth
            height: container.gaugeHeight
            label: root.dashboardModel.getProperty(3, "label")
            minValue: root.dashboardModel.getProperty(3, "minValue")
            maxValue: root.dashboardModel.getProperty(3, "maxValue")
            minLimit: root.dashboardModel.getProperty(3, "minLimit")
            maxLimit: root.dashboardModel.getProperty(3, "maxLimit")
            formula: root.dashboardModel.getProperty(3, "formula")
            precision: root.dashboardModel.getProperty(3, "precision")
            opacity: 0
        }

        Gauge {
            id: bottomRightGauge
            anchors.right: parent.right
            anchors.rightMargin: container.gaugeHorizontalMargin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: container.gaugeVerticalMargin
            width: container.gaugeWidth
            height: container.gaugeHeight
            label: root.dashboardModel.getProperty(4, "label")
            minValue: root.dashboardModel.getProperty(4, "minValue")
            maxValue: root.dashboardModel.getProperty(4, "maxValue")
            minLimit: root.dashboardModel.getProperty(4, "minLimit")
            maxLimit: root.dashboardModel.getProperty(4, "maxLimit")
            formula: root.dashboardModel.getProperty(4, "formula")
            precision: root.dashboardModel.getProperty(4, "precision")
            opacity: 0
        }

        SequentialAnimation {
            running: true

            GaugeEnterAnimation {
                target: centerGauge
            }

            PauseAnimation {
                duration: 500
            }

            ParallelAnimation {
                GaugeEnterAnimation {
                    target: topLeftGauge
                }

                GaugeEnterAnimation {
                    target: topRightGauge
                }

                GaugeEnterAnimation {
                    target: bottomLeftGauge
                }

                GaugeEnterAnimation {
                    target: bottomRightGauge
                }
            }
        }
    }
}
