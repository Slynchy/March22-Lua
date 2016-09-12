Animation = {};
Animation.__index = Animation;

function lerp(a, b, t)
  return a + (b - a) * t
end

function Animation.new (_name, _speed, _animfunc, _param1, _parent)
  local anim = {}      
  setmetatable(anim,Animation);
  
  anim.name = _name;
  anim.frame = 0.0;
  anim.speed = _speed;
  anim.func = _animfunc;
  anim.parent = _parent;
  anim.complete = false;
  if _param1 == nil then
    anim.param1 = 0.0;
  else
    anim.param1 = _param1;
  end
  
  anim.Update = function()
    
    anim.frame = lerp(0, _param1, anim.speed);
    anim.frame = math.ceil(anim.frame);
    if anim.frame >= _param1 then
      anim.complete = true;
      anim.func();
    end
    
  end
  
  return anim;
end

Character = {};
Character.__index = Character;

function Character.new (_name, _sprite_array)
  local charobj = {}             -- our new object
  setmetatable(charobj,Character);
  
  charobj.name = _name;
  charobj.sprites = {};
  for k in pairs(_sprite_array) do
    -- table.insert(charobj.sprites, Graphics.loadImage("app0:/graphics/characters/".._name.."/".._sprite_array[k]..".png"));
    --local fileStream = io.open("app0:/log.txt",FCREATE);
    --io.write(fileStream,"app0:/graphics/characters/".._name.."/".._name.."_".._sprite_array[k]..".png\n", 90);
    charobj.sprites[_sprite_array[k]] = Graphics.loadImage("app0:/graphics/characters/".._name.."/".._name.."_".._sprite_array[k]..".png");
  end
  
  return charobj;
end

CharacterSprite = {};
CharacterSprite.__index = CharacterSprite;

function DeleteCharacterFromActive(_name)
  March22.ACTIVECHARACTERS[_name] = nil;
end

function CharacterSprite.new (_x, _y, _name, _emotion, _anim, _speed, _animfunc)
  local charspriteobj = {}          
  setmetatable(charspriteobj,CharacterSprite);
  
  charspriteobj.name = _name;
  charspriteobj.emotion = _emotion;
  charspriteobj.x = _x;
  charspriteobj.y = _y;
  charspriteobj.color = Color.new(255,255,255);
  charspriteobj.destroy = false;
  
--  charspriteobj.DestroyFunc = function() 
--      System.exit();

--    end;
  
  charspriteobj.color = Color.new(255,255,255,255);
  
  if _anim == nil then
    charspriteobj.anim = "";
  else
    charspriteobj.anim = _anim;
    charspriteobj.color = Color.new(255,255,255,0);
  end
  
  if _animfunc == nil then
    charspriteobj.animfunc = function() end;
  else
    charspriteobj.animfunc = _animfunc;
  end
  
  charspriteobj.frame = 0.0;
  charspriteobj.complete = false;
  
  if _speed == nil then
    charspriteobj.speed = 0.05;
  else
    charspriteobj.speed = _speed;
  end
  
  if charspriteobj.anim == "" then
    charspriteobj.complete = true;
    charspriteobj.animfunc();
  end
  
  charspriteobj.Update = function() 
    
    if charspriteobj.destroy == true then
      charspriteobj.frame = math.floor(lerp(charspriteobj.frame, 0, 0.05));
      charspriteobj.color = Color.new(255,255,255,charspriteobj.frame);
      if charspriteobj.frame == 0 then
        --charspriteobj = nil;
        DeleteCharacterFromActive(charspriteobj.name);
        return;
        --return DeleteCharacterFromActive(charspriteobj.name);
      end
    else
      if charspriteobj.complete == false then
        if charspriteobj.frame < 255 then
          --charspriteobj.frame = charspriteobj.frame + 1.0; 
          charspriteobj.frame = math.ceil(lerp(charspriteobj.frame, 255, charspriteobj.speed));
          charspriteobj.color = Color.new(255,255,255,charspriteobj.frame);
		  March22.DRAW_TEXTBOX = false;
        end
        
        if charspriteobj.frame >= 255 then
        
          if charspriteobj.complete == false then
            charspriteobj.animfunc();
            charspriteobj.complete = true;
			March22.DRAW_TEXTBOX = true;
          end
          
        end
      end;
    end;
  end
  
  return charspriteobj;
end

function AnimateByVariable(_type, _param1)

  if _type == "charaenter" then
    
  else
  
  end

end









