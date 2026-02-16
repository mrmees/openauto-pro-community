import QtQuick 2.11
import "../controls"

Item {
    property alias titleText: titleLabel.scrollableText
    property alias font: titleLabel.font
    property alias fontPixelSize: titleLabel.fontPixelSize

    id: root
    width: titleLabel.width

    SpecialText {
        id: titleLabel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.weight: Font.Normal
    }
}
