
-- Init the loaded characters table
March22.CHARACTERS = {};

-- Table of character sprites to draw on-screen and where
March22.ACTIVECHARACTERS = {                              
 
};

-- Removes the specifed character from the active array    
 -- _name = name of character
function March22.ClearCharacter(_name)
  if _name == nil then    
    for k in pairs(March22.ACTIVECHARACTERS) do
        March22.ACTIVECHARACTERS[k] = nil;
    end
  else
    for k in pairs(March22.ACTIVECHARACTERS) do
        if March22.ACTIVECHARACTERS[k].name == _name then
          March22.ACTIVECHARACTERS[k].destroy = true;
          break;
        end
    end
  end
end

-- Adds the specified character name and emotion at the specified position
-- Params:
   -- _x = position (center, offscreenleft, twoleft)
   -- _charname = characters name in March22.CHARACTERS
   -- _emotion = emotion of character from March22.CHARACTERS
function March22.AddCharacterToActive(_x, _charname, _emotion, _anim, _animfunc, _speed)
	return;
    --[[local y = Graphics.getImageHeight(March22.CHARACTERS[_charname].sprites[_emotion]);
    y = 544 - y;
    
    local x = Graphics.getImageWidth(March22.CHARACTERS[_charname].sprites[_emotion]);
    
    if _x == "center" then
        x = ((960 / 2) - (x / 2));
    elseif _x == "offscreenleft" then
        x = 0 - x;
    elseif _x == "offscreenright" then
        x = 960 + x;
    elseif _x == "twoleft" then
        x = (((960 / 2) / 2) - (x / 2));
    elseif _x == "tworight" then
        -- 1quart + 1half = 3quart
        x = ( ( ( (960 / 2) / 2) + (960 / 2)) - (x / 2) );
    end
    
    -- check if char already exists in the active char array
    -- if it does, then unload it after stealing the X value
    for k in pairs(March22.ACTIVECHARACTERS) do
      if March22.ACTIVECHARACTERS[k].name == _charname then
          if _x == "None" then
              x = March22.ACTIVECHARACTERS[k].x;
          end
          March22.ACTIVECHARACTERS[k] = nil;
      end
    end
    
    if _anim == nil then
      table.insert(March22.ACTIVECHARACTERS, CharacterSprite.new ( x, y, _charname, _emotion));
    else 
      table.insert(March22.ACTIVECHARACTERS, CharacterSprite.new ( x, y, _charname, _emotion,_anim,_speed,_animfunc));
    end
    --]]
end
