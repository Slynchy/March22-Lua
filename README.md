# March22-Lua
A port of March22 Visual Novel engine to Lua for use with lpp-vita

# How to use
Works with lpp-vita right out of the box. To use PC function, download the latest LÖVE binaries for your platform, copy the contents of PC_FILES to project root (same folder as index.lua), and run with LÖVE.

Devs should write your scripts in Ren'Py format (look at Katawa Shoujo for an example) and process with RPYtoLua (written in pure C++11; just compile Main.cpp with your preferred compiler) to produce script files. A barebones project will be available soon for kickstarting development.

#Credits
- lpp-vita by Rinnegatamante https://github.com/Rinnegatamante/lpp-vita
- LÖVE (love2d) https://love2d.org
- Four Leaf Studios http://www.katawa-shoujo.com
