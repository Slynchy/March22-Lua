Decision = {};
Decision.__index = Decision;

function Decision.new (_speaker, _speech, _decision1, _decision2, _decision3)
	local decobj = {} 
	setmetatable(decobj,Decision);
	decobj.speaker = _speaker;
	decobj.speech = _speech;
	decobj.decision1 = _decision1;
	decobj.decision2 = _decision2;
	decobj.decision3 = nil;
	
	if not (_decision3 == nil) then
		decobj.decision3 = _decision3;
	end
	
	return decobj;
end

-- label en_choiceA1:
-- menu:
    -- mu "Do you want to introduce yourself to the class?"
    -- with menueffect
    -- "Why?":



        -- return m1
    -- "Yeah, of course.":

        -- return m2