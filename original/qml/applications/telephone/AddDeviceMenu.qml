import QtQuick 2.11
import QtQuick.Layouts 1.11
import OpenAuto 1.0
import "../../controls"
import "../../components"
import "../"

TelephoneApplicationMenu {
    property string contactName: VoiceCallController.contactName
    property string contactNumber: VoiceCallController.contactNumber
    property int callState: VoiceCallController.callState
    signal hangUpClicked
    signal answerClicked
    property bool showKeyboard: false

    id: root
    title: qsTr("Active call")
    objectName: "ActiveCallMenu"

    onShowKeyboardChanged: {
        stackView.replace(
                    null,
                    showKeyboard ? keyboardComponent : activeCallDetailsComponent)
    }

    CustomStackView {
        id: stackView
        anchors.fill: parent
        initialItem: activeCallDetailsComponent
        onCurrentItemChanged: {
            root.highlightDefaultControl()
        }
    }

    Component {
        id: activeCallDetailsComponent

        Item {
            Item {
                width: parent.width * 0.8
                height: parent.height * 0.5
                anchors.centerIn: parent

                ControlBackground {
                    radius: height * 0.05
                }

                Icon {
                    id: activeCallIcon
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.03
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.25
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: anchors.topMargin
                    width: height
                    source: root.callState === CallState.ACTIVE ? "/images/ico_activecall_ongoing.svg" : "/images/ico_activecall.svg"
                    colorize: root.callState !== CallState.ACTIVE
                }

                RowLayout {
                    id: detailsContainer
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.05
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: anchors.topMargin
                    anchors.right: parent.right
                    anchors.rightMargin: parent.height * 0.35
                    anchors.left: activeCallIcon.right
                    anchors.leftMargin: parent.width * 0.025

                    ColumnLayout {
                        Layout.preferredHeight: detailsContainer.height * 0.85
                        Layout.preferredWidth: parent.width
                        Layout.alignment: Qt.AlignVCenter
                        spacing: parent.height * 0.075

                        NormalText {
                            scrollableText: contactName
                            elide: Text.ElideRight
                            fontPixelSize: detailsContainer.height * 0.14
                            horizontalAlignment: Text.AlignHCenter
                            Layout.preferredWidth: parent.width
                        }

                        DescriptionText {
                            scrollableText: contactNumber
                            fontPixelSize: detailsContainer.height * 0.11
                            elide: Text.ElideRight
                            Layout.preferredWidth: parent.width
                            horizontalAlignment: Text.AlignHCenter
                        }

                        RowLayout {
                            Layout.preferredHeight: detailsContainer.height * 0.4
                            Layout.preferredWidth: parent.width
                            Layout.alignment: Qt.AlignHCenter

                            BarIcon {
                                Layout.preferredHeight: detailsContainer.height * 0.3
                                Layout.preferredWidth: visible ? detailsContainer.height * 0.3 : 0
                                visible: root.callState === CallState.ACTIVE
                                Layout.alignment: Qt.AlignHCenter
                                source: "/images/ico_dialpad.svg"
                                onTriggered: {
                                    root.showKeyboard = true
                                }
                            }

                            BarIcon {
                                Layout.preferredHeight: detailsContainer.height * 0.3
                                Layout.preferredWidth: visible ? detailsContainer.height * 0.3 : 0
                                visible: root.callState === CallState.INCOMING
                                Layout.alignment: Qt.AlignHCenter
                                source: "/images/ico_answercall.svg"
                                colorize: false
                                onTriggered: {
                                    answerClicked()
                                }
                            }

                            BarIcon {
                                Layout.preferredHeight: detailsContainer.height * 0.3
                                Layout.preferredWidth: detailsContainer.height * 0.3
                                Layout.alignment: Qt.AlignHCenter
                                source: "/images/ico_hangcall.svg"
                                colorize: false
                                onTriggered: {
                                    hangUpClicked()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: keyboardComponent

        Item {
            CustomKeyboard {
                mode: KeyboardMode.DIALPAD
                height: parent.height * 0.75
                width: parent.width * 0.6
                anchors.centerIn: parent
                delimiter: "+"
                okButtonLabel: qsTr("Hide")
                onOkClicked: {
                    root.showKeyboard = false
                }

                onButtonClicked: {
                    if (code !== delimiter
                            && VoiceCallController.callState === CallState.ACTIVE) {
                        VoiceCallController.sendTone(code)
                    }
                }
            }
        }
    }
}
