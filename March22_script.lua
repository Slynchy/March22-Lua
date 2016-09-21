print("Loading March22_script.lua");
-- Index for current line of script (LUA STARTS AT 1, NOT ZERO BECAUSE THAT MAKES SENSE.)
March22.CURRENTLINE = 1;

-- Label machine always starts at imachine
March22.CURRENT_LABEL = "imachine";
March22.CURRENT_LABEL_POSITION = 1;

-- Shorthand for ChangeLine(current+1)
-- Deprecated; too scared to remove it
function March22.NextLine()
  March22.ChangeLine(March22.CURRENTLINE+1);
end

-- Changes line to specified number
-- Does not check if line doesn't exist, so be careful
function March22.ChangeLine(_number)
	if March22.CURRENTLINE >= SIZE_OF_ACTIVE_SCRIPT then
		-- EOF
		March22.CURRENT_LABEL_POSITION = March22.CURRENT_LABEL_POSITION + 1;
		LABELS[March22.CURRENT_LABEL][March22.CURRENT_LABEL_POSITION]();
	else
		March22.CURRENTLINE = March22.CURRENTLINE+1;
		March22.ACTIVECHARACTER_NAME = ACTIVE_SCRIPT[March22.CURRENTLINE].speaker;
		March22.ACTIVESPEECH = ACTIVE_SCRIPT[March22.CURRENTLINE].content;
		March22.ACTIVECHARACTER_COLOR = ACTIVE_SCRIPT[March22.CURRENTLINE].color;
	
		newlabel = false;
		for k in pairs(LABEL_POSITIONS) do
			if LABEL_POSITIONS[k] == March22.CURRENTLINE then
				-- previous label has ended so terminate it
				-- March22.CURRENT_LABEL = k;
				March22.CURRENT_LABEL_POSITION = March22.CURRENT_LABEL_POSITION + 1;
				LABELS[March22.CURRENT_LABEL][March22.CURRENT_LABEL_POSITION]();
				newlabel = true;
			end
		end

		if newlabel == false then 
			ACTIVE_SCRIPT[March22.CURRENTLINE].func(); 
		end;
	end
end

-- Garbage collector for lpp-vita
-- Unloads loaded assets from (V)RAM
function March22.UnloadLoadedAssets()

	--Unload backgrounds
	for k in pairs(LOADEDBACKGROUNDS) do
		if not (k == "black") then
			if not (k == "white") then
				Graphics.freeImage(LOADEDBACKGROUNDS[k]);
				LOADEDBACKGROUNDS[k] = nil;
			end
		end
	end
	March22.ACTIVEBACKGROUND = nil;

	--Unload SFX
	for k in pairs(LOADEDSFX) do
		Sound.close(LOADEDSFX[k]);
		LOADEDSFX[k] = nil;
	end
	for k in pairs(LOADEDMUSIC) do
		Sound.close(LOADEDMUSIC[k]);
		LOADEDMUSIC[k] = nil;
	end
  
	--unload script label positions
	for k in pairs(LABEL_POSITIONS) do
		LABEL_POSITIONS[k] = nil;
	end
  
	--Unload current script
	for k in pairs(ACTIVE_SCRIPT) do
		ACTIVE_SCRIPT[k] = nil;
	end

	--Unload characters
	for k in pairs(March22.CHARACTERS) do
		for i in pairs(March22.CHARACTERS[k].sprites) do
			Graphics.freeImage(March22.CHARACTERS[k].sprites[i]);
		end
		March22.CHARACTERS[k] = nil;
	end
	March22.ClearCharacter();
	
	collectgarbage("collect")
end

-- Changes script to the specified one
-- Doesnt error check so no typos!
function March22.ChangeScript(_scriptname)
  March22.UnloadLoadedAssets();
  dofile("app0:/scripts/".._scriptname);
  March22.CURRENTLINE = 1;
  March22.ACTIVECHARACTER_NAME = ACTIVE_SCRIPT[1].speaker; 
  March22.ACTIVESPEECH = ACTIVE_SCRIPT[1].content;
  March22.ACTIVECHARACTER_COLOR = ACTIVE_SCRIPT[1].color;
  March22.ChangeLine();
end
