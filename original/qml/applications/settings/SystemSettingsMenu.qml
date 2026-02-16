import QtQuick 2.11
import OpenAuto 1.0
import QtQuick.Layouts 1.11
import "../../controls"
import "../../components"

SettingsApplicationMenu {
    signal browseForDayWallpaperClicked
    signal browseForNightWallpaperClicked

    id: root
    title: qsTr("Wallpaper settings")

    Item {
        property real parameterBoxSize: height * 0.14

        id: container

        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.02
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.02
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.bottom: parent.bottom

        ColumnLayout {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Day wallpaper opacity")

                from: 0
                to: 100
                value: ConfigurationController.dayWallpaperOpacity

                onPositionChanged: {
                    ConfigurationController.dayWallpaperOpacity = valueAt(
                                position)
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Day wallpaper mode")
                buttonLabels: [qsTr("Stretch"), qsTr("Fit"), qsTr("Crop")]
                buttonValues: [ConfigurationController.dayWallpaperMode
                    === WallpaperMode.STRETCH, ConfigurationController.dayWallpaperMode
                    === WallpaperMode.PRESERVE_ASPECT_FIT, ConfigurationController.dayWallpaperMode
                    === WallpaperMode.PRESERVE_ASPECT_CROP]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.dayWallpaperMode = WallpaperMode.STRETCH
                    } else if (index === 1) {
                        ConfigurationController.dayWallpaperMode = WallpaperMode.PRESERVE_ASPECT_FIT
                    } else if (index === 2) {
                        ConfigurationController.dayWallpaperMode
                                = WallpaperMode.PRESERVE_ASPECT_CROP
                    }
                }
            }

            FileSetting {
                id: dayWallpaperFileSetting
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                pathLabelText: ConfigurationController.dayWallpaperPath
                labelText: qsTr("Day wallpaper")

                onBrowseClicked: {
                    root.browseForDayWallpaperClicked()
                }

                onResetClicked: {
                    ConfigurationController.dayWallpaperPath = ""
                }
            }

            LabeledSlider {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Night wallpaper opacity")

                from: 0
                to: 100
                value: ConfigurationController.nightWallpaperOpacity

                onPositionChanged: {
                    ConfigurationController.nightWallpaperOpacity = valueAt(
                                position)
                }
            }

            RadioButtonsGroup {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Night wallpaper mode")
                buttonLabels: [qsTr("Stretch"), qsTr("Fit"), qsTr("Crop")]
                buttonValues: [ConfigurationController.nightWallpaperMode
                    === WallpaperMode.STRETCH, ConfigurationController.nightWallpaperMode
                    === WallpaperMode.PRESERVE_ASPECT_FIT, ConfigurationController.nightWallpaperMode
                    === WallpaperMode.PRESERVE_ASPECT_CROP]

                onButtonValueChanged: {
                    if (index === 0) {
                        ConfigurationController.nightWallpaperMode = WallpaperMode.STRETCH
                    } else if (index === 1) {
                        ConfigurationController.nightWallpaperMode
                                = WallpaperMode.PRESERVE_ASPECT_FIT
                    } else if (index === 2) {
                        ConfigurationController.nightWallpaperMode
                                = WallpaperMode.PRESERVE_ASPECT_CROP
                    }
                }
            }

            FileSetting {
                id: nightWallpaperFileSetting
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: container.parameterBoxSize
                labelText: qsTr("Night wallpaper")
                pathLabelText: ConfigurationController.nightWallpaperPath

                onBrowseClicked: {
                    root.browseForNightWallpaperClicked()
                }

                onResetClicked: {
                    ConfigurationController.nightWallpaperPath = ""
                }
            }
        }
    }
}
