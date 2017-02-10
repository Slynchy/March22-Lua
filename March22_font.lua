
-- init the typewriter frame variable
March22.TypeWriterFrame = 0.0;

March22.currentPageTypewriter = "";

-- boolean for whether line is done typewriting
March22.TypeWriterLineComplete = false;

mainFont = love.graphics.newFont("graphics/font.ttf", 20);

-- Gets the size of the char (to tell if UTF-8 or not)
function chsize(char)
    if not char then
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end

-- Performs substring op on UTF-8 string without breaking it
function utf8sub(str, startChar, numChars)
  local startIndex = 1
  while startChar > 1 do
      local char = string.byte(str, startIndex)
      startIndex = startIndex + chsize(char)
      startChar = startChar - 1
  end
 
  local currentIndex = startIndex
 
  while numChars > 0 and currentIndex <= #str do
    local char = string.byte(str, currentIndex)
    currentIndex = currentIndex + chsize(char)
    numChars = numChars -1
  end
  return str:sub(startIndex, currentIndex - 1)
end

-- Writes wrapped text according to maxChar variable
-- Maximum of 3 lines of text
function March22.DrawWrappedText(_font, _x, _y, _text, _color)

  if _text == "" then
    return
  end

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

-- Draws substring of wrapped text with typewriter effect
function March22.DrawTypeWriterEffect(_font, _x, _y, _text, _color)
	
	local tempint = string.len(March22.currentPage);
	local tempint2 = string.len(March22.currentPageTypewriter);
	
	if tempint2 < tempint then
		March22.TypeWriterFrame = March22.TypeWriterFrame + 0.4;
		March22.TypeWriterLineComplete = false;
		March22.currentPageTypewriter = utf8sub(March22.currentPage, 0, math.ceil(March22.TypeWriterFrame));
	else 
		March22.TypeWriterLineComplete = true;
	end
	
	love.graphics.setFont(mainFont);
	love.graphics.printf( March22.currentPageTypewriter, _x, _y, 885, "left" )

	--March22.DrawWrappedText(_font, _x, _y, tempText, _color);
end


