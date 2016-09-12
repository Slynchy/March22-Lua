
-- Index for current line of script (LUA STARTS AT 1, NOT ZERO BECAUSE THAT MAKES SENSE.)
March22.CURRENTLINE = 1;

-- Shorthand for ChangeLine(current+1)
-- Deprecated
function March22.NextLine()
  March22.ChangeLine(March22.CURRENTLINE+1);
end

-- Changes line to specified number
-- Does not check if line doesn't exist, so be careful
function March22.ChangeLine(_number)
  if March22.CURRENTLINE >= SIZE_OF_ACTIVE_SCRIPT then
	-- do nothing; EOF
  else

    March22.CURRENTLINE = March22.CURRENTLINE+1;
    March22.ACTIVECHARACTER_NAME = ACTIVE_SCRIPT[March22.CURRENTLINE].speaker;
    March22.ACTIVESPEECH = ACTIVE_SCRIPT[March22.CURRENTLINE].content;
    March22.ACTIVECHARACTER_COLOR = ACTIVE_SCRIPT[March22.CURRENTLINE].color;

    ACTIVE_SCRIPT[March22.CURRENTLINE].func();
  end
end

function March22.UnloadLoadedAssets()

  --Unload backgrounds
  for k in pairs(LOADEDBACKGROUNDS) do
    Graphics.freeImage(LOADEDBACKGROUNDS[k]);
    LOADEDBACKGROUNDS[k] = nil;
  end
  March22.ACTIVEBACKGROUND = nil;

  --Unload SFX
  for k in pairs(LOADEDSFX) do
    Sound.close(LOADEDSFX[k]);
    LOADEDSFX[k] = nil;
  end

  --Unload characters
  for k in pairs(March22.CHARACTERS) do
    for i in pairs(March22.CHARACTERS[k].sprites) do
      Graphics.freeImage(March22.CHARACTERS[k].sprites[i]);
    end
    March22.CHARACTERS[k] = nil;
  end
  March22.ClearCharacter();
end

function March22.ChangeScript(_scriptname)
  March22.UnloadLoadedAssets();
  dofile("app0:/scripts/".._scriptname..".lua");
  March22.CURRENTLINE = 0;
  March22.ChangeLine();
end