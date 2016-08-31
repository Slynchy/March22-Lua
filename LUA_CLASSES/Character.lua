Character = {};
Character.__index = Character;

function Character.new (_name, _sprite_array)
	local charobj = {}             -- our new object
	setmetatable(charobj,Character);
	
	charobj.name = _name;
	charobj.sprites = {};
	for k in pairs(_sprite_array) do
		-- table.insert(charobj.sprites, Graphics.loadImage("app0:/graphics/characters/".._name.."/".._sprite_array[k]..".png"));
		charobj.sprites[_sprite_array[k]] = Graphics.loadImage("app0:/graphics/characters/".._name.."/".._sprite_array[k]..".png");
	end
	
	return charobj;
end

CharacterSprite = {};
CharacterSprite.__index = CharacterSprite;

function CharacterSprite.new (_x, _y, _name, _emotion)
	local charspriteobj = {}             -- our new object
	setmetatable(charspriteobj,CharacterSprite);
	
	charspriteobj.name = _name;
	charspriteobj.emotion = _emotion;
	charspriteobj.x = _x;
	charspriteobj.y = _y;
	
	return charspriteobj;
end

-- March22.ACTIVECHARACTER_NAME = ACTIVE_SCRIPT[1].speaker;
-- March22.ACTIVESPEECH = ACTIVE_SCRIPT[1].content;
-- March22.ACTIVECHARACTER_COLOR = ACTIVE_SCRIPT[1].color;