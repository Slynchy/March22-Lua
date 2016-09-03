dofile("app0:/LUA_CLASSES/Line.lua");
dofile("app0:/March22_background.lua");


LOADEDSFX = {};
March22.CHARACTERS["muto"] = Character.new("muto", {
  "normal",
  "smile",
  "irritated"});
LoadBackground("op_snowywoods");


ACTIVE_SCRIPT = {
  --Line.new("", March22.WHITE_COLOUR, "", function() March22.AddCharacterToActive("center", "shizu", "basic_normal", "charaenter", function() March22.NextLine(); end ); end ),
  Line.new("", March22.WHITE_COLOUR, "", function() March22.NextLine(); end ),
  Line.new("", March22.WHITE_COLOUR, "", function() March22.NextLine(); end ),
  Line.new("", March22.WHITE_COLOUR, "", function() March22.NextLine(); end ),
  Line.new("", March22.WHITE_COLOUR, "", function() March22.NextLine(); end ),
  Line.new("", March22.WHITE_COLOUR, "", function() March22.NextLine(); end ),
  Line.new("", March22.WHITE_COLOUR, "", function() March22.NextLine(); end ),
  Line.new("", March22.WHITE_COLOUR, "", function() March22.NextLine(); end ),
  Line.new("", March22.WHITE_COLOUR, "", 
                                      -- March22.AddCharacterToActive(_x, _charname, _emotion, _anim, _animfunc, _speed)
                                      function() March22.AddCharacterToActive(
                                          "center", 
                                          "muto", 
                                          "normal", 
                                          "charaenter", 
                                          function() March22.NextLine(); end, 
                                          0.01
                                          ); 
                                      end ),
  Line.new("Shizune", March22.WHITE_COLOUR, "[Hello.]"),
  Line.new("", March22.WHITE_COLOUR, "", function() March22.NextLine(); end ),
  Line.new("", March22.WHITE_COLOUR, "", function() March22.NextLine(); end ),
  Line.new("", March22.WHITE_COLOUR, "", function() March22.ClearCharacter("muto"); March22.NextLine(); end ),
  Line.new("Hisao", March22.WHITE_COLOUR, "\"wassup.\"")
 };
 
 --