MAINMENUBACKGROUND = Graphics.loadImage("app0:/graphics/mainmenu/main.png");
LOADINGBAR = Graphics.loadImage("app0:/graphics/mainmenu/loadingbar.png");
--Graphics.freeImage(MAINMENUBACKGROUND);
--MAINMENUBACKGROUND = nil;

function UpdateLoadingProgress(_progress)
  local LOADING_PROGRESS = _progress;
  Graphics.initBlend();
  Screen.clear();
  -- 181 to 775
  -- 775 - 181 = 594
  local widthpercent = (_progress / 100);
  widthpercent = 594 * widthpercent;
  Graphics.drawImage(0, 0, MAINMENUBACKGROUND);
  Graphics.fillRect(181, 181 + widthpercent, 438, 462, Color.new(255,255,255));
  Graphics.drawImage(178, 432, LOADINGBAR);
  
  --Graphics.debugPrint(960/2, 540/2, ""..LOADING_PROGRESS.."%",  Color.new(255,0,0));
  
  Graphics.termBlend();
  Screen.flip()
end

System.setCpuSpeed(333);

dofile("app0:/March22.lua")

deltaTime = 0;
timeSinceStart = 0;
oldTimeSinceStart = 0;
timer=Timer.new();
--March22.CURRENTLINE = (500 - 100);
--March22.CURRENTLINE = 1;
--March22.NextLine();
LABELS["imachine"][1]();
-- Main loop
while true do
	
	-- Blend some images with different funcs (normal, rotated, scaled)
	Graphics.initBlend();
	Screen.clear();
	March22.Render();
	
	--[[timeSinceStart = Timer.getTime(timer);
	deltaTime = timeSinceStart - oldTimeSinceStart;
	oldTimeSinceStart = timeSinceStart;
	Graphics.debugPrint(5, 5,(1000/deltaTime).."ms",  Color.new(255,0,0),1);--]]
	
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
	
	-- Flip screen
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