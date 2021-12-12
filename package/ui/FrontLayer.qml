import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: lineIndicator
    property bool showProgress: false
    property int lineMargin: indicator.currentIconSize * 0.2
    readonly property bool isOnTop: (plasmoid.location === PlasmaCore.Types.TopEdge && !indicator.configuration.reversed)
						    || (plasmoid.location === PlasmaCore.Types.BottomEdge && indicator.configuration.reversed)
    
    Rectangle {
            id: activeLine
            anchors.topMargin: isOnTop ? lineMargin : 0
            anchors.bottomMargin: !isOnTop ? lineMargin : 0
            radius: lineRadius
            width: {
                if (indicator.hasActive) {
                    return parent.width - (2 * shrinkLengthEdgeActive);
                }

                return parent.width - (2 * shrinkLengthEdge);
            }

            height: root.lineThickness

            color: !indicator.hasActive ? "#9a9a9a" : root.activeColor

            // Latte needed to be restarted to see any changes if root.isVisible was in the visible property
            // The opacity property doesn't have that problem
            opacity: root.isVisible ? 1 : 0
            visible: !indicator.isApplet && (rectangleItem.isActive || indicator.isWindow)

            // Change either the speed or the easing type to more closely match the Win11 line
            Behavior on width {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutCirc
                }
            }
        }
    
    // Making the progress bar a "state" of the active line might be a better idea 
    // to avoid some little visual glitches and could look better with a morphing animation between
    // the states but this should work well enough and I don't yet feel compelled to change it
    Loader {
        id: progressBar
        asynchronous: true
        anchors.topMargin: isOnTop ? lineMargin : 0
        anchors.bottomMargin: !isOnTop ? lineMargin : 0
        active: indicator.configuration.progressAnimationEnabled && lineIndicator.showProgress && indicator.progress > 0
        width: lineIndicator.width * 0.45
        height: activeLine.height
        sourceComponent: Item{
            Item{
                id: progressFrame
                anchors.fill: parent
                Rectangle {
                    width: parent.width * (Math.min(indicator.progress, 100) / 100)
                    height: activeLine.height
                    color: activeLine.color
                }

                visible: false
            }

            Item {
                id: progressMask
                anchors.fill: parent

                Rectangle {
                    anchors.fill: parent
                    radius: activeLine.radius
                    color: "red"
                }
                visible: false
            }

            Rectangle {
                anchors.fill: parent
                radius: activeLine.radius
                color: root.outlineColor
                clip: true
                OpacityMask {
                    anchors.fill: parent
                    source: progressFrame
                    maskSource: progressMask
                }
            }
        }
    }

    // States
    // Keeping the states this way in case/until proper side edges support is added
    states: [
        State {
            name: "bottom"
            when: (plasmoid.location === PlasmaCore.Types.BottomEdge && !indicator.configuration.reversed)
                || (plasmoid.location === PlasmaCore.Types.TopEdge && indicator.configuration.reversed)

            AnchorChanges {
                target: activeLine
                anchors {
                    top: undefined;
                    bottom: parent.bottom;
                    horizontalCenter: parent.horizontalCenter;
                }
            }
            AnchorChanges {
                target: progressBar
                anchors {
                    top: undefined;
                    bottom: parent.bottom;
                    horizontalCenter: parent.horizontalCenter;
                }
            }
        },
        State {
            name: "left"
            when: (plasmoid.location === PlasmaCore.Types.LeftEdge && !indicator.configuration.reversed)
                || (plasmoid.location === PlasmaCore.Types.RightEdge && indicator.configuration.reversed)

            AnchorChanges {
                target: activeLine
                anchors {
                    top: undefined;
                    bottom: parent.bottom;
                    horizontalCenter: parent.horizontalCenter;
                }
            }
            AnchorChanges {
                target: progressBar
                anchors {
                    top: undefined;
                    bottom: parent.bottom;
                    horizontalCenter: parent.horizontalCenter;
                }
            }
        },
        State {
            name: "right"
            when: (plasmoid.location === PlasmaCore.Types.RightEdge && !indicator.configuration.reversed)
                || (plasmoid.location === PlasmaCore.Types.LeftEdge && indicator.configuration.reversed)

            AnchorChanges {
                target: activeLine
                anchors {
                    top: undefined;
                    bottom: parent.bottom;
                    horizontalCenter: parent.horizontalCenter;
                }
            }
            AnchorChanges {
                target: progressBar
                anchors {
                    top: undefined;
                    bottom: parent.bottom;
                    horizontalCenter: parent.horizontalCenter;
                }
            }
        },
        State {
            name: "top"
            when: (plasmoid.location === PlasmaCore.Types.TopEdge && !indicator.configuration.reversed)
                || (plasmoid.location === PlasmaCore.Types.BottomEdge && indicator.configuration.reversed)

            AnchorChanges {
                target: activeLine
                anchors {
                    top: parent.top;
                    bottom: undefined;
                    horizontalCenter: parent.horizontalCenter;
                }
            }
            AnchorChanges {
                target: progressBar
                anchors {
                    top: parent.top;
                    bottom: undefined;
                    horizontalCenter: parent.horizontalCenter;
                }
            }
        }
    ]
}