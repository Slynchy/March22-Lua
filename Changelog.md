#March22-Lua Changelog
##NOTE: I hardly ever remember what I add per version, so it may be inaccurate

#### v0.4.0
- Added fadein/out for drawcharacter and clearcharacter
- Added typewriter effect
	* Breaks unicode characters
- Improved stability of RPYtoLua when it comes to animations

#### v0.3.5
- Added per-script loading of character sprites to RPYtoLua
	* And subsequent drawing/clearing to March22-Lua
	* Garbage cleanup was already in place? Need to verify.
- Improved new-script loading to be more stable
- Probably some other stuff; I forget

#### v0.3.0
- Added ability to load new scripts
- Improved RPYtoLua stability
- Added garbage cleanup to loading new script (unloads graphics/sounds from [V]RAM)
- Added function to add characters to screen
	* Uses "twoleft", "offscreenleft" and "center" for positioning
	* This needs to be added to RPYtoLua though
	* Also needs animation

#### v0.2.0
- Improved script loading
- Added a loading bar function
- RPYtoLua
	* C++ program that converts RPY script to March22-Lua-compliant Lua script.
	* Currently only converts dialogue and sound/background changes, with no transition.
	* Requires setup to charnames and charnames_fixed, similar to RPY-eBook.
- Other stuff I probably forgot.

#### v0.1.0
- Initial commit