dofile("app0:/March22.lua")
System.setCpuSpeed(333);
Sound.init();
Sound.play(March22.ACTIVEMUSICTRACK,LOOP);

deltaTime = 0;
timeSinceStart = 0;
oldTimeSinceStart = 0;
timer=Timer.new();
-- Main loop
while true do
	
	-- Blend some images with different funcs (normal, rotated, scaled)
	Graphics.initBlend();
	Screen.clear();
	March22.Render();
	
	timeSinceStart = Timer.getTime(timer);
	deltaTime = timeSinceStart - oldTimeSinceStart;
	oldTimeSinceStart = timeSinceStart;
	Graphics.debugPrint(5, 5,(1000/deltaTime).."ms",  Color.new(255,0,0),2);
	
	Graphics.termBlend();
	
	-- Update input
	March22.UpdatePad();
	if March22.BUTTON_X_PRESSED == 1 then
		March22.ChangeLine(March22.CURRENTLINE + 1);
	end
	if March22.BUTTON_TRIANGLE_PRESSED == 1 then
		System.exit()
	end
	
	-- Flip screen
	Screen.flip()
	
	if March22.BUTTON_X_PRESSED == 1 then
		March22.BUTTON_X_PRESSED = 2;
	end
	if March22.BUTTON_TRIANGLE_PRESSED == 1 then
		March22.BUTTON_TRIANGLE_PRESSED = 2;
	end
end