
-- Load the main menu background for use in loading screens/mainmenu
MAINMENUBACKGROUND = Graphics.loadImage("app0:/graphics/mainmenu/main.png");
-- Plus the loading bar
LOADINGBAR = Graphics.loadImage("app0:/graphics/mainmenu/loadingbar.png");

-- Draws a loading screen with the specified progress
-- Parameter is generated automatically by RPYtoLua scripts
function UpdateLoadingProgress(_progress)
	Graphics.initBlend();
	Screen.clear();
	local widthpercent = (_progress / 100);
	widthpercent = 594 * widthpercent;
	Graphics.drawImage(0, 0, MAINMENUBACKGROUND);
	Graphics.fillRect(181, 181 + widthpercent, 438, 462, Color.new(255,255,255));
	Graphics.drawImage(178, 432, LOADINGBAR);  
	Graphics.termBlend();
	Screen.flip()
end

-- Set the CPU speed to 333 because we don't need 444
System.setCpuSpeed(333);

-- Load up March22 (and execute main menu)
dofile("app0:/March22.lua")

-- Main menu has ended so start setting up the main game loop
LABELS["imachine"][1]();

-- Main loop
while true do
	
	-- Blend some images with different funcs (normal, rotated, scaled)
	Graphics.initBlend();
	Screen.clear();
	March22.Render();
	Graphics.termBlend();
	
	-- Update input
	March22.UpdatePad();
	if March22.DRAW_TEXTBOX == true then
		if March22.BUTTON_X_PRESSED == 1 then
			if March22.TypeWriterLineComplete then
				March22.ChangeLine(March22.CURRENTLINE + 1);
				March22.TypeWriterFrame = 0;
			else
				March22.TypeWriterFrame = 420;
			end
		end
	end
	if (Controls.check(March22.PAD, SCE_CTRL_RTRIGGER)) and (March22.DRAW_TEXTBOX == true) then
		March22.ChangeLine(March22.CURRENTLINE + 1);
		March22.TypeWriterFrame = 0;
	end
	if March22.BUTTON_TRIANGLE_PRESSED == 1 then
		--System.exit()
		jump_out ("A3");
		--March22.SaveGame();
	end
	if March22.BUTTON_SQUARE_PRESSED == 1 then
		March22.SaveGame();
	end
	if March22.BUTTON_START_PRESSED == 1 then
		March22.LoadGame();
	end
	
	-- Flip framebuffer
	Screen.flip()
	
	if March22.BUTTON_X_PRESSED == 1 then
		March22.BUTTON_X_PRESSED = 2;
	end
	if March22.BUTTON_TRIANGLE_PRESSED == 1 then
		March22.BUTTON_TRIANGLE_PRESSED = 2;
	end
	if March22.BUTTON_START_PRESSED == 1 then
		March22.BUTTON_START_PRESSED = 2;
	end
	
	Screen.waitVblankStart();
end
