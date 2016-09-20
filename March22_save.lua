-- Table of scenes that the player has seen in the playthrough
-- i.e. SeenScenes[_scriptlabel] == true if the player has seen the specified one.
-- Should use seen_scene() though.
March22.SeenScenes = {};

if IS_ON_PC == nil then

	-- Writes a lua file in a folder in ux0:/data that inits data for savegames
	March22.SaveGame = function()
		if not (System.doesFileExist("ux0:/data/KatawaShoujo/SaveData.lua")) then
			System.createDirectory("ux0:/data/KatawaShoujo");
		else
			System.deleteFile("ux0:/data/KatawaShoujo/SaveData.lua");
		end
		handle = io.open("ux0:/data/KatawaShoujo/SaveData.lua", FCREATE);
		
		--the code for loading the correct script file, also shows load screen
		content = "dofile(\"app0:/scripts/"..March22.CURRENTSCRIPTNAME.."\");\n";
		io.write(handle, content, string.len(content))
		
		--background
		content = "ChangeBackground(\""..March22.ACTIVEBACKGROUND_NAME.."\");\n";
		io.write(handle, content, string.len(content))
		
		content = "March22.CURRENTLINE = "..March22.CURRENTLINE..";\n";
		io.write(handle, content, string.len(content))
		content = "March22.ACTIVECHARACTER_NAME = \""..March22.ACTIVECHARACTER_NAME.."\";\n";
		io.write(handle, content, string.len(content))
		content = "March22.ACTIVESPEECH = \""..March22.ACTIVESPEECH.."\";\n\n";
		io.write(handle, content, string.len(content))
		
		red = Color.getR(March22.ACTIVECHARACTER_COLOR);
		blue = Color.getB(March22.ACTIVECHARACTER_COLOR);
		green = Color.getG(March22.ACTIVECHARACTER_COLOR);
		content = "March22.ACTIVECHARACTER_COLOR = Color.new("..red..", "..green..", "..blue.. ");\n\n";
		io.write(handle, content, string.len(content))
		
		--March22.AddCharacterToActive(_x, _charname, _emotion, _anim, _animfunc, _speed)
		--iterate through March22.ACTIVECHARACTERS and record them using the above function
		for k in pairs(March22.ACTIVECHARACTERS) do
			content = "table.insert(March22.ACTIVECHARACTERS, CharacterSprite.new ( "..March22.ACTIVECHARACTERS[k].x..", "..March22.ACTIVECHARACTERS[k].y..", \""..March22.ACTIVECHARACTERS[k].name.."\", \""..March22.ACTIVECHARACTERS[k].emotion.."\"));\n\n"
			io.write(handle, content, string.len(content))
		end
		
		for k in pairs(March22.SeenScenes) do
			content = "March22.SeenScenes[\""..k.."\"] = ";--..March22.SeenScenes[k].."\n";
			if March22.SeenScenes[k] == true then
				content = content.."true;\n";
			else
				content = content.."false;\n";
			end
			io.write(handle, content, string.len(content))
		end
		
		io.close(handle)
	end
	
	-- Simple; just unloads loaded assets and executes the save file
	-- If it exists
	March22.LoadGame = function()
		-- check file exists
		if System.doesFileExist("ux0:/data/KatawaShoujo/SaveData.lua") then
			March22.UnloadLoadedAssets();
			dofile("ux0:/data/KatawaShoujo/SaveData.lua");
		end
	end
else
	March22.SaveGame = function()
		love.filesystem.remove("./SaveData.lua");
		
		--the code for loading the correct script file, also shows load screen
		content = "require(\"scripts/"..string.sub(March22.CURRENTSCRIPTNAME, 0, -5).."\");\n";
		
		--background
		content = content.."ChangeBackground(\""..March22.ACTIVEBACKGROUND_NAME.."\");\n";
		
		content = content.."March22.CURRENTLINE = "..March22.CURRENTLINE..";\n";
		content = content.."March22.ACTIVECHARACTER_NAME = \""..March22.ACTIVECHARACTER_NAME.."\";\n";
		if March22.ACTIVECHARACTER_NAME == "" then
			content = content.."March22.ACTIVESPEECH = \""..March22.ACTIVESPEECH.."\";\n\n";
		else
			content = content.."March22.ACTIVESPEECH = "..March22.ACTIVESPEECH..";\n\n";
		end
		
		red = March22.ACTIVECHARACTER_COLOR.r;
		blue = March22.ACTIVECHARACTER_COLOR.b;
		green = March22.ACTIVECHARACTER_COLOR.g;
		content = content.."March22.ACTIVECHARACTER_COLOR = Color.new("..red..", "..green..", "..blue.. ");\n\n";
		
		for k in pairs(March22.ACTIVECHARACTERS) do
			content = content.."table.insert(March22.ACTIVECHARACTERS, CharacterSprite.new ( "..March22.ACTIVECHARACTERS[k].x..", "..March22.ACTIVECHARACTERS[k].y..", \""..March22.ACTIVECHARACTERS[k].name.."\", \""..March22.ACTIVECHARACTERS[k].emotion.."\"));\n\n"
		end
		
		for k in pairs(March22.SeenScenes) do
			content = content.."March22.SeenScenes[\""..k.."\"] = ";--..March22.SeenScenes[k].."\n";
			if March22.SeenScenes[k] == true then
				content = content.."true;\n";
			else
				content = content.."false;\n";
			end
		end
		print(content);
		love.filesystem.write("SaveData.lua", content, string.len(content))
	end
	March22.LoadGame = function()
		if System.doesFileExist("SaveData.lua") then
			March22.UnloadLoadedAssets();
			require("SaveData");
		end
	end
end

