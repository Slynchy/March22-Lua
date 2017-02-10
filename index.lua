-- Load the main menu background for use in loading screens/mainmenu
MAINMENUBACKGROUND = Graphics.loadImage("app0:/graphics/mainmenu/main.png");
MAINMENU_LOGO = Graphics.loadImage("app0:/graphics/mainmenu/logo.png");
-- Plus the loading bar
LOADINGBAR = Graphics.loadImage("app0:/graphics/mainmenu/loadingbar.png");

-- Draws a loading screen with the specified progress
-- Parameter is generated automatically by RPYtoLua scripts
isLoading = false;
GLOBAL_LOADING_PROGRESS = 0;
function UpdateLoadingProgress(_progress)
	isLoading = true;
	GLOBAL_LOADING_PROGRESS = _progress
	if _progress == 100 then
		isLoading = false
	end
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
--LABELS["imachine"][1]();

March22.CURRENTLINE = 0;

function countNewLines(_text)
	local length = string.len(_text);
	
	local counter = 0;
	for i = 1,length do
		if string.sub(_text, i, i) == '\n' then
			counter = counter + 1;
		end
	end
	
	return counter;
end

rotationValue = 0;

-- Main loop
if IS_ON_PC == nil then
	
else
	function love.update(dt)
		-- Update input
		March22.UpdatePad();
		if (Controls.check(March22.PAD, SCE_CTRL_RTRIGGER)) and (March22.DRAW_TEXTBOX == true) then
			--March22.ChangeLine(March22.CURRENTLINE + 1);
			--March22.TypeWriterFrame = 0;
			--print("skip");
			
			System.exit()
		end
		
		if isInMainMenu then
			if March22.BUTTON_X_PRESSED == 1 or March22.BUTTON_START_PRESSED == 1 then
				--if ALPHA_VAL > 125 then
					dofile("app0:/scripts/M22_TEST.lua");
					LABELS["imachine"][1]();
					isInMainMenu = false;
					March22.currentPage = ""..March22.ACTIVESPEECH.."";
					Sound.pause(MAINMENUMUSIC);
					Sound.close(MAINMENUMUSIC);
					MAINMENUMUSIC = nil;
				--end
			end
			if March22.BUTTON_TRIANGLE_PRESSED == 1 then
				System.exit()
			end
		else
			if March22.BUTTON_TRIANGLE_PRESSED == 1 then
				--System.exit()
				jump_out ("A5");
				--March22.SaveGame();
			end
			if March22.DRAW_TEXTBOX == true then
				if March22.BUTTON_X_PRESSED == 1 then
					if March22.TypeWriterLineComplete then
						March22.ChangeLine(March22.CURRENTLINE + 1);
						if countNewLines(March22.currentPage) >= 14 then 
							March22.currentPage = "" 
							March22.currentPageTypewriter = "";
							March22.TypeWriterFrame = 0
							March22.currentPage = ""..March22.ACTIVESPEECH.."";
							doNewLine = true;
						else
							if doNewLine == true then
								March22.currentPage = ""..March22.currentPage.."\n\n"..March22.ACTIVESPEECH.."";
							else
								March22.currentPage = ""..March22.currentPage..""..March22.ACTIVESPEECH.."";
								doNewLine = true;
							end
						end
						collectgarbage();
					else
						March22.currentPageTypewriter = March22.currentPage;
						March22.TypeWriterLineComplete = true;
						March22.TypeWriterFrame = string.len(March22.currentPageTypewriter);
					end
				end
			end
			if March22.BUTTON_SQUARE_PRESSED == 1 then
				print("saving\n");
				March22.SaveGame();
			end
			if March22.BUTTON_START_PRESSED == 1 then
				print("loading\n");
				March22.LoadGame();
			end
		end
		
		if March22.BUTTON_X_PRESSED == 1 then
			March22.BUTTON_X_PRESSED = 2;
		end
		if March22.BUTTON_TRIANGLE_PRESSED == 1 then
			March22.BUTTON_TRIANGLE_PRESSED = 2;
		end
		if March22.BUTTON_SQUARE_PRESSED == 1 then
			March22.BUTTON_SQUARE_PRESSED = 2;
		end
		if March22.BUTTON_START_PRESSED == 1 then
			March22.BUTTON_START_PRESSED = 2;
		end
	end
	
	function love.draw()
	
		Graphics.initBlend();
		Screen.clear();
		if not isInMainMenu then
			if isLoading then
				
			else
				love.graphics.push();
				love.graphics.scale( love.graphics.getWidth( ) / 960, love.graphics.getHeight( ) / 544 );
				March22.Render();
				love.graphics.pop();
			end
		else
			love.graphics.push();
			love.graphics.scale( love.graphics.getWidth( ) / 1920, love.graphics.getHeight( ) / 1080 );
			Graphics.fillRect(0, 0, 960, 544, Color.new(255,255,255));
			--Draw main menu
			if ALPHA_VAL >= 255 then
				ALPHA_VAL = 255;
			else
				ALPHA_VAL = ALPHA_VAL + 0.3;
			end
			--Graphics.drawImage(0, 0, MAINMENUBACKGROUND, Color.new(255,255,255,ALPHA_VAL));
			
			rotationValue = rotationValue + 0.0001;
			
			Graphics.drawRotateImage(960 / 2, 544 / 2, MAINMENUBACKGROUND, rotationValue, Color.new(255,255,255,ALPHA_VAL), 2150 / 2, 1344 / 2);
			Graphics.drawImage(0, 0, MAINMENU_LOGO, Color.new(255,255,255,ALPHA_VAL));
			--Font.print(March22.FONT_BOLD, 300, 380, "PRESS START TO BEGIN", Color.new(255,0,0,ALPHA_VAL));
			love.graphics.pop();
		end
		Graphics.termBlend();
	end
end