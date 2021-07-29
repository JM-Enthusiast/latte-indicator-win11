/*
How the Win11 Indicator (the background part) seems to work
[Hover]
Outline/Border rect appears first
Inside/Filled rect appears very shortly afterwards
[Unhover]
Outline/Border rect disappears first
Inside/Filled rect shrinks to about 85-90% of its size while becoming invisible

I am unable to find a satisfying way to achieve the exact same effect
so my approximation will have to do for now
*/

import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item{
    id: rectangleItem

    property bool isActive: indicator.isActive || (indicator.isWindow && indicator.hasActive)
    
    anchors.centerIn: parent

    Rectangle {
        id: mainRect
        width: indicator.isTask || indicator.isSquare ? Math.min(parent.width, parent.height) : parent.width
        height: indicator.isTask || indicator.isSquare ? width : parent.height
        anchors.centerIn: parent
        radius: backRect.radius
        color: root.colorStyle === 0 ? Qt.lighter(indicator.palette.backgroundColor, 3) : indicator.iconGlowColor

        visible: opacity > 0
        opacity: root.backgroundOpacity
        scale: root.bgScale

        Behavior on scale {
            enabled: true
            NumberAnimation {
                duration: 120 * indicator.durationTime / indicator.configuration.animationSpeed
                easing.type: Easing.OutBack
            }
        }

        Behavior on opacity {
            enabled: true
            NumberAnimation {
                duration: 80 * indicator.durationTime / indicator.configuration.animationSpeed
                easing.type: Easing.OutCirc
            }
        }
    }
    
    // This makes a very subtle outline that adds a lot of character 
    Rectangle {
        id: backRect
        width: mainRect.width
        height: mainRect.height
        anchors.centerIn: parent
        radius: indicator.currentIconSize / 6
        color: "transparent"
        visible: mainRect.visible
        clip: true
        opacity: mainRect.opacity * 0.70
        border.width: 1
        border.color: mainRect.color
    }
}
