# Latte Win11 Indicator
A Win11 style indicator for [Latte Dock](https://phabricator.kde.org/source/latte-dock/repository/master/).

<p align="center">
<img src="./assets/win11-indicator-default.png" width="560" ><br/>
<i>Default indicator settings</i>
</p>

https://user-images.githubusercontent.com/23425754/127577075-54592108-3755-4393-b1bd-199e42202dd5.mp4
<p align="center">
<i>Hover/unhover animations</i>
</p>

https://user-images.githubusercontent.com/23425754/127576985-a07c7ca6-6270-4de2-b268-20e56bc89131.mp4
<p align="center">
<i>Minimize/bring to front animations</i>
</p>

<p align="center">
<img src="./assets/win11-indicator-settings.png" width="560" ><br/>
<i>Indicator settings</i>
</p>

# Requires

- Latte >= v0.10.0
- Latte >= v0.10.4 (for animations)

# Install

From Latte UI: **Effects -> Indicators -> Style -> Get New Indicators...**
<br>From command line: ``kpackagetool5 -i . -t Latte/Indicator``

# Update

From Latte UI: **Effects -> Indicators -> Style -> Get New Indicators... -> Installed**
<br>From command line: ``kpackagetool5 -u . -t Latte/Indicator``

# Credits

This indicator theme is based on [latte-indicator-win10](https://github.com/psifidotos/latte-indicator-win10) by [psifidotos](https://github.com/psifidotos) and [latte-indicator-glorious](https://github.com/manilarome/latte-indicator-glorious) by [manilarome](https://github.com/manilarome).

# Missing features/issues
- The line indicator and the progress bar don't work very well for right and left panels
- There is currently no grouped tasks indicator

I have only tested this indicator with 50px absolute icon size, 10% margin length and 30% margin thickness (Latte Dock settings), so please let me know if there are any issues with settings you use (I'll try my best to fix it but no promises)
