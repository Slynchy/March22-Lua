
-- init the active variables to nil
March22.ACTIVEBACKGROUND = nil; 
March22.ACTIVEBACKGROUND_NAME = nil;

-- Loads the specified background if it doesn't already exist
function LoadBackground(_name)
  if LOADEDBACKGROUNDS[_name] == nil then
    LOADEDBACKGROUNDS[_name] = Graphics.loadImage("app0:/graphics/backgrounds/".._name..".jpg");
  end
end

-- Changes the current background if it exists
function ChangeBackground(_name)
  if not (LOADEDBACKGROUNDS[_name] == nil) then
    March22.ACTIVEBACKGROUND = LOADEDBACKGROUNDS[_name];
	March22.ACTIVEBACKGROUND_NAME = _name;
  end
end
