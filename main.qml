import QtQuick 2.7
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.latte.components 1.0 as LatteComponents

LatteComponents.IndicatorItem {
	id: root

	needsIconColors: true
	providesFrontLayer: indicator.configuration.shapesAtForeground
	minThicknessPadding: 0.10
	minLengthPadding: 0.05

	readonly property int colorStyle: indicator.configuration.colorStyle
	readonly property int screenEdgeMargin: indicator.hasOwnProperty("screenEdgeMargin") ? indicator.screenEdgeMargin : 0

	enabledForApplets: configurationIsReady !== undefined ?
		indicator.configuration.enabledForApplets : true

	lengthPadding: configurationIsReady !== undefined ?
		indicator.configuration.lengthPadding : root.minLengthPadding

	readonly property bool configurationIsReady: indicator && indicator.configuration

	// Background
	Loader {
		id: backLayer
		anchors.fill: parent
		anchors.topMargin: plasmoid.location === PlasmaCore.Types.TopEdge ? root.screenEdgeMargin : 0
		anchors.bottomMargin: plasmoid.location === PlasmaCore.Types.BottomEdge ? root.screenEdgeMargin : 0
		anchors.leftMargin: plasmoid.location === PlasmaCore.Types.LeftEdge ? root.screenEdgeMargin : 0
		anchors.rightMargin: plasmoid.location === PlasmaCore.Types.RightEdge ? root.screenEdgeMargin : 0
		active: level.isBackground
		sourceComponent: Item {
			Loader {
				anchors.fill: parent
				active: indicator.isTask || indicator.isSquare

				sourceComponent: Item {
					id: layerItem
					anchors.fill: parent

					readonly property color backgroundColor: root.colorStyle === 0 ?
						indicator.palette.textColor : indicator.iconGlowColor
					readonly property color borderColor: backgroundColor

					Item {
						id: rectangleItem
						width: indicator.isTask || indicator.isSquare ? Math.min(parent.width, parent.height) : parent.width
						height: indicator.isTask || indicator.isSquare ? width : parent.height
						anchors.centerIn: parent

						// property bool isActive: indicator.isActive || (indicator.isWindow && indicator.hasActive)
						// readonly property int size: Math.min(parent.width, parent.height)

						Rectangle {
							id: bgRect
							anchors.fill: parent
							visible: indicator.isActive ||
								(indicator.isWindow && indicator.hasShown) ||
								(indicator.isMinimized && indicator.configuration.colorsForMinimized) ||
								(!indicator.isLauncher && indicator.configuration.colorsForSquareApplets && 
									indicator.configuration.enabledForApplets && !indicator.isTask)

							radius: indicator.currentIconSize / 6
							color: layerItem.backgroundColor
							clip: true
							opacity: {
								if (indicator.isHovered && indicator.hasActive) {
									// 100% of configuration.opacity
									return indicator.configuration.opacity;
								} else if (indicator.hasActive) {
									// 85% of configuration.opacity
									return indicator.configuration.opacity * 0.85;
								}
								// 30% of configuration.opacity
								return indicator.configuration.opacity * 0.3;
							}
						}

						Rectangle {
							id: borderRect
							anchors.fill: parent
							visible: indicator.isTask && indicator.hasMinimized &&
								indicator.configuration.bordersForMinimized

							radius: indicator.currentIconSize / 6
							color: "transparent"
							clip: true
							opacity: indicator.configuration.opacity * 0.85;
							border.width: 1
							border.color: borderColor
						}
					}
				}
			}
		}
	}

	// Shape indicators
	Loader {
		id: frontLayer
		anchors.fill: parent
		anchors.topMargin: plasmoid.location === PlasmaCore.Types.TopEdge ? root.screenEdgeMargin : 0
		anchors.bottomMargin: plasmoid.location === PlasmaCore.Types.BottomEdge ? root.screenEdgeMargin : 0
		anchors.leftMargin: plasmoid.location === PlasmaCore.Types.LeftEdge ? root.screenEdgeMargin : 0
		anchors.rightMargin: plasmoid.location === PlasmaCore.Types.RightEdge ? root.screenEdgeMargin : 0
		active: indicator.configuration.showShapeIndicator &&
			((level.isForeground && indicator.configuration.shapesAtForeground) || !indicator.configuration.shapesAtForeground)
		sourceComponent: Item {
			id: frontLayer
			anchors.fill: parent

			// Indicator Component
			Component {
				id: circleComponent
				Rectangle {
					width: indicator.currentIconSize / 12
					height: width
					radius: width / 2
					color: root.colorStyle === 0 ? indicator.palette.buttonFocusColor : indicator.iconGlowColor
					opacity: 1
				}
			}

			Row {
				id: focusIndicator
				readonly property bool alwaysActive: true
				readonly property bool reversed: true

				Repeater {
					model: (indicator.isTask && (indicator.isActive || indicator.hasActive))
						   || (indicator.isApplet && indicator.isActive && !indicator.isSquare) ? 1 : 0
					delegate: circleComponent
				}
			}

			// States
			states: [
				State {
					name: "bottom"
					when: (plasmoid.location === PlasmaCore.Types.BottomEdge && !indicator.configuration.reversed)
						|| (plasmoid.location === PlasmaCore.Types.TopEdge && indicator.configuration.reversed)

					AnchorChanges {
						target: focusIndicator
						anchors {
							top: undefined;
							bottom: parent.bottom;
							left: undefined;
							right: undefined;
							horizontalCenter: parent.horizontalCenter;
							verticalCenter:undefined
						}
					}
				},
				State {
					name: "left"
					when: (plasmoid.location === PlasmaCore.Types.LeftEdge && !indicator.configuration.reversed)
						|| (plasmoid.location === PlasmaCore.Types.RightEdge && indicator.configuration.reversed)

					AnchorChanges {
						target: focusIndicator
						anchors {
							top: undefined;
							bottom: undefined;
							left: parent.left;
							right: undefined;
							horizontalCenter: undefined;
							verticalCenter: parent.verticalCenter
						}
					}
				},
				State {
					name: "right"
					when: (plasmoid.location === PlasmaCore.Types.RightEdge && !indicator.configuration.reversed)
						|| (plasmoid.location === PlasmaCore.Types.LeftEdge && indicator.configuration.reversed)

					AnchorChanges {
						target: focusIndicator
						anchors {
							top: undefined;
							bottom: undefined;
							left: undefined;
							right: parent.right;
							horizontalCenter: undefined;
							verticalCenter: parent.verticalCenter
						}
					}
				},
				State {
					name: "top"
					when: (plasmoid.location === PlasmaCore.Types.TopEdge && !indicator.configuration.reversed)
						|| (plasmoid.location === PlasmaCore.Types.BottomEdge && indicator.configuration.reversed)

					AnchorChanges {
						target: focusIndicator
						anchors {
							top: parent.top;
							bottom: undefined;
							left: undefined;
							right: undefined;
							horizontalCenter: parent.horizontalCenter;
							verticalCenter: undefined
						}
					}
				}
			]
		}
	}
}
