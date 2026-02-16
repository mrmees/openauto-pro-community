import QtQuick 2.5
import OpenAuto 1.0
import "../"

ApplicationBase {
    signal retranslate

    id: root
    rootComponent: settingsMenuComponent

    enum BrowsingType {
        DayWallpaper,
        NightWallpaper,
        Ringtone,
        SplashAudio,
        PhoneNotification
    }

    enum ColorType {
        BackgroundColor,
        HighlightColor,
        ControlBackgroundColor,
        ControlForegroundColor,
        NormalFontColor,
        SpecialFontColor,
        DescriptionFontColor,
        BarBackgroundColor,
        ControlBoxBackgroundColor,
        GaugeIndicatorColor,
        IconColor,
        SideWidgetBackgroundColor,
        BarShadowColor
    }

    Component {
        id: browseStorageMenuComponent

        BrowseStorageMenu {
            id: browseStorageMenu
            onFileSelected: {
                if (browsingId === SettingsApplication.BrowsingType.DayWallpaper) {
                    ConfigurationController.dayWallpaperPath = "file://" + path
                } else if (browsingId === SettingsApplication.BrowsingType.NightWallpaper) {
                    ConfigurationController.nightWallpaperPath = "file://" + path
                } else if (browsingId === SettingsApplication.BrowsingType.Ringtone) {
                    ConfigurationController.ringtoneFilePath = "file://" + path
                } else if (browsingId === SettingsApplication.BrowsingType.SplashAudio) {
                    ConfigurationController.audioSplashFilePath = "file://" + path
                } else if (browsingId === SettingsApplication.BrowsingType.PhoneNotification) {
                    ConfigurationController.phoneNotificationFilePath = "file://" + path
                }

                applicationsStack.pop()
            }
        }
    }

    Component {
        id: settingsMenuComponent

        SettingsMenu {
            onAndroidAutoSettingsClicked: {
                applicationsStack.push(androidAutoSettingsMenuComponent)
            }

            onSystemSettingsClicked: {
                applicationsStack.push(systemSettingsMenuComponent)
            }

            onAudioSettingsClicked: {
                applicationsStack.push(audioSettingsMenuComponent)
            }

            onAppearanceSettingsClicked: {
                applicationsStack.push(appearanceSettingsMenuComponent)
            }

            onMirroringSettingsClicked: {
                applicationsStack.push(mirroringSettingsMenuComponent)
            }

            onDayNightSettingsClicked: {
                applicationsStack.push(dayNightSettingsMenuComponent)
            }

            onWallpaperSettingsClicked: {
                applicationsStack.push(wallpaperSettingsMenuComponent)
            }

            onRearCameraSettingsClicked: {
                applicationsStack.push(rearCameraSettingsMenuComponent)
            }

            onWirelessSettingsClicked: {
                applicationsStack.push(wirelessSettingsMenuComponent)
            }

            onVolumeSettingsClicked: {
                applicationsStack.push(volumeSettingsMenuComponent)
            }

            onLanguageSettingsClicked: {
                applicationsStack.push(languageSettingsMenuComponent)
            }

            onGestureSettingsClicked: {
                applicationsStack.push(gestureSettingsMenuComponent)
            }

            onColorSettingsClicked: {
                applicationsStack.push(colorSettingsMenuComponent)
            }

            onAutoboxSettingsClicked: {
                applicationsStack.push(autoboxSettingsMenuComponent)
            }

            onVersionClicked: {
                applicationsStack.push(versionMenuComponent)
            }
        }
    }

    Component {
        id: audioSettingsMenuComponent

        AudioSettingsMenu {
            property var filterExtensions: [".mp3", ".wav", ".wma"]
            property var fileIcon: "/images/ico_music_library.svg"

            onBrowseForRingtoneClicked: {
                applicationsStack.push(browseStorageMenuComponent, {
                                           "filterExtensions": filterExtensions,
                                           "browsingId": SettingsApplication.BrowsingType.Ringtone,
                                           "fileIcon": fileIcon
                                       })
            }

            onBrowseForSplashAudioClicked: {
                applicationsStack.push(browseStorageMenuComponent, {
                                           "filterExtensions": filterExtensions,
                                           "browsingId": SettingsApplication.BrowsingType.SplashAudio,
                                           "fileIcon": fileIcon
                                       })
            }

            onBrowseForPhoneNotificationClicked: {
                applicationsStack.push(browseStorageMenuComponent, {
                                           "filterExtensions": filterExtensions,
                                           "browsingId": SettingsApplication.BrowsingType.PhoneNotification,
                                           "fileIcon": fileIcon
                                       })
            }
        }
    }

    Component {
        id: systemSettingsMenuComponent

        SystemSettingsMenu {}
    }

    Component {
        id: appearanceSettingsMenuComponent

        AppearanceSettingsMenu {
            onMoreClicked: {
                applicationsStack.push(appearanceSettings2MenuComponent)
            }
        }
    }

    Component {
        id: appearanceSettings2MenuComponent

        AppearanceSettings2Menu {}
    }

    Component {
        id: mirroringSettingsMenuComponent

        MirroringSettingsMenu {}
    }

    Component {
        id: dayNightSettingsMenuComponent

        DayNightSettingsMenu {}
    }

    Component {
        id: wallpaperSettingsMenuComponent

        WallpaperSettingsMenu {
            property var filterExtensions: [".jpg", ".jpeg", ".bmp", ".png", ".svg"]
            property var fileIcon: "/images/ico_image_file.svg"

            onBrowseForDayWallpaperClicked: {
                applicationsStack.push(browseStorageMenuComponent, {
                                           "filterExtensions": filterExtensions,
                                           "browsingId": SettingsApplication.BrowsingType.DayWallpaper,
                                           "fileIcon": fileIcon
                                       })
            }

            onBrowseForNightWallpaperClicked: {
                applicationsStack.push(browseStorageMenuComponent, {
                                           "filterExtensions": filterExtensions,
                                           "browsingId": SettingsApplication.BrowsingType.NightWallpaper,
                                           "fileIcon": fileIcon
                                       })
            }
        }
    }

    Component {
        id: rearCameraSettingsMenuComponent

        RearCameraSettingsMenu {}
    }

    Component {
        id: wirelessSettingsMenuComponent

        WirelessSettingsMenu {}
    }

    Component {
        id: versionMenuComponent

        VersionMenu {}
    }

    Component {
        id: androidAutoSettingsMenuComponent

        AndroidAutoSettingsMenu {
            onVideoSettingsClicked: {
                applicationsStack.push(androidAutoVideoSettingsMenuComponent)
            }

            onBluetoothSettingsClicked: {
                applicationsStack.push(
                            androidAutoBluetoothSettingsMenuComponent)
            }

            onSystemSettingsClicked: {
                applicationsStack.push(androidAutoSystemSettingsMenuComponent)
            }

            onAudioSettingsClicked: {
                applicationsStack.push(androidAutoAudioSettingsMenuComponent)
            }
        }
    }

    Component {
        id: androidAutoAudioSettingsMenuComponent

        AndroidAutoAudioSettingsMenu {}
    }

    Component {
        id: androidAutoBluetoothSettingsMenuComponent

        AndroidAutoBluetoothSettingsMenu {}
    }

    Component {
        id: androidAutoVideoSettingsMenuComponent

        AndroidAutoVideoSettingsMenu {}
    }

    Component {
        id: androidAutoSystemSettingsMenuComponent

        AndroidAutoSystemSettingsMenu {}
    }

    Component {
        id: languageSettingsMenuComponent

        LanguageSettingsMenu {
            onSelected: {
                root.retranslate()
            }
        }
    }

    Component {
        id: colorSettingsMenuComponent

        ColorSettingsMenu {
            onBackgroundColorClicked: {
                applicationsStack.push(colorChoosingMenuComponent, {
                                           "colorId": SettingsApplication.ColorType.BackgroundColor,
                                           "defaultColor": ThemeController.defaultBackgroundColor,
                                           "startColor": ThemeController.backgroundColor
                                       })
            }

            onHighlightColorClicked: {
                applicationsStack.push(colorChoosingMenuComponent, {
                                           "colorId": SettingsApplication.ColorType.HighlightColor,
                                           "defaultColor": ThemeController.defaultHighlightColor,
                                           "startColor": ThemeController.highlightColor
                                       })
            }

            onControlBackgroundColorClicked: {
                applicationsStack.push(colorChoosingMenuComponent, {
                                           "colorId": SettingsApplication.ColorType.ControlBackgroundColor,
                                           "defaultColor": ThemeController.defaultControlBackgroundColor,
                                           "startColor": ThemeController.controlBackgroundColor
                                       })
            }

            onControlForegroundColorClicked: {
                applicationsStack.push(colorChoosingMenuComponent, {
                                           "colorId": SettingsApplication.ColorType.ControlForegroundColor,
                                           "defaultColor": ThemeController.defaultControlForegroundColor,
                                           "startColor": ThemeController.controlForegroundColor
                                       })
            }

            onNormalFontColorClicked: {
                applicationsStack.push(colorChoosingMenuComponent, {
                                           "colorId": SettingsApplication.ColorType.NormalFontColor,
                                           "defaultColor": ThemeController.defaultNormalFontColor,
                                           "startColor": ThemeController.normalFontColor
                                       })
            }

            onSpecialFontColorClicked: {
                applicationsStack.push(colorChoosingMenuComponent, {
                                           "colorId": SettingsApplication.ColorType.SpecialFontColor,
                                           "defaultColor": ThemeController.defaultSpecialFontColor,
                                           "startColor": ThemeController.specialFontColor
                                       })
            }

            onDescriptionFontColorClicked: {
                applicationsStack.push(colorChoosingMenuComponent, {
                                           "colorId": SettingsApplication.ColorType.DescriptionFontColor,
                                           "defaultColor": ThemeController.defaultDescriptionFontColor,
                                           "startColor": ThemeController.descriptionFontColor
                                       })
            }

            onBarBackgroundColorClicked: {
                applicationsStack.push(colorChoosingMenuComponent, {
                                           "colorId": SettingsApplication.ColorType.BarBackgroundColor,
                                           "defaultColor": ThemeController.defaultBarBackgroundColor,
                                           "startColor": ThemeController.barBackgroundColor
                                       })
            }

            onControlBoxBackgroundColorClicked: {
                applicationsStack.push(colorChoosingMenuComponent, {
                                           "colorId": SettingsApplication.ColorType.ControlBoxBackgroundColor,
                                           "defaultColor": ThemeController.defaultControlBoxBackgroundColor,
                                           "startColor": ThemeController.controlBoxBackgroundColor
                                       })
            }

            onGaugeIndicatorColorClicked: {
                applicationsStack.push(colorChoosingMenuComponent, {
                                           "colorId": SettingsApplication.ColorType.GaugeIndicatorColor,
                                           "defaultColor": ThemeController.defaultGaugeIndicatorColor,
                                           "startColor": ThemeController.gaugeIndicatorColor
                                       })
            }

            onIconColorClicked: {
                applicationsStack.push(colorChoosingMenuComponent, {
                                           "colorId": SettingsApplication.ColorType.IconColor,
                                           "defaultColor": ThemeController.defaultIconColor,
                                           "startColor": ThemeController.iconColor
                                       })
            }

            onSideWidgetBackgroundColorClicked: {
                applicationsStack.push(colorChoosingMenuComponent, {
                                           "colorId": SettingsApplication.ColorType.SideWidgetBackgroundColor,
                                           "defaultColor": ThemeController.defaultSideWidgetBackgroundColor,
                                           "startColor": ThemeController.sideWidgetBackgroundColor
                                       })
            }

            onBarShadowColorClicked: {
                applicationsStack.push(colorChoosingMenuComponent, {
                                           "colorId": SettingsApplication.ColorType.BarShadowColor,
                                           "defaultColor": ThemeController.defaultBarShadowColor,
                                           "startColor": ThemeController.barShadowColor
                                       })
            }
        }
    }

    Component {
        id: gestureSettingsMenuComponent

        GestureSettingsMenu {
            onManageGesturesClicked: {
                applicationsStack.push(manageGesturesSettingsMenuComponent)
            }
        }
    }

    Component {
        id: volumeSettingsMenuComponent

        VolumeSettingsMenu {}
    }

    Component {
        id: colorChoosingMenuComponent

        ColorChoosingMenu {
            onSaveClicked: {
                if (colorId === SettingsApplication.ColorType.BackgroundColor) {
                    ThemeController.backgroundColor = value
                } else if (colorId === SettingsApplication.ColorType.HighlightColor) {
                    ThemeController.highlightColor = value
                } else if (colorId === SettingsApplication.ColorType.ControlBackgroundColor) {
                    ThemeController.controlBackgroundColor = value
                } else if (colorId === SettingsApplication.ColorType.ControlForegroundColor) {
                    ThemeController.controlForegroundColor = value
                } else if (colorId === SettingsApplication.ColorType.NormalFontColor) {
                    ThemeController.normalFontColor = value
                } else if (colorId === SettingsApplication.ColorType.SpecialFontColor) {
                    ThemeController.specialFontColor = value
                } else if (colorId === SettingsApplication.ColorType.DescriptionFontColor) {
                    ThemeController.descriptionFontColor = value
                } else if (colorId === SettingsApplication.ColorType.BarBackgroundColor) {
                    ThemeController.barBackgroundColor = value
                } else if (colorId === SettingsApplication.ColorType.ControlBoxBackgroundColor) {
                    ThemeController.controlBoxBackgroundColor = value
                } else if (colorId === SettingsApplication.ColorType.GaugeIndicatorColor) {
                    ThemeController.gaugeIndicatorColor = value
                } else if (colorId === SettingsApplication.ColorType.IconColor) {
                    ThemeController.iconColor = value
                } else if (colorId === SettingsApplication.ColorType.SideWidgetBackgroundColor) {
                    ThemeController.sideWidgetBackgroundColor = value
                } else if (colorId === SettingsApplication.ColorType.BarShadowColor) {
                    ThemeController.barShadowColor = value
                }

                applicationsStack.pop()
            }

            onCancelClicked: {
                applicationsStack.pop()
            }
        }
    }

    Component {
        id: autoboxSettingsMenuComponent

        AutoboxSettingsMenu {}
    }

    Component {
        id: manageGesturesSettingsMenuComponent

        ManageGesturesSettingsMenu {}
    }

    function activate() {
        applicationsStack.replace(null, rootComponent)
    }
}
