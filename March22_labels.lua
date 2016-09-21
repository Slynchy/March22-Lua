print("Loading March22_labels.lua");

dofile("app0:/LUA_CLASSES/Decision.lua");
dofile("app0:/scripts/LabelIndex.lua");
March22.MakingDecision = false;

-- These are the return values
-- For some reason it's just the number of the decision prefixed with 'm'
m1 = "decision1";
m2 = "decision2";
m3 = "decision3"; -- not used yet

-- Also init the _return value
_return = m1;

-- Load the graphic for decisions, as this is constant
decision_bar_graphic = Graphics.loadImage("app0:/graphics/bg-choice.png");

--[[
	The function for making a decision
	Hijacks the framebuffer to draw it
	Parameter is just Decision.new() usually
  ]]
function MakeDecision(_decision)
	
	madeDecision = false;
	
	-- Set the dialogue to be the decision text
	March22.ACTIVECHARACTER_NAME = _decision.speaker;
	March22.ACTIVESPEECH = _decision.speech;
	March22.ACTIVECHARACTER_COLOR = Color.new(255,255,255);
	
	-- No typewriter effect so max it out
	March22.TypeWriterFrame = 420;

	-- Reset the controls to prevent overlap/leaking
	if March22.BUTTON_X_PRESSED == 1 then
		March22.BUTTON_X_PRESSED = 2;
	end
	if March22.BUTTON_SQUARE_PRESSED == 1 then
		March22.BUTTON_SQUARE_PRESSED = 2;
	end
	if March22.BUTTON_TRIANGLE_PRESSED == 1 then
		March22.BUTTON_TRIANGLE_PRESSED = 2;
	end
	
	-- A copy of the main loop from index.lua, with modifications
	while madeDecision == false do
		Graphics.initBlend();
		Screen.clear();
		March22.Render();

		-- Draw the decision graphic + button markers
		-- The co-ords are pre-calc'd for PSVita; will need editing for 3DS or other resolutions
		Graphics.drawImage(178, 115, decision_bar_graphic);
		Graphics.drawImage(178, 167, decision_bar_graphic);
		Graphics.drawImage(185, 121, March22.TRIANGLE_BUTTON_GRAPHIC);
		Graphics.drawImage(185, 174, March22.SQUARE_BUTTON_GRAPHIC);

		-- Set pixel size to fit the graphic (determinent on the font) and print it
		Font.setPixelSizes(March22.FONT   , 18);
		Font.print(March22.FONT, 210, 123, _decision.decision1, Color.new(145,135,121));
		Font.print(March22.FONT, 210, 175, _decision.decision2, Color.new(145,135,121));
		Font.setPixelSizes(March22.FONT   , FONTSIZE);

		Graphics.termBlend();
		March22.UpdatePad();

		-- Triangle = decision1
		-- Square = decision2
		-- Circle = decision3 (not added yet)
		if March22.BUTTON_TRIANGLE_PRESSED == 1 then
			_return = m1;
			madeDecision = true;
		end
		if March22.BUTTON_SQUARE_PRESSED == 1 then
			_return = m2;
			madeDecision = true;
		end
		
		-- Flip the screen buffer
		Screen.flip()
		
		-- Reset the controls again
		if March22.BUTTON_X_PRESSED == 1 then
			March22.BUTTON_X_PRESSED = 2;
		end
		if March22.BUTTON_SQUARE_PRESSED == 1 then
			March22.BUTTON_SQUARE_PRESSED = 2;
		end
		if March22.BUTTON_TRIANGLE_PRESSED == 1 then
			March22.BUTTON_TRIANGLE_PRESSED = 2;
		end
		
		Screen.waitVblankStart();
	end
	March22.MakingDecision = false;
	
	-- Re-reset the font size, just incase of leak
	Font.setPixelSizes(March22.FONT   , FONTSIZE);

	-- Do the next label, because we now have the correct _return value
	-- This means you can't have a decision be the last thing in a label, or it'll crash
	March22.CURRENT_LABEL_POSITION = March22.CURRENT_LABEL_POSITION + 1;
	LABELS[March22.CURRENT_LABEL][March22.CURRENT_LABEL_POSITION]();
	
end

-- Jumps out of the current label and executes the first command in the specified one
function jump_out(_label)
	March22.CURRENT_LABEL = _label;
	March22.CURRENT_LABEL_POSITION = 1;
	LABELS[March22.CURRENT_LABEL][March22.CURRENT_LABEL_POSITION]();
end

-- Finds the scene in the loaded script and jumps to it
-- If the scene is not found in the loaded script then it loads the correct one first
function iscene(_scriptlabel)
	if LABEL_POSITIONS[_scriptlabel] == nil then
		March22.ChangeScript(LABELINDEX[_scriptlabel]);
	end
	
	March22.CURRENTLINE = (LABEL_POSITIONS[_scriptlabel] + 1);
	March22.ACTIVECHARACTER_NAME = ACTIVE_SCRIPT[March22.CURRENTLINE].speaker;
	March22.ACTIVESPEECH = ACTIVE_SCRIPT[March22.CURRENTLINE].content;
	March22.ACTIVECHARACTER_COLOR = ACTIVE_SCRIPT[March22.CURRENTLINE].color;
	March22.SeenScenes[_scriptlabel] = true;
	ACTIVE_SCRIPT[March22.CURRENTLINE].func(); 
end

-- This is supposed to play the act opening MKV file.
-- Not used yet
act_op = function(_filename)

end

-- Executes the decision at the specified script label
function imenu(_scriptlabel)
	March22.MakingDecision = true;
	March22.CURRENTLINE = (LABEL_POSITIONS[_scriptlabel] + 1);
	ACTIVE_SCRIPT[March22.CURRENTLINE].func(); 
	March22.SeenScenes[_scriptlabel] = true;
end

-- Returns true if player has seen the scene, false if not
function seen_scene(_scriptlabel)
	return March22.SeenScenes[_scriptlabel];
end

-- Ends the path/game? Not sure yet.
path_end = function(_path)

end

-- Execute the imachine.lua file now that we've initialised all the function
dofile("app0:/scripts/imachine.lua");
