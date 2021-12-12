import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.latte.components 1.0 as LatteComponents


LatteComponents.IndicatorItem {
    id: root
    needsIconColors: true
    providesFrontLayer: true
    providesHoveredAnimation: true
    providesClickedAnimation: true
    minThicknessPadding: 0.10
    minLengthPadding: 0.05
    enabledForApplets: indicator && indicator.configuration ? indicator.configuration.enabledForApplets : true

    readonly property bool progressVisible: indicator.hasOwnProperty("progressVisible") ? indicator.progressVisible : false
    readonly property bool isHorizontal: plasmoid.formFactor === PlasmaCore.Types.Horizontal
    readonly property bool isVertical: !isHorizontal
    readonly property bool isVisible: indicator.configuration.lineVisible

    readonly property int screenEdgeMargin: indicator.hasOwnProperty("screenEdgeMargin") ? indicator.screenEdgeMargin : 0
    readonly property int thickness: !isHorizontal ? width - screenEdgeMargin : height - screenEdgeMargin

    readonly property int shownWindows: indicator.windowsCount - indicator.windowsMinimizedCount
    readonly property int maxDrawnMinimizedWindows: shownWindows > 0 ? Math.min(indicator.windowsMinimizedCount,2) : 3

    readonly property int groupItemLength: indicator.currentIconSize * 0.13

    readonly property int colorStyle: indicator.configuration.colorStyle
    readonly property real backColorBrightness: colorBrightness(indicator.palette.backgroundColor)
    readonly property color activeColor: indicator.palette.buttonFocusColor
    readonly property color outlineColor: backColorBrightness < 127 ? indicator.palette.backgroundColor : indicator.palette.textColor;

    function colorBrightness(color) {
        return colorBrightnessFromRGB(color.r * 255, color.g * 255, color.b * 255);
    }

    // formula for brightness according to:
    // https://www.w3.org/TR/AERT/#color-contrast
    function colorBrightnessFromRGB(r, g, b) {
        return (r * 299 + g * 587 + b * 114) / 1000
    }

    readonly property int lineRadius: indicator.configuration.lineRadius
    readonly property int lineThickness: Math.max(indicator.currentIconSize * indicator.configuration.lineThickness, 2)
    readonly property int shrinkLengthEdge: 0.44 * parent.width
    readonly property int shrinkLengthEdgeActive: 0.36 * parent.width

    readonly property real opacityStep: {
        if (indicator.configuration.maxBackgroundOpacity >= 0.3) {
            return 0.1;
        }

        return 0.05;
    }

    readonly property real backgroundOpacity: {
        if (indicator.isHovered && indicator.hasActive || (indicator.isWindow && 
                    indicator.configuration.backgroundAlwaysActive && indicator.isHovered)) {
            return indicator.configuration.maxBackgroundOpacity;
        } else if (indicator.hasActive || (indicator.isWindow && indicator.configuration.backgroundAlwaysActive)) {
            return indicator.configuration.maxBackgroundOpacity - opacityStep;
        } else if (indicator.isHovered) {
            return indicator.configuration.maxBackgroundOpacity - 2*opacityStep;
        }

        return 0;
    }

    readonly property real bgScale: {
        if (indicator.isHovered || indicator.hasActive || (indicator.isWindow && 
                    indicator.configuration.backgroundAlwaysActive))
            return 1;

        return 0.85;
    }
    
    property real scale: {
        if (indicator.isPressed)
            return 0.8;

        return 1;
    }

    property real position: {
        if (indicator.isPressed && indicator.hasActive)
            return plasmoid.location === PlasmaCore.Types.BottomEdge ? indicator.currentIconSize/10 : -indicator.currentIconSize/10;
        else if (indicator.isPressed && indicator.isMinimized)
            return plasmoid.location === PlasmaCore.Types.BottomEdge ? -indicator.currentIconSize/10 : indicator.currentIconSize/10;

        return 0;
    }

    // Binding{
    //     target: level.requested
    //     property: "iconScale"
    //     when: level && level.requested && level.requested.hasOwnProperty("iconScale")
    //     value: scale
    // }

    // Behavior on scale {
    //     enabled: true
    //     NumberAnimation {
    //         duration: 100
    //         easing.type: Easing.OutQuad
    //     }
    // }

    // Not sure if using animations this way is super efficient, but it was the most realiable way
    // to achieve the effect I was looking for (even tho it still doesn't look amazing)

    // If someone finds the exact bezier curve that is used in Windows 11, it would be awesome to use it
    // instead of my (pretty iffy) approximation

    // Transition: clicked -> activate or minimze (depending) -> default
    NumberAnimation {
            running: indicator.isPressed
            duration: 125
            loops: Animation.Infinite
            target: level.requested
            property: "iconScale"
            to: 0.75
            easing.type: Easing.OutQuad

            onStopped: {
                anim.start()
            }
        }
    NumberAnimation {
        id: anim
        duration: 125
        target: level.requested
        property: "iconScale"
        to: 1
        easing.type: Easing.OutQuad
        onStopped: {
            pause.start()
            }
        
    }
    
    // Even though the pause is extremely short and subtle, I feel like it makes the animation look a lot better
    PauseAnimation {
        id: pause
        duration: 15
        onStopped: {
            if (indicator.isMinimized) // Would be nice to make this happen only if no window is shown
                down.start()
            else if (indicator.isActive)
                up.start()
            }
    }

    NumberAnimation {
            id: down
            duration: 215
            target: level.requested
            property: "iconOffsetY"
            to: indicator.currentIconSize/10 //Make these dependant on config and orientation
            easing.type: Easing.OutSine

            onStopped: {
                defaut.start()
            }
        }
    NumberAnimation {
        id: up
        duration: 215
        target: level.requested
        property: "iconOffsetY"
        to: -indicator.currentIconSize/10
        easing.type: Easing.OutSine
        onStopped: {
                defaut.start()
            }
    }
    
    NumberAnimation {
        id: defaut // Can't call it default or it wont work
        duration: 215
        target: level.requested
        property: "iconOffsetY"
        to: 0
        easing.type: Easing.OutBack
        easing.overshoot: 2
    }

    

    // Binding{
    //     target: level.requested
    //     property: "iconOffsetY"
    //     when: level && level.requested && level.requested.hasOwnProperty("iconOffsetY")
    //     value: position
    // }

    // Behavior on position {
    //     enabled: true
    //     SpringAnimation {
    //         duration: 350
    //         // easing.type: Easing.OutBack
    //         // alwaysRunToEnd: true
    //         spring: 3.5
    //         damping: 0.2
    //         mass: 0.2
    //     }
    // }

    Binding{
        target: root
        property: "appletLengthPadding"
        when: root.hasOwnProperty("appletLengthPadding")
        value: indicator.configuration.appletPadding
    }

    Binding{
        target: root
        property: "enabledForApplets"
        when: root.hasOwnProperty("enabledForApplets")
        value: indicator.configuration.enabledForApplets
    }

    Binding{
        target: root
        property: "lengthPadding"
        when: root.hasOwnProperty("lengthPadding")
        value: indicator.configuration.lengthPadding
    }

    //! Background Layer
    Item {
        id: floater
        anchors.fill: parent
        anchors.topMargin: plasmoid.location === PlasmaCore.Types.TopEdge ? root.screenEdgeMargin : 0
        anchors.bottomMargin: plasmoid.location === PlasmaCore.Types.BottomEdge ? root.screenEdgeMargin : 0
        anchors.leftMargin: plasmoid.location === PlasmaCore.Types.LeftEdge ? root.screenEdgeMargin : 0
        anchors.rightMargin: plasmoid.location === PlasmaCore.Types.RightEdge ? root.screenEdgeMargin : 0

        Loader{
            id: backLayer
            anchors.fill: parent
           
            // Make this configurable
            active: level.isBackground && !indicator.inRemoving

            sourceComponent: BackLayer{
                anchors.fill: parent
            }
        }

        Loader{
            id: frontLayer
            anchors.fill: parent

            active: indicator.isWindow
            
            sourceComponent: FrontLayer{
                anchors.fill: parent
                showProgress: root.progressVisible
            }
        }
    }
}
