Line = {};
Line.__index = Line;

function Line.new (speaker, color, content, _function)
	local lineobj = {}             -- our new object
	setmetatable(lineobj,Line);
	lineobj.speaker = speaker;
	lineobj.color = color;
	lineobj.content = content;
	if _function then
		lineobj.func = _function;
	else
		lineobj.func = function() end;
	end
	return lineobj;
end