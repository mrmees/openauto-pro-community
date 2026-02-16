import QtQuick 2.11
import OpenAuto 1.0
import "../"

ApplicationBase {
    signal telephoneClicked
    signal androidAutoClicked
    signal applicationsClicked
    signal musicClicked
    signal mirroringClicked
    signal settingsClicked
    signal rearCameraClicked
    signal dashboardsClicked
    signal equalizerClicked
    signal autoboxClicked

    id: root
    rootComponent: homeMenuComponent

    Component {
        id: homeMenuComponent

        HomeMenu {
            onTelephoneClicked: {
                root.telephoneClicked()
            }

            onAndroidAutoClicked: {
                root.androidAutoClicked()
            }

            onApplicationsClicked: {
                root.applicationsClicked()
            }

            onMusicClicked: {
                root.musicClicked()
            }

            onMirroringClicked: {
                root.mirroringClicked()
            }

            onSettingsClicked: {
                root.settingsClicked()
            }

            onRearCameraClicked: {
                root.rearCameraClicked()
            }

            onDashboardsClicked: {
                root.dashboardsClicked()
            }

            onEqualizerClicked: {
                root.equalizerClicked()
            }

            onAutoboxClicked: {
                root.autoboxClicked()
            }
        }
    }

    function activate() {
        applicationsStack.replace(null, rootComponent)
    }
}
