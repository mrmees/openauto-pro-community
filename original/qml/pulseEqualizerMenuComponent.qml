import QtQuick 2.11
import "../"

ApplicationBase {
    rootComponent: ladspaEqualizerMenuComponent

    Component {
        id: pulseEqualizerMenuComponent

        PulseEqualizerMenu {}
    }

    Component {
        id: ladspaEqualizerMenuComponent

        LadspaEqualizerMenu {}
    }

    function activate() {
        applicationsStack.replace(rootComponent)
    }
}
