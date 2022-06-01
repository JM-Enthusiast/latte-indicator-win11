import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

import org.kde.latte.components 1.0 as LatteComponents

ColumnLayout {
    Layout.fillWidth: true

    LatteComponents.SubHeader {
		text: i18n("Colors Style")
	}

	ColumnLayout {

		spacing: 0

		RowLayout {

			Layout.fillWidth: true
			spacing: 2

			readonly property int colorStyle: indicator.configuration.colorStyle
			readonly property int buttonCount: 2
			readonly property int buttonSize: (dialog.optionsWidth - (spacing * buttonCount - 1)) / buttonCount

			ButtonGroup {
				id: colorStyleGroup
			}

			function updateColorStyleConfig(style) {
				indicator.configuration.colorStyle = style
			}

			PlasmaComponents.Button {
				Layout.minimumWidth: parent.buttonSize
				Layout.maximumWidth: Layout.minimumWidth

				// Simple (theme.backgroundColor)
				readonly property int colorStyle: 0

				text: i18nc("Simple Colorscheme", "Simple")
				checked: parent.colorStyle === colorStyle
				checkable: false
				ToolTip.text: i18n("Use simple color for background")
				ToolTip.visible: hovered
				ToolTip.delay: 1000
				ButtonGroup.group: colorStyleGroup

				onPressedChanged: {
					if (pressed) {
						parent.updateColorStyleConfig(colorStyle)
					}
				}
			}

			PlasmaComponents.Button {
				Layout.minimumWidth: parent.buttonSize
				Layout.maximumWidth: Layout.minimumWidth

				// Colorful (icon colors)
				readonly property int colorStyle: 1

				text: i18nc("Colorful Colorscheme", "Colorful")
				checked: parent.colorStyle === colorStyle
				checkable: false
				ToolTip.text: i18n("Use icon colors for background")
				ToolTip.visible: hovered
				ToolTip.delay: 1000
				ButtonGroup.group: colorStyleGroup

				onPressedChanged: {
					if (pressed) {
						parent.updateColorStyleConfig(colorStyle)
					}
				}
			}
		}
	}

    LatteComponents.SubHeader {
        text: i18n("Background Indicator")
    }

    ColumnLayout {
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            spacing: units.smallSpacing

            PlasmaComponents.Label {
                Layout.minimumWidth: implicitWidth
                horizontalAlignment: Text.AlignLeft
                Layout.rightMargin: units.smallSpacing
                text: i18n("Max Opacity")
            }

            LatteComponents.Slider {
                id: maxOpacitySlider
                Layout.fillWidth: true

                leftPadding: 0
                value: indicator.configuration.maxBackgroundOpacity * 100
                from: 10
                to: 100
                stepSize: 1
                wheelEnabled: false

                function updateMaxOpacity() {
                    if (!pressed) {
                        indicator.configuration.maxBackgroundOpacity = value/100;
                    }
                }

                onPressedChanged: {
                    updateMaxOpacity();
                }

                Component.onCompleted: {
                    valueChanged.connect(updateMaxOpacity);
                }

                Component.onDestruction: {
                    valueChanged.disconnect(updateMaxOpacity);
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%1 %", maxOpacitySlider.value)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4
            }
        }


        LatteComponents.CheckBox {
			Layout.maximumWidth: dialog.optionsWidth
			text: i18n("Always show background for open tasks/windows")
			checked: indicator.configuration.backgroundAlwaysActive

			onClicked: {
				indicator.configuration.backgroundAlwaysActive = !indicator.configuration.backgroundAlwaysActive;
			}
		}

        }

        
        LatteComponents.SubHeader {
        text: i18n("Line Indicator")
        }

        
        ColumnLayout {
        spacing: 0

        LatteComponents.CheckBox {
			Layout.maximumWidth: dialog.optionsWidth
			text: i18n("Show line indicator")
			checked: indicator.configuration.lineVisible

			onClicked: {
				indicator.configuration.lineVisible = !indicator.configuration.lineVisible;
			}
		}

        LatteComponents.CheckBox {
			Layout.maximumWidth: dialog.optionsWidth
			text: i18n("Reverse indicator position")
			checked: indicator.configuration.reversed
			visible: indicator.configuration.lineVisible

			onClicked: {
				indicator.configuration.reversed = !indicator.configuration.reversed;
			}
		}

        RowLayout {
            Layout.fillWidth: true
            spacing: 2
            visible: indicator.configuration.lineVisible

            PlasmaComponents.Label {
                Layout.minimumWidth: implicitWidth
                horizontalAlignment: Text.AlignLeft
                Layout.rightMargin: units.smallSpacing
                text: i18n("Line Thickness")
            }

            LatteComponents.Slider {
                id: lineSlider
                Layout.fillWidth: true

                leftPadding: 0
                value: indicator.configuration.lineThickness * 100
                from: 2
                to: 20
                stepSize: 1
                wheelEnabled: false

                function updateLineThickness() {
                    if (!pressed) {
                        indicator.configuration.lineThickness = value/100;
                    }
                }

                onPressedChanged: {
                    updateLineThickness();
                }

                Component.onCompleted: {
                    valueChanged.connect(updateLineThickness);
                }

                Component.onDestruction: {
                    valueChanged.disconnect(updateLineThickness);
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%1 %", lineSlider.value)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 2
            visible: indicator.configuration.lineVisible

            LatteComponents.CheckBox {
                Layout.maximumWidth: dialog.optionsWidth
                text: i18n("Override the line indicator color")
                checked: indicator.configuration.lineColorOverride

                onClicked: {
                    indicator.configuration.lineColorOverride = !indicator.configuration.lineColorOverride
                }
		    }

            PlasmaComponents.Button {
                id: colorPickerBtn
				Layout.minimumWidth: implicitWidth
				Layout.maximumWidth: Layout.minimumWidth
                visible: indicator.configuration.lineColorOverride
				text: i18nc("Indicator Color", "Choose color")
				checked: false
				checkable: false
				ToolTip.text: i18n("Color for the line indicator")
				ToolTip.visible: hovered
				ToolTip.delay: 1000

                ColorDialog {
                    id: lineColorDialog

                    title: "Please choose a color"
                    color: indicator.configuration.lineColor
                    onAccepted: {
                        indicator.configuration.lineColor = lineColorDialog.color
                    }
                }

                onPressedChanged: {
					if (pressed) {
						lineColorDialog.open()
					}
				}
			}

            Rectangle {
                id: colorRect
                visible: indicator.configuration.lineColorOverride
                width: colorPickerBtn.width
                height: colorPickerBtn.height
                radius: 5
                color: indicator.configuration.lineColor
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 2
            visible: indicator.configuration.lineVisible

            PlasmaComponents.Label {
                Layout.minimumWidth: implicitWidth
                horizontalAlignment: Text.AlignLeft
                Layout.rightMargin: units.smallSpacing
                text: i18n("Line Radius")
            }

            LatteComponents.Slider {
                id: lineRadSlider
                Layout.fillWidth: true

                leftPadding: 0
                value: indicator.configuration.lineRadius
                from: 0
                to: 15
                stepSize: 1
                wheelEnabled: false

                function updateLineRadius() {
                    if (!pressed) {
                        indicator.configuration.lineRadius = value;
                    }
                }

                onPressedChanged: {
                    updateLineRadius();
                }

                Component.onCompleted: {
                    valueChanged.connect(updateLineRadius);
                }

                Component.onDestruction: {
                    valueChanged.disconnect(updateLineRadius);
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number with no decimals","%1", lineRadSlider.value)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4
            }
        }
    }


    LatteComponents.SubHeader {
        text: i18n("Misc Options")
    }

    RowLayout {
            Layout.fillWidth: true
            spacing: units.smallSpacing

            PlasmaComponents.Label {
                Layout.minimumWidth: implicitWidth
                horizontalAlignment: Text.AlignLeft
                Layout.rightMargin: units.smallSpacing
                text: i18n("Animation Speed")
            }

            LatteComponents.Slider {
                id: animSpeedSlider
                Layout.fillWidth: true

                leftPadding: 0
                value: indicator.configuration.animationSpeed * 100
                from: 10
                to: 200
                stepSize: 5
                wheelEnabled: false

                function updateAnimSpeed() {
                    if (!pressed) {
                        indicator.configuration.animationSpeed = value/100;
                    }
                }

                onPressedChanged: {
                    updateAnimSpeed();
                }

                Component.onCompleted: {
                    valueChanged.connect(updateAnimSpeed);
                }

                Component.onDestruction: {
                    valueChanged.disconnect(updateAnimSpeed);
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%1 %", animSpeedSlider.value)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4
            }
        }

    RowLayout {
            Layout.fillWidth: true
            spacing: units.smallSpacing
            visible: deprecatedPropertiesAreHidden

            PlasmaComponents.Label {
                text: i18n("Tasks Length")
                horizontalAlignment: Text.AlignLeft
            }

            LatteComponents.Slider {
                id: lengthIntMarginSlider
                Layout.fillWidth: true

                value: Math.round(indicator.configuration.lengthPadding * 100)
                from: 5
                to: maxMargin
                stepSize: 1
                wheelEnabled: false

                readonly property int maxMargin: 80

                onPressedChanged: {
                    if (!pressed) {
                        indicator.configuration.lengthPadding = value / 100;
                    }
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%1 %", currentValue)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4

                readonly property int currentValue: lengthIntMarginSlider.value
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 2

            PlasmaComponents.Label {
                Layout.minimumWidth: implicitWidth
                horizontalAlignment: Text.AlignLeft
                Layout.rightMargin: units.smallSpacing
                text: i18n("Applets Length")
            }

            LatteComponents.Slider {
                id: appletPaddingSlider
                Layout.fillWidth: true

                leftPadding: 0
                value: indicator.configuration.appletPadding * 100
                from: 0
                to: 80
                stepSize: 5
                wheelEnabled: false

                function updateMargin() {
                    if (!pressed) {
                        indicator.configuration.appletPadding = value/100;
                    }
                }

                onPressedChanged: {
                    updateMargin();
                }

                Component.onCompleted: {
                    valueChanged.connect(updateMargin);
                }

                Component.onDestruction: {
                    valueChanged.disconnect(updateMargin);
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%1 %", appletPaddingSlider.value)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4
            }
        }

    LatteComponents.CheckBoxesColumn {
        Layout.fillWidth: true

        LatteComponents.CheckBox {
            Layout.maximumWidth: dialog.optionsWidth
            text: i18n("Progress animation in background")
            checked: indicator.configuration.progressAnimationEnabled

            onClicked: {
                indicator.configuration.progressAnimationEnabled = !indicator.configuration.progressAnimationEnabled
            }
        }
    }

    LatteComponents.CheckBox {
        Layout.maximumWidth: dialog.optionsWidth
        text: i18n("Show indicators for applets")
        checked: indicator.configuration.enabledForApplets
        tooltip: i18n("Indicators are shown for applets")
        visible: deprecatedPropertiesAreHidden

        onClicked: {
            indicator.configuration.enabledForApplets = !indicator.configuration.enabledForApplets;
        }
    }
}
