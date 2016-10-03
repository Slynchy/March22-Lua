#March22-Lua Changelog
##NOTE: I hardly ever remember what I add per version, so it may be inaccurate

#### v0.6.7
- Fixed bug/typo with active music in savegame
- Long-text support from RPYtoLua

#### v0.6.6
- Added active music to savegame
- Multiple script support
	* Checks if iscene exists in current script; if not, loads necessary script then jumps to it
	* Seems to work on PC, don't know about PSVita yet
	* Needs more assets to really test, though
- Updated RPYtoLua
	* Outputs .lua files instead of .rpy.lua files (because it breaks the crap out of love2d)
- Working on an automated installer script so as to not violate Katawa Shoujo's license (see installer folder)

#### v0.6.5
- Wrapper for LÖVE
	* Means can dev on PC/Mac/Linux without a PSVita
	* Still needs PSVita for debugging console-specific stuff though
- Added explicit garbage collection in hopes it fixes running out of RAM
- Fixed savegames only working when saved during narrative
- Todo:
	* Add active music to savegame
	* Test multiple script deployment
	* Music file streaming from storage as opposed to preloading
	* Update RPYtoLua to remove .rpy from end of script name so it doesn't end up as "file.rpy.lua"
		+ Breaks love2d for some reason

#### v0.6.3
- Decision trees
	* Handled by imachine.lua
	* Scripts call "MakeDecision()" with the appropriate parameters
	* This function hijacks the framebuffer to draw the decisions onscreen.
- Saving/loading
	* Works well enough for one load, but fails at line 172 (one of the music tracks) for the script
	* Probably a RAM issue; some sounds not getting freed properly?
	* Should try and stream from storage instead of preloading.
- New RPYtoLua specifically for compiling imachine.lua

#### v0.5.0
- Fixed every bug listed on the first binary release
	* Refer to that buglist; it pretty much is the changelog for this version

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