--Controller
March22.PAD = Controls.read();                             
--[[ 
  0 = unpressed
  1 = pressed during frame, queue action
  2 = still pressed, do not act upon
--]]
March22.BUTTON_X_PRESSED = 0;
March22.BUTTON_TRIANGLE_PRESSED = 0;
March22.BUTTON_START_PRESSED = 0;


-- Update controller and single-press variables
function March22.UpdatePad()
  March22.PAD = Controls.read();
  
  if Controls.check(March22.PAD, SCE_CTRL_CROSS) then
    if March22.BUTTON_X_PRESSED == 0 then
      March22.BUTTON_X_PRESSED = 1;
    else 
      return;
    end
  else
    March22.BUTTON_X_PRESSED = 0;
  end
  
  if Controls.check(March22.PAD, SCE_CTRL_TRIANGLE) then
    if March22.BUTTON_TRIANGLE_PRESSED == 0 then
      March22.BUTTON_TRIANGLE_PRESSED = 1;
    else 
      return;
    end
  else
    March22.BUTTON_TRIANGLE_PRESSED = 0;
  end
  
  if Controls.check(March22.PAD, SCE_CTRL_START) then
    if March22.BUTTON_START_PRESSED == 0 then
      March22.BUTTON_START_PRESSED = 1;
    else 
      return;
    end
  else
    March22.BUTTON_START_PRESSED = 0;
  end
end