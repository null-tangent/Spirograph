# Spirograph

Inspired by a recent [video](https://www.youtube.com/watch?v=AY99hF3kVH8) from [OneLoneCoder](https://github.com/OneLoneCoder/) aka [Javidx9](https://www.youtube.com/c/javidx9) on youtube. Draw and save spirographs on the computer using processing.

## Getting started

Run through the processing4 ide.

The interface is very sparse but all keys are listed in the top info text.

![Screenshot](Screenshot.png?raw=true)

- (u/i) increases/decreases the fixed gear size
- (j/k) increases/decreases the moving gear size
- (n/m) increases/decreases the pen offset
- (,/.) advances/retards the moving gear's phase
- (left/right) rotates the spirograph without drawing
- (p) toggles rainbow colors
- ([/]) changes the color hue
- (r) returns the spirograph to angle 0
- (SPACE) draws advancing the spirograph counter clockwise
- (c) clears the draw buffer
- (s) saves the draw buffer

The draw buffer's background is transparent. I've made the choice of limiting save files to png only. If your output file's name has no extension or a different extension, ".png" will be appended to the end of the filename.

![Sample render](Sample.png?raw=true)

## Unintended consequences

Most adjustments keybinds are directly tied to the framerate, which can make precise adjustments very difficult. No other input method is implemented.

Due to the way the lines are drawn, they look wobbly and jittery, I cannot smooth them without major changes.

## Acknowledgments

The idea and the math behind this program are entirely OneLoneCoder's work all the way down to the algorithm and procedural nature of the way the program is written.

This package redistributes [Hack font](https://github.com/source-foundry/Hack)

**Hack** work is &copy; 2018 Source Foundry Authors. MIT License