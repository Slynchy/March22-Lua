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
March22.version = {0, 1, 0};															-- Major, minor, patch
print("Loading March22 v"..March22.version[1]..".".. March22.version[2] ..".".. March22.version[3]);


dofile("app0:/LUA_CLASSES/Line.lua");
dofile("app0:/LUA_CLASSES/Character.lua");

dofile("app0:/scripts/script-a1-monday.lua");

--CONSTANTS
maxChar = 88; 																			-- Max number of characters to a line of text
FONTSIZE = 25;																			-- Size of text fonts
March22.TEXTBOX = Graphics.loadImage("app0:/graphics/textbox.png");						-- Textbox graphic (doesn't change so constant)
March22.FONT             = Font.load("app0:/graphics/font.ttf");						-- Same with the fonts
March22.FONT_BOLD        = Font.load("app0:/graphics/font_bold.ttf");					-- ^^^
Font.setPixelSizes(March22.FONT_BOLD,	FONTSIZE);
Font.setPixelSizes(March22.FONT		,	FONTSIZE);

March22.CHARACTERS = {};																-- Table of characters and their sprites (see Character.lua)
March22.CHARACTERS["shizune"] = Character.new("shizune", {"normal"});					-- How to initialize one called shizune with 1 emotion called normal

March22.ACTIVECHARACTER_NAME = ACTIVE_SCRIPT[1].speaker;								-- The name of the current speaker, derived from the current script line
March22.ACTIVESPEECH = ACTIVE_SCRIPT[1].content;										-- The current dialogue/narrative
March22.ACTIVECHARACTER_COLOR = ACTIVE_SCRIPT[1].color;									-- Color of character's name

March22.ACTIVEBACKGROUND = LOADEDBACKGROUNDS["op_snowywoods"];							-- The active background to draw

March22.ACTIVECHARACTERS = {															-- Table of character sprites to draw on-screen and where
	--CharacterSprite.new ( (960/2) - (295 / 2), 544 - 600, "shizune", "normal")
};

March22.ACTIVEMUSICTRACK = Sound.openOgg("app0:/sfx/music/Lullaby_of_Open_Eyes.ogg");	-- Current music track to play in the background

March22.PAD = Controls.read();															-- Variable for controller

March22.CURRENTLINE = 1;																-- Index for current line of script (LUA STARTS AT 1, NOT ZERO BECAUSE THAT MAKES SENSE.)
--[[ 
	0 = unpressed
	1 = pressed during frame, queue action
	2 = still pressed, do not act upon
--]]
March22.BUTTON_X_PRESSED = 0;
March22.BUTTON_TRIANGLE_PRESSED = 0;

-- Shorthand for ChangeLine(current+1)
function March22.NextLine()
	March22.ChangeLine(March22.CURRENTLINE+1);
end

-- Update controller and single-press variables
function March22.UpdatePad()
	March22.PAD = Controls.read();
	
	if Controls.check(March22.PAD, SCE_CTRL_CROSS) then
		if March22.BUTTON_X_PRESSED == 0 then
			March22.BUTTON_X_PRESSED = 1;
		else 
			return;
		end
	else
		March22.BUTTON_X_PRESSED = 0;
	end
	
	if Controls.check(March22.PAD, SCE_CTRL_TRIANGLE) then
		if March22.BUTTON_TRIANGLE_PRESSED == 0 then
			March22.BUTTON_TRIANGLE_PRESSED = 1;
		else 
			return;
		end
	else
		March22.BUTTON_TRIANGLE_PRESSED = 0;
	end
end

-- Changes line to specified number
-- Does not check if line doesn't exist, so be careful
function March22.ChangeLine(_number)
	March22.CURRENTLINE = _number;
	March22.ACTIVECHARACTER_NAME = ACTIVE_SCRIPT[March22.CURRENTLINE].speaker;
	March22.ACTIVESPEECH = ACTIVE_SCRIPT[March22.CURRENTLINE].content;
	March22.ACTIVECHARACTER_COLOR = ACTIVE_SCRIPT[March22.CURRENTLINE].color;
	
	ACTIVE_SCRIPT[March22.CURRENTLINE].func();
end

-- Writes wrapped text according to maxChar variable
function March22.DrawWrappedText(_font, _x, _y, _text, _color)

	local tempSize = string.len(_text);
	local numberOfLines = math.floor(tempSize / maxChar);

	local lastSpace = 0;
	local endpoint = 0;
	modifiedText = "";

	for i=0,numberOfLines,1 
	do 
		if numberOfLines == 0 then
			modifiedText = "";
			endpoint = (1 + ( maxChar * i )) + (maxChar);
			if endpoint > string.len(_text) then
				endpoint = string.len(_text);
			end
		
			modifiedText = string.sub (_text, lastSpace, endpoint);
			if (string.sub(modifiedText, 1, 1) == " ") then
				modifiedText = string.sub (modifiedText, 2, string.len(modifiedText));
			end
			Font.print(_font, _x, _y + (30 * i), modifiedText, _color);
		elseif numberOfLines == 1 then
			modifiedText = "";
			if i == 0 then
				modifiedText = string.sub (_text, 1 + ( maxChar * i ), (1 + ( maxChar * i )) + (maxChar));
				lastSpace = string.find(modifiedText, " [^ ]*$");
				modifiedText = string.sub (_text, 1, lastSpace);
				Font.print(_font, _x, _y + (30 * i), modifiedText, _color);
			elseif i == 1 then
				endpoint = (1 + ( maxChar * i )) + (maxChar);
				if endpoint > string.len(_text) then
					endpoint = string.len(_text);
				end
			
				modifiedText = string.sub (_text, lastSpace, endpoint);
				if (string.sub(modifiedText, 1, 1) == " ") then
					modifiedText = string.sub (modifiedText, 2, string.len(modifiedText));
				end
				Font.print(_font, _x, _y + (30 * i), modifiedText, _color);
			end
		elseif numberOfLines == 2 then 
			modifiedText = "";
			if i == 0 then
				modifiedText = string.sub (_text, 1 + ( maxChar * i ), (1 + ( maxChar * i )) + (maxChar));
				lastSpace = string.find(modifiedText, " [^ ]*$");
				modifiedText = string.sub (_text, 1, lastSpace);
				Font.print(_font, _x, _y + (30 * i), modifiedText, _color);
			elseif i == 1 then
				modifiedText = string.sub (_text, lastSpace, (1 + ( maxChar * i )) + (maxChar));
				local lastSpace2 = 1;
				lastSpace2 = string.find(modifiedText, " [^ ]*$");
				modifiedText = string.sub (modifiedText, 1, lastSpace2);
				lastSpace = lastSpace + lastSpace2;
				
				if (string.sub(modifiedText, 1, 1) == " ") then
					modifiedText = string.sub (modifiedText, 2, string.len(modifiedText));
				end
				Font.print(_font, _x, _y + (30 * i), modifiedText, _color);
			elseif i == 2 then
				endpoint = (1 + ( maxChar * i )) + (maxChar);
				if endpoint > string.len(_text) then
					endpoint = string.len(_text);
				end
			
				modifiedText = string.sub (_text, lastSpace, endpoint);
				if (string.sub(modifiedText, 1, 1) == " ") then
					modifiedText = string.sub (modifiedText, 2, string.len(modifiedText));
				end
				Font.print(_font, _x, _y + (30 * i), modifiedText, _color);
			end
		end
	end

end

-- Render current frame
function March22.Render()
	
	Graphics.drawImage(0, 0, March22.ACTIVEBACKGROUND);
	
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