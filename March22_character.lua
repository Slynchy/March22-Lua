

March22.CHARACTERS = {};                                -- Table of characters and their sprites (see Character.lua)
March22.CHARACTERS["shizune"] = Character.new("shizune", {"normal"});         -- How to initialize one called shizune with 1 emotion called normal


March22.ACTIVECHARACTER_NAME = ACTIVE_SCRIPT[1].speaker;                -- The name of the current speaker, derived from the current script line
March22.ACTIVESPEECH = ACTIVE_SCRIPT[1].content;                    -- The current dialogue/narrative
March22.ACTIVECHARACTER_COLOR = ACTIVE_SCRIPT[1].color;                 -- Color of character's name


-- Table of character sprites to draw on-screen and where
March22.ACTIVECHARACTERS = {                              
  --CharacterSprite.new ( (960/2) - (295 / 2), 544 - 600, "shizune", "normal")
};

-- Removes the specifed character from the active array
-- Params:
    -- _name = name of character
function March22.ClearCharacter(_name)
  if not _name == nil then    
  
    for k in pairs(March22.ACTIVECHARACTERS) do
        if k == _name then
          March22.ACTIVECHARACTERS[k] = nil;
          break;
        end
    end
  
  else
  
    for k in pairs(March22.ACTIVECHARACTERS) do
        March22.ACTIVECHARACTERS[k] = nil;
    end
    
  end
end

-- Adds the specified character name and emotion at the specified position
-- Params:
   -- _x = position (center, offscreenleft, twoleft)
   -- _charname = characters name in March22.CHARACTERS
   -- _emotion = emotion of character from March22.CHARACTERS
function March22.AddCharacterToActive(_x, _charname, _emotion)
    local y = Graphics.getImageHeight(March22.CHARACTERS[_charname].sprites[_emotion]);
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
    
    table.insert(March22.ACTIVECHARACTERS, CharacterSprite.new ( x, y, _charname, _emotion));
end