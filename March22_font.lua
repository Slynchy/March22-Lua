
March22.TypeWriterFrame = 0.0;

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

March22.TypeWriterLineComplete = false;

function March22.DrawTypeWriterEffect(_font, _x, _y, _text, _color)
  March22.TypeWriterFrame = March22.TypeWriterFrame + 0.5;
  tempint = string.len(_text);
  tempText = "";
  if March22.TypeWriterFrame >= tempint then
    March22.TypeWriterFrame = tempint;
    tempText = _text;
	March22.TypeWriterLineComplete = true;
  else
	March22.TypeWriterLineComplete = false;
    --tempText = string.sub(_text, 0, math.ceil(March22.TypeWriterFrame));
	tempText = utf8sub(_text, 0, math.ceil(March22.TypeWriterFrame)); -- From http://wowprogramming.com/snippets/UTF-8_aware_stringsub_7
  end
  
  March22.DrawWrappedText(_font, _x, _y, tempText, _color);
end


