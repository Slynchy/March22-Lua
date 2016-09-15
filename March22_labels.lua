
dofile("app0:/LUA_CLASSES/Decision.lua");
March22.MakingDecision = false;

m1 = "decision1";
m2 = "decision2";

_return = m1;

decision_bar_graphic = Graphics.loadImage("app0:/graphics/bg-choice.png");

function MakeDecision(_decision)
	
	madeDecision = false;
	
    March22.ACTIVECHARACTER_NAME = _decision.speaker;
    March22.ACTIVESPEECH = _decision.speech;
    March22.ACTIVECHARACTER_COLOR = Color.new(255,255,255);
	
	March22.TypeWriterFrame = 420;
	if March22.BUTTON_X_PRESSED == 1 then
		March22.BUTTON_X_PRESSED = 2;
	end
	if March22.BUTTON_SQUARE_PRESSED == 1 then
		March22.BUTTON_SQUARE_PRESSED = 2;
	end
	if March22.BUTTON_TRIANGLE_PRESSED == 1 then
		March22.BUTTON_TRIANGLE_PRESSED = 2;
	end
	
	while madeDecision == false do
		Graphics.initBlend();
		Screen.clear();
		March22.Render();
		--Graphics.debugPrint(155, 125, _decision.speaker, Color.new(255,0,0));
		--Graphics.debugPrint(155, 155, _decision.speech, Color.new(255,0,0));
		--Graphics.debugPrint(155, 185, _decision.decision1, Color.new(255,0,0));
		--Graphics.debugPrint(155, 215, _decision.decision2, Color.new(255,0,0));
		Graphics.drawImage(178, 115, decision_bar_graphic);
		Graphics.drawImage(178, 167, decision_bar_graphic);
		Graphics.drawImage(185, 121, March22.TRIANGLE_BUTTON_GRAPHIC);
		Graphics.drawImage(185, 174, March22.SQUARE_BUTTON_GRAPHIC);
		Font.setPixelSizes(March22.FONT   , 18);
		Font.print(March22.FONT, 210, 123, _decision.decision1, Color.new(145,135,121));
		Font.print(March22.FONT, 210, 175, _decision.decision2, Color.new(145,135,121));
		Font.setPixelSizes(March22.FONT   , FONTSIZE);
		Graphics.termBlend();
		March22.UpdatePad();
		if March22.BUTTON_TRIANGLE_PRESSED == 1 then
			_return = m1;
			madeDecision = true;
		end
		if March22.BUTTON_SQUARE_PRESSED == 1 then
			_return = m2;
			madeDecision = true;
		end
		
		-- Flip screen
		Screen.flip()
		
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
	Font.setPixelSizes(March22.FONT   , FONTSIZE);
	March22.CURRENT_LABEL_POSITION = March22.CURRENT_LABEL_POSITION + 1;
	LABELS[March22.CURRENT_LABEL][March22.CURRENT_LABEL_POSITION]();
	
end

function jump_out(_label)
	March22.CURRENT_LABEL = _label;
	March22.CURRENT_LABEL_POSITION = 1;
	LABELS[March22.CURRENT_LABEL][March22.CURRENT_LABEL_POSITION]();
end

function iscene(_scriptlabel)
	--if not (LABEL_POSITIONS[_scriptlabel] == nil) then
		March22.CURRENTLINE = (LABEL_POSITIONS[_scriptlabel] + 1);
		March22.ACTIVECHARACTER_NAME = ACTIVE_SCRIPT[March22.CURRENTLINE].speaker;
		March22.ACTIVESPEECH = ACTIVE_SCRIPT[March22.CURRENTLINE].content;
		March22.ACTIVECHARACTER_COLOR = ACTIVE_SCRIPT[March22.CURRENTLINE].color;
		March22.SeenScenes[_scriptlabel] = true;
		ACTIVE_SCRIPT[March22.CURRENTLINE].func(); 
	--end
end

act_op = function(_filename)

end

function imenu(_scriptlabel)
	March22.MakingDecision = true;
	March22.CURRENTLINE = (LABEL_POSITIONS[_scriptlabel] + 1);
	ACTIVE_SCRIPT[March22.CURRENTLINE].func(); 
	March22.SeenScenes[_scriptlabel] = true;
end

function seen_scene(_scriptlabel)
	return March22.SeenScenes[_scriptlabel];
end

path_end = function(_path)

end

dofile("app0:/scripts/imachine.lua");
