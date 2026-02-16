import QtQuick 2.11
import OpenAuto 1.0

BarIcon {
    property bool active

    id: root
    source: root.active ? "/images/ico_shuffle.svg" : "/images/ico_shuffle_inactive.svg"
    colorize: root.active
}
