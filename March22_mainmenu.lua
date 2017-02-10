
-- Init/load main menu music
MAINMENUMUSIC = Sound.openOgg("app0:/music/music_menus.ogg");
-- And play it
Sound.play(MAINMENUMUSIC, LOOP);

-- The alpha value of the fadein animation; should be a float, really
ALPHA_VAL = 0;

isInMainMenu = true;

-- dont erase main menu graphic since its used for load screens



