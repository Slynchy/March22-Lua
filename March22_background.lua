

March22.ACTIVEBACKGROUND = nil;              -- The active background to draw

LOADEDBACKGROUNDS["black"] = Graphics.loadImage("app0:/graphics/black.jpg");
LOADEDBACKGROUNDS["white"] = Graphics.loadImage("app0:/graphics/white.jpg");

function LoadBackground(_name)
  if LOADEDBACKGROUNDS[_name] == nil then
    LOADEDBACKGROUNDS[_name] = Graphics.loadImage("app0:/graphics/backgrounds/".._name..".jpg");
  end
end