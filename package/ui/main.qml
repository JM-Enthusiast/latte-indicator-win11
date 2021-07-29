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
    
    // IF shrinking/scaling the icon ever becomes supported, make a sequential animation with shrink then position
    property real position: {
        if (indicator.isPressed && indicator.hasActive)
            return plasmoid.location === PlasmaCore.Types.BottomEdge ? indicator.currentIconSize/10 : -indicator.currentIconSize/10;
        else if (indicator.isPressed && indicator.isMinimized)
            return plasmoid.location === PlasmaCore.Types.BottomEdge ? -indicator.currentIconSize/10 : indicator.currentIconSize/10;

        return 0;
    }

    Binding{
        target: level.requested
        property: "iconOffsetY"
        when: level && level.requested && level.requested.hasOwnProperty("iconOffsetY")
        value: position
    }

    Behavior on position {
        enabled: true
        NumberAnimation {
            duration: 350
            easing.type: Easing.OutBack
        }
    }

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