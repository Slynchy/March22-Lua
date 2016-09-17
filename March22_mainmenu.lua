
-- Init/load main menu music
MAINMENUMUSIC = Sound.openOgg("app0:/music/music_menus.ogg");
-- And play it
Sound.play(MAINMENUMUSIC, LOOP);

-- The alpha value of the fadein animation; should be a float, really
ALPHA_VAL = 0;

EXIT = false;
while EXIT == false do
	
	Graphics.initBlend();
	Screen.clear();
	Graphics.fillRect(0, 0, 960, 544, Color.new(255,255,255));
	
	--Draw main menu
	if ALPHA_VAL >= 255 then
		ALPHA_VAL = 255;
	else
		ALPHA_VAL = ALPHA_VAL + 1;
	end
	Graphics.drawImage(0, 0, MAINMENUBACKGROUND, Color.new(255,255,255,ALPHA_VAL));
	Font.print(March22.FONT_BOLD, 300, 380, "PRESS START TO BEGIN", Color.new(255,0,0,ALPHA_VAL));
	Graphics.termBlend();
	
	-- Update input
	March22.UpdatePad();
	if March22.BUTTON_X_PRESSED == 1 or March22.BUTTON_START_PRESSED == 1 then
		if ALPHA_VAL > 125 then
			EXIT = true;
		end
	end
	if March22.BUTTON_TRIANGLE_PRESSED == 1 then
		System.exit()
	end
	
	-- Flip screen
	Screen.flip()
	
	if March22.BUTTON_X_PRESSED == 1 then
		March22.BUTTON_X_PRESSED = 2;
	end
	if March22.BUTTON_TRIANGLE_PRESSED == 1 then
		March22.BUTTON_TRIANGLE_PRESSED = 2;
	end
	
	Screen.waitVblankStart();
end

-- Garbage cleanup
Sound.pause(MAINMENUMUSIC);
Sound.close(MAINMENUMUSIC);
MAINMENUMUSIC = nil;
-- dont erase main menu graphic since its used for load screens



