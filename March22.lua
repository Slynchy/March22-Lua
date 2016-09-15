--[[
	March22-Lua
		Coded in Lua to be used by lpp-vita
		Code covered by MIT licensing
	By Sam 'Slynch' Lynch
	
	Katawa Shoujo is property of 4Leaf Studios and covered by CC3.0
	lpp-vita is an open-source project by rinnegatamante
--]]

--Namespace
March22 = {};
March22.version = {0, 6, 3};															-- Major, minor, patch
print("Loading March22 v"..March22.version[1]..".".. March22.version[2] ..".".. March22.version[3]);

--CONSTANTS
maxChar = 88;                                       -- Max number of characters to a line of text
FONTSIZE = 25;                                      -- Size of text fonts
March22.TEXTBOX = Graphics.loadImage("app0:/graphics/textbox.png");           -- Textbox graphic (doesn't change so constant)
March22.TEXTBOX_NARRATIVE = Graphics.loadImage("app0:/graphics/textbox_narrative.png");           -- Textbox graphic (doesn't change so constant)

March22.CIRCLE_BUTTON_GRAPHIC = Graphics.loadImage("app0:/graphics/circle_icon.png");
March22.TRIANGLE_BUTTON_GRAPHIC = Graphics.loadImage("app0:/graphics/triangle_icon.png");
March22.SQUARE_BUTTON_GRAPHIC = Graphics.loadImage("app0:/graphics/square_icon.png");

LOADEDBACKGROUNDS = {};
LOADEDBACKGROUNDS["black"] = Graphics.loadImage("app0:/graphics/black.jpg");
LOADEDBACKGROUNDS["white"] = Graphics.loadImage("app0:/graphics/white.jpg");

March22.FONT             = Font.load("app0:/graphics/font.ttf");            -- Same with the fonts
March22.FONT_BOLD        = Font.load("app0:/graphics/font_bold.ttf");         -- ^^^ unused at the moment tho
Font.setPixelSizes(March22.FONT_BOLD, FONTSIZE);
Font.setPixelSizes(March22.FONT   , FONTSIZE);
March22.WHITE_COLOUR = Color.new(255,255,255);
March22.DRAW_TEXTBOX = true;

-- Main menu first
dofile("app0:/March22_save.lua");
dofile("app0:/March22_sound.lua");
dofile("app0:/March22_controls.lua");
dofile("app0:/March22_mainmenu.lua");

dofile("app0:/LUA_CLASSES/Line.lua");
dofile("app0:/LUA_CLASSES/Character.lua");
dofile("app0:/LUA_CLASSES/Decision.lua");
dofile("app0:/March22_character.lua");
dofile("app0:/March22_labels.lua");
dofile("app0:/scripts/script-a1-monday.rpy.lua");
--dofile("app0:/scripts/testAnim.lua");

March22.ACTIVECHARACTER_NAME = ACTIVE_SCRIPT[1].speaker;                -- The name of the current speaker, derived from the current script line
March22.ACTIVESPEECH = ACTIVE_SCRIPT[1].content;                    -- The current dialogue/narrative
March22.ACTIVECHARACTER_COLOR = ACTIVE_SCRIPT[1].color;                 -- Color of character's name

--LOADEDSFX and LOADEDBACKGROUNDS now usable
dofile("app0:/March22_background.lua");
dofile("app0:/March22_script.lua");
dofile("app0:/March22_font.lua");
--March22.ACTIVEBACKGROUND = LOADEDBACKGROUNDS["op_snowywoods"];
-- Render current frame
function March22.Render()
	
  if March22.ACTIVEBACKGROUND == nil then
    --do nothing
  else
    Graphics.drawImage(0, 0, March22.ACTIVEBACKGROUND);
  end
  
	
	for k in pairs(March22.ACTIVECHARACTERS) do
		March22.ACTIVECHARACTERS[k].Update();
			Graphics.drawImage(
				March22.ACTIVECHARACTERS[k].x,
				March22.ACTIVECHARACTERS[k].y,
				March22.CHARACTERS[March22.ACTIVECHARACTERS[k].name].sprites[March22.ACTIVECHARACTERS[k].emotion],
		  March22.ACTIVECHARACTERS[k].color
			);
	end
	
	if March22.DRAW_TEXTBOX == true then
		if March22.ACTIVECHARACTER_NAME == "" then
			Graphics.drawImage(0, 0, March22.TEXTBOX_NARRATIVE);
		else
			Graphics.drawImage(0, 0, March22.TEXTBOX);
		end
		Font.print(March22.FONT_BOLD, 18, 370, March22.ACTIVECHARACTER_NAME, March22.ACTIVECHARACTER_COLOR);
		March22.DrawTypeWriterEffect(March22.FONT, 42, 424, March22.ACTIVESPEECH, Color.new(255, 255, 255))
	end
	
end