import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import OpenAuto.Input 1.0
import "../../oainput/qml"
import "../controls"
import "../widgets"

InputScope {
    enum WidgetType {
        ActiveCall,
        AndroidAutoNavigation,
        Music,
        Gauges
    }

    signal musicSourceClicked
    signal activeCallClicked
    signal navigationClicked
    property int currentWidget: SideWidget.WidgetType.Music

    id: root

    Rectangle {
        anchors.fill: parent
        color: ThemeController.sideWidgetBackgroundColor
    }

    Rectangle {
        id: divider
        color: ThemeController.barShadowColor
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        state: ConfigurationController.handednessOfTraffic
               === HandednessOfTrafficType.LEFT_HAND_DRIVE ? "LEFT_HAND_DRIVE" : "RIGHT_HAND_DRIVE"
        width: parent.height * 0.002

        states: [
            State {
                name: "LEFT_HAND_DRIVE"
                AnchorChanges {
                    target: divider
                    anchors.left: parent.left
                    anchors.right: undefined
                }
            },
            State {
                name: "RIGHT_HAND_DRIVE"
                AnchorChanges {
                    target: divider
                    anchors.left: undefined
                    anchors.right: parent.right
                }
            }
        ]
    }

    Loader {
        id: widgetLoader
        anchors.top: parent.top
        anchors.topMargin: parent.width * 0.01
        anchors.bottom: rowLayout.top
        anchors.bottomMargin: parent.width * 0.01
        width: parent.width * 0.95
        anchors.horizontalCenter: parent.horizontalCenter
        sourceComponent: musicWidgetComponent
        onSourceComponentChanged: {
            animation.running = true
        }

        ParallelAnimation {
            id: animation

            PropertyAnimation {
                target: widgetLoader.item
                property: "scale"
                from: 0.9
                to: 1
                duration: 300
            }

            PropertyAnimation {
                target: widgetLoader.item
                property: "opacity"
                from: 0
                to: 1
                duration: 300
            }
        }
    }

    Item {
        anchors.top: widgetLoader.bottom
        anchors.bottom: rowLayout.top
        anchors.left: parent.left
        anchors.right: parent.right

        GradientLine {
            anchors.top: parent.top
            width: parent.width * 0.8
            height: parent.height * 0.35
            anchors.horizontalCenter: parent.horizontalCenter

            startColor: "transparent"
            endColor: ThemeController.controlForegroundColor
        }
    }

    RowLayout {
        property real buttonWidth: height * 0.8
        property real buttonHeight: height * 0.8

        id: rowLayout
        anchors.bottom: parent.bottom
        anchors.bottomMargin: width * 0.015
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.01
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.01
        height: parent.height * 0.11

        BarIcon {
            Layout.preferredWidth: rowLayout.buttonWidth
            Layout.preferredHeight: rowLayout.buttonHeight
            source: "/images/ico_telephone.svg"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            color: {
                if (currentWidget === SideWidget.WidgetType.ActiveCall) {
                    return ThemeController.highlightColor
                }

                return ThemeController.iconColor
            }

            onTriggered: {
                root.currentWidget = SideWidget.WidgetType.ActiveCall
                widgetLoader.sourceComponent = activeCallWidgetComponent
            }
        }

        BarIcon {
            Layout.preferredWidth: rowLayout.buttonWidth
            Layout.preferredHeight: rowLayout.buttonHeight
            source: "/images/ico_navigation.svg"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            color: {
                if (currentWidget === SideWidget.WidgetType.AndroidAutoNavigation) {
                    return ThemeController.highlightColor
                }

                return ThemeController.iconColor
            }

            onTriggered: {
                root.currentWidget = SideWidget.WidgetType.AndroidAutoNavigation
                widgetLoader.sourceComponent = androidAutoNavigationWidgetComponent
            }
        }

        BarIcon {
            Layout.preferredWidth: rowLayout.buttonWidth
            Layout.preferredHeight: rowLayout.buttonHeight
            source: "/images/ico_music.svg"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            color: {
                if (currentWidget === SideWidget.WidgetType.Music) {
                    return ThemeController.highlightColor
                }

                return ThemeController.iconColor
            }

            onTriggered: {
                root.currentWidget = SideWidget.WidgetType.Music
                widgetLoader.sourceComponent = musicWidgetComponent
            }
        }

        BarIcon {
            Layout.preferredWidth: rowLayout.buttonWidth
            Layout.preferredHeight: rowLayout.buttonHeight
            source: "/images/ico_gauges.svg"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            color: {
                if (currentWidget === SideWidget.WidgetType.Gauges) {
                    return ThemeController.highlightColor
                }

                return ThemeController.iconColor
            }

            onTriggered: {
                root.currentWidget = SideWidget.WidgetType.Gauges
                widgetLoader.sourceComponent = gaugesWidgetComponent
            }
        }
    }

    Component {
        id: androidAutoNavigationWidgetComponent

        AndroidAutoNavigationWidget {
            onNavigationClicked: {
                root.navigationClicked()
            }
        }
    }

    Component {
        id: activeCallWidgetComponent

        ActiveCallWidget {
            onActiveCallClicked: {
                root.activeCallClicked()
            }
        }
    }

    Component {
        id: musicWidgetComponent

        MusicWidget {
            onMusicSourceClicked: {
                root.musicSourceClicked()
            }
        }
    }

    Component {
        id: gaugesWidgetComponent

        GaugesWidget {}
    }
}
