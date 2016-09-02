--[[
	March22-Lua
		Coded in Lua to be used by lpp-vita
		Code covered by MIT licensing
	By Sam 'Slynch' Lynch
	
	Katawa Shoujo is property of 4Leaf Studios
	lpp-vita is an open-source project by rinnegatamante
--]]

--Namespace
March22 = {};
March22.version = {0, 3, 0};															-- Major, minor, patch
print("Loading March22 v"..March22.version[1]..".".. March22.version[2] ..".".. March22.version[3]);

--CONSTANTS
maxChar = 88;                                       -- Max number of characters to a line of text
FONTSIZE = 25;                                      -- Size of text fonts
March22.TEXTBOX = Graphics.loadImage("app0:/graphics/textbox.png");           -- Textbox graphic (doesn't change so constant)
March22.FONT             = Font.load("app0:/graphics/font.ttf");            -- Same with the fonts
March22.FONT_BOLD        = Font.load("app0:/graphics/font_bold.ttf");         -- ^^^
Font.setPixelSizes(March22.FONT_BOLD, FONTSIZE);
Font.setPixelSizes(March22.FONT   , FONTSIZE);
March22.WHITE_COLOUR = Color.new(255,255,255);

dofile("app0:/LUA_CLASSES/Line.lua");
dofile("app0:/LUA_CLASSES/Character.lua");
LOADEDBACKGROUNDS = {};
dofile("app0:/scripts/script-a1-monday.lua");
--LOADEDSFX and LOADEDBACKGROUNDS now usable
dofile("app0:/March22_character.lua");
dofile("app0:/March22_sound.lua");
dofile("app0:/March22_background.lua");
dofile("app0:/March22_script.lua");
dofile("app0:/March22_controls.lua");
dofile("app0:/March22_font.lua");
March22.ACTIVEBACKGROUND = LOADEDBACKGROUNDS["op_snowywoods"];
-- Render current frame
function March22.Render()
	
  if March22.ACTIVEBACKGROUND == nil then
    --do nothing
  else
    Graphics.drawImage(0, 0, March22.ACTIVEBACKGROUND);
  end
	
	for k in pairs(March22.ACTIVECHARACTERS) do
		Graphics.drawImage(
			March22.ACTIVECHARACTERS[k].x,
			March22.ACTIVECHARACTERS[k].y,
			March22.CHARACTERS[March22.ACTIVECHARACTERS[k].name].sprites[March22.ACTIVECHARACTERS[k].emotion]
		);
	end
	
	Graphics.drawImage(0, 0, March22.TEXTBOX);
	Font.print(March22.FONT_BOLD, 18, 370, March22.ACTIVECHARACTER_NAME, March22.ACTIVECHARACTER_COLOR);
	March22.DrawWrappedText(March22.FONT, 42, 424, March22.ACTIVESPEECH, Color.new(255, 255, 255))
	
end