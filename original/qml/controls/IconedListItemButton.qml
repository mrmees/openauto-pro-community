import QtQuick 2.11
import OpenAuto 1.0

BarIcon {
    property int mode

    id: root
    source: {
        if (root.mode === RepeatModeType.NONE) {
            return "/images/ico_repeat_inactive.svg"
        } else if (root.mode === RepeatModeType.REPEAT) {
            return "/images/ico_repeat.svg"
        } else if (root.mode === RepeatModeType.REPEAT_ONE) {
            return "/images/ico_repeat_one.svg"
        }
    }

    colorize: root.mode !== RepeatModeType.NONE
}
