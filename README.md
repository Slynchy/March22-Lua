# March22-Lua
A port of March22 Interactive Novel engine to Lua for use with the LÖVE framework.

# How to use
Works with LÖVE out of the box. Clone the repo and drag the folder onto the love2D executable.

If you are porting: process the scripts with RPYtoLua (uses <codecvt> so doesn't compile on Linux). Doesn't like indentation. 

If you are developing: write your scripts in the [March22 format](https://raw.githubusercontent.com/Slynchy/March22/master/scripts/START_SCRIPT.txt) and refer to [documentation](https://github.com/Slynchy/March22/blob/master/m22_DESIGN_DOCUMENT.md). Compile using M22toLua.

If you want Visual Novel or PSVita support, clone the appropriate branch.

#Credits
- LÖVE (love2d) https://love2d.org
- Ren'Py https://github.com/renpy/renpy
- lpp-vita by Rinnegatamante https://github.com/Rinnegatamante/lpp-vita