import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item{
    width: root.groupItemLength + 2 //layerWidth
    height: parent.height
    clip: true

    BackLayer{
        anchors.right: parent.right
        anchors.top: parent.top

        width: 4*parent.width
        height: parent.height
    }
}