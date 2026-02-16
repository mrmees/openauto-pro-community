import QtQuick 2.11
import OpenAuto 1.0
import "../../oainput/qml"

Item {
    property int spacing: height * 0.25
    property alias titleText: titleLabel.titleText
    property bool titleOnly: false

    id: root

    TopBarTitle {
        id: titleLabel
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: root.titleOnly ? parent.right : container.left
        anchors.rightMargin: root.spacing
        height: parent.height
        fontPixelSize: parent.height * 0.65
        visible: !AndroidAutoController.projectionActive
                 && !MirroringController.projectionActive
                 && !AutoboxController.projectionActive
                 && ConfigurationController.obdBarDisplayModeType !== ObdBarDisplayModeType.ALWAYS
    }

    TopBarGaugesWidget {
        id: topBarGaugesWidget
        anchors.left: parent.left
        anchors.right: container.left
        anchors.rightMargin: root.spacing
        height: parent.height
        active: ObdController.topBarWidgetModel !== null && !titleLabel.visible
                && ConfigurationController.obdBarDisplayModeType !== ObdBarDisplayModeType.NONE
        visible: topBarGaugesWidget.active && !notificationMessageSmall.active
        model: ObdController.topBarWidgetModel
    }

    NotificationMessageSmall {
        id: notificationMessageSmall
        anchors.left: parent.left
        anchors.right: container.left
        anchors.rightMargin: root.spacing
        height: parent.height
        visible: AndroidAutoController.projectionActive
                 || MirroringController.projectionActive
                 || AutoboxController.projectionActive
    }

    Item {
        function sumWidth(element) {
            if (element.visible) {
                return element.width + element.anchors.rightMargin + element.anchors.leftMargin
            }

            return 0
        }

        id: container
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        visible: !root.titleOnly
        width: {
            return sumWidth(signalStrength) + sumWidth(batteryLevel) + sumWidth(
                        temperature) + sumWidth(clock) + sumWidth(
                        statusIconsBar)
        }

        SignalStrength {
            id: signalStrength
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: batteryLevel.left
            anchors.rightMargin: root.spacing * 2.05
            width: height * 1.5
            height: parent.height * 0.6
            visible: TelephonyController.phoneConnected
                     && !AndroidAutoController.projectionActive
                     && !MirroringController.projectionActive
                     && !AutoboxController.projectionActive
        }

        BatteryLevel {
            id: batteryLevel
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: statusIconsBar.left
            anchors.rightMargin: root.spacing * 1.55
            width: height * 0.5
            height: parent.height * 0.6
            visible: TelephonyController.phoneConnected
                     && !AndroidAutoController.projectionActive
                     && !MirroringController.projectionActive
                     && !AutoboxController.projectionActive
        }

        StatusIconsBar {
            id: statusIconsBar
            anchors.right: {
                if (temperature.visible) {
                    return temperature.left
                } else if (clock.visible) {
                    return clock.left
                } else {
                    return parent.right
                }
            }

            anchors.rightMargin: root.spacing * 1.5
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            spacing: root.spacing * 0.75
        }

        Temperature {
            id: temperature
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: clock.visible ? clock.left : parent.right
            anchors.rightMargin: root.spacing * 1.5
            visible: ConfigurationController.showTemperature
            fontPixelSize: parent.height * 0.65
        }

        Clock {
            id: clock
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            visible: {
                if (AndroidAutoController.projectionActive) {
                    return ConfigurationController.showClockInAndroidAuto
                } else if (MirroringController.projectionActive) {
                    return ConfigurationController.showClockInMirroring
                } else if (AutoboxController.projectionActive) {
                    return ConfigurationController.showClockInAutobox
                }

                return ConfigurationController.showClockInOpenAuto
            }

            fontPixelSize: parent.height * 0.65
        }
    }

    TouchControl {
        anchors.left: parent.left
        anchors.right: titleLabel.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }
}
