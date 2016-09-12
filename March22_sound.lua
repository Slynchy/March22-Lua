Sound.init();
function March22.PlayTrack(_name)
	if LOADEDMUSIC[_name] == nil then
		return;
	else
		if March22.ACTIVEMUSICTRACK == nil then
		
		else
			Sound.pause(March22.ACTIVEMUSICTRACK);
		end
		March22.ACTIVEMUSICTRACK = LOADEDMUSIC[_name];
		Sound.play(March22.ACTIVEMUSICTRACK,LOOP);
	end
end

--March22.ACTIVEMUSICTRACK = LOADEDMUSIC["music_serene"];
--
--