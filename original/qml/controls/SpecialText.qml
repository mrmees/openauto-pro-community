import QtQuick 2.11
import OpenAuto 1.0
import "../../oainput/qml"

InputControl {
    property string iconPath
    property alias labelText: name.text
    property bool active: false
    property alias colorize: icon.colorize

    id: root

    hightlight: {
        if(ConfigurationController.tileStyle === TileStyle.SMALL) {
            return smallHighlightComponent
        }

        return highlightComponent
    }

    Loader {
        anchors.fill: parent
        z: -1

        sourceComponent: {
            if (ConfigurationController.tileStyle === TileStyle.BIG) {
                return bigBackgroundComponent
            } else if (ConfigurationController.tileStyle === TileStyle.SMALL) {
                return smallBackgroundComponent
            }

            return circleBackgroundComponent
        }
    }

    Item {
        anchors.fill: parent

        Icon {
            id: icon

            anchors.top: parent.top
            anchors.topMargin: {
                if (ConfigurationController.tileStyle === TileStyle.CIRCLE
                        || ConfigurationController.tileStyle === TileStyle.SMALL) {
                    return parent.height * 0.16
                }

                return parent.height * 0.18
            }
            width: parent.width * 0.33
            height: width
            anchors.horizontalCenter: parent.horizontalCenter

            fillMode: Image.PreserveAspectFit
            source: iconPath
        }

        NormalText {
            id: name
            fontPixelSize: parent.height * 0.13
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom

            anchors.left: parent.left
            anchors.leftMargin: parent.height * 0.05

            anchors.right: parent.right
            anchors.rightMargin: parent.height * 0.05

            anchors.bottom: parent.bottom
            anchors.bottomMargin: {
                if (ConfigurationController.tileStyle === TileStyle.CIRCLE
                        || ConfigurationController.tileStyle === TileStyle.SMALL) {
                    return parent.height * 0.05
                }

                return parent.height * 0.14
            }
            minimumPixelSize: parent.width * 0.1
            fontSizeMode: Text.Fit
        }
    }

    Component {
        id: bigBackgroundComponent

        Item {
            anchors.fill: parent

            ControlBackground {
                active: root.active
                activeColor: "#1e6800"
                radius: height * 0.05
            }
        }
    }

    Component {
        id: smallBackgroundComponent

        Item {
            anchors.fill: parent

            ControlBackground {
                anchors.fill: null
                active: root.active
                activeColor: "#1e6800"

                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.07
                width: parent.width * 0.55
                height: parent.height * 0.6
                anchors.horizontalCenter: parent.horizontalCenter
                radius: width * 0.05
            }
        }
    }

    Component {
        id: circleBackgroundComponent

        Item {
            anchors.fill: parent

            ControlBackground {
                anchors.fill: null
                active: root.active
                activeColor: "#1e6800"

                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.07
                width: parent.width * 0.49
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                radius: width * 0.5
            }
        }
    }

    Component {
        id: highlightComponent

        Item {
            Rectangle {
                color: "transparent"
                border.color: ThemeController.highlightColor
                border.width: height * 0.03
                anchors.fill: parent
                radius: height * 0.05
            }
        }
    }

    Component {
        id: smallHighlightComponent

        Item {
            Rectangle {
                color: "transparent"
                border.color: ThemeController.highlightColor
                border.width: height * 0.04
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.07
                width: parent.width * 0.55
                height: parent.height * 0.6
                anchors.horizontalCenter: parent.horizontalCenter
                radius: width * 0.05
            }
        }
    }
}
