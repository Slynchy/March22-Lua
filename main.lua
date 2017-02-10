-- lpp-vita (love2d) wrapper
-- By Sam Lynch
-- lpp-vita is an open-source project by rinnegatamante

IS_ON_PC = true;

Graphics = {};
Font = {};
Controls = {};
System = {};
Sound = {};
Screen = {};

LOOP = true
NO_LOOP = false;

SCE_CTRL_SQUARE = 1;
SCE_CTRL_CIRCLE  = 2;
SCE_CTRL_TRIANGLE  = 3;
SCE_CTRL_START  = 4;
SCE_CTRL_SELECT = 5;
SCE_CTRL_RTRIGGER  = 6;
SCE_CTRL_RTRIGGER  = 7;
SCE_CTRL_CROSS = 8;
pad = {};
pad.__index = pad;

function pad.new ()
  local padobj = {}             -- our new object
  setmetatable(padobj,pad);
  
  padobj.r = r;
  
  return padobj;
end

Color = {};
Color.__index = Color;

function Color.new (r, g, b, a)
  local colorobj = {}             -- our new object
  setmetatable(colorobj,color);
  
  colorobj.r = r;
  colorobj.g = g;
  colorobj.b = b;
  if a == nil then
	colorobj.a = 255;
  else
	colorobj.a = a;
  end
  
  return colorobj;
end

Screen.flip = function()
	love.graphics.present()
end

System.exit = function()
	love.quit();
end

UpdateLoveEvents = function()
	for e, a, b, c, d in love.event.poll() do
		if e == "quit" then
			System.exit()
		end	
	end
end

Screen.clear = function()
	love.graphics.clear()
	--love.event.pump()
	--UpdateLoveEvents( )
end

Screen.waitVblankStart = function()
	-- nothing
end

System.setCpuSpeed = function(speed)
	-- nothing
end

System.doesFileExist = function(path)
	return love.filesystem.exists( path );
end

System.createDirectory = function(path)
	--love.filesystem.mkdir(path)
	-- lol i'm not letting this thing have filesystem control
	-- i'm not that crazy
	-- maybe
end

Sound.init = function()
	-- nothing
end

Sound.pause = function(snd)
	-- we never pause sound; just as a shortcut for stopping it
	love.audio.stop(snd)
end

Sound.close = function(snd)
	snd = nil
	collectgarbage()
end

Sound.openOgg = function(filename)
	if string.sub(filename, 0, 4) == "app0" then
		filename = string.sub(filename, 6);
	end
	return love.audio.newSource(filename, "static")
end
	
Sound.play = function(file, loop)
	file:setLooping(loop);
	file:play();
end

function Graphics.loadImage(filename)

	if string.sub(filename, 0, 4) == "app0" then
		filename = string.sub(filename, 6);
	end
	return love.graphics.newImage(filename);
end

function Graphics.initBlend()

end

function Graphics.termBlend()

end

function Graphics.debugPrint(x, y, text, color, scale)

	print(text);
end

Graphics.fillRect = function(x1, x2, y1, y2, color)
	love.graphics.setColor(color.r,color.g,color.b,color.a);
	love.graphics.rectangle( 'fill', x1, y1, x2-x1, y2-y1 )
end

Graphics.drawImage = function(x, y, image, color)
	if color == nil then
		color = Color.new(255,255,255,255)
	else
		--
	end
	love.graphics.setColor(color.r,color.g,color.b,color.a);
	love.graphics.draw( image, x, y);
end

Graphics.drawRotateImage = function(x, y, image, rotation, color, offsetX, offsetY)
	if color == nil then
		color = Color.new(255,255,255,255)
	else
		--
	end
	love.graphics.setColor(color.r,color.g,color.b,color.a);
	love.graphics.draw( image, x, y, rotation, 1, 1, offsetX, offsetY);
end

Graphics.getImageWidth = function(image)

	return image:getWidth();
end;

Graphics.getImageHeight = function(image)

	return image:getHeight();
end;

Graphics.freeImage = function(image) 
	-- love2d doesn't have a free image function?
	-- too reliant on automatic memory management ¬.¬
	image = nil
	collectgarbage()
end

Font.load = function(filename)
	if string.sub(filename, 0, 4) == "app0" then
		filename = string.sub(filename, 6);
	end
	return love.graphics.newFont(filename, 20);
end

Font.print = function(font, x, y, text, color)
	love.graphics.setColor(color.r,color.g,color.b,color.a);
	love.graphics.setFont( font );
	love.graphics.print(text, x, y);
end

Font.setPixelSizes = function(font, size)
	--
end

Controls.read = function()

	--love.keyboard.isScancodeDown( scancode, ... )
	temppad = pad.new();
	temppad[SCE_CTRL_CROSS] = love.keyboard.isScancodeDown( 'return' );
	temppad[SCE_CTRL_TRIANGLE] = love.keyboard.isScancodeDown( 'w' );
	temppad[SCE_CTRL_CIRCLE] = love.keyboard.isScancodeDown( 'd' );
	temppad[SCE_CTRL_SQUARE] = love.keyboard.isScancodeDown( 'a' );
	temppad[SCE_CTRL_START] = love.keyboard.isScancodeDown( 'space' );
	temppad[SCE_CTRL_RTRIGGER] = love.keyboard.isScancodeDown( 'escape' );
	return temppad;
end

Controls.check = function( padvar , buttoncode)

	return padvar[buttoncode];
end

function love.conf(t)
    t.console = true;
	t.window.title = "March22";
	t.window.resizable = true;
	t.window.vsync=true;
	t.window.width = 960;
	t.window.height = 544;
end

dofile = function(param)
	param = string.sub(param, 7);
	param = "./"..param;
	param = string.sub(param, 0, -5);
	print(param);
	require(param);
end

function love.quit()
	love.event.push('quit')
	--love.window.close( )
    --return true
end

function love.load()
	love.graphics.setColor(255,255,255,255);
	require("index")
end