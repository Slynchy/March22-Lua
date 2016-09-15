

March22.ACTIVEBACKGROUND = nil;              -- The active background to draw
March22.ACTIVEBACKGROUND_NAME = nil;

function LoadBackground(_name)
  if LOADEDBACKGROUNDS[_name] == nil then
    LOADEDBACKGROUNDS[_name] = Graphics.loadImage("app0:/graphics/backgrounds/".._name..".jpg");
  end
end

function ChangeBackground(_name)
  if not (LOADEDBACKGROUNDS[_name] == nil) then
    March22.ACTIVEBACKGROUND = LOADEDBACKGROUNDS[_name];
	March22.ACTIVEBACKGROUND_NAME = _name;
  end
end