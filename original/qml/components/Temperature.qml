import QtQuick 2.11
import OpenAuto 1.0

Image {
    id: root
    source: ThemeController.wallpaperPath
    visible: source !== ""
    opacity: ThemeController.wallpaperOpacity / 100
    cache: false

    function setFillMode() {
        if (ThemeController.wallpaperMode === WallpaperMode.STRETCH) {
            root.fillMode = Image.Stretch
        } else if (ThemeController.wallpaperMode === WallpaperMode.PRESERVE_ASPECT_FIT) {
            root.fillMode = Image.PreserveAspectFit
        } else if (ThemeController.wallpaperMode === WallpaperMode.PRESERVE_ASPECT_CROP) {
            root.fillMode = Image.PreserveAspectCrop
        }
    }

    Connections {
        target: ThemeController

        onWallpaperModeChanged: {
            root.setFillMode()
        }
    }

    Component.onCompleted: {
        root.setFillMode()
    }
}
