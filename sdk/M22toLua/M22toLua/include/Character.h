#pragma once

#include <vector>
#include <string>

static std::vector<std::wstring> CHARACTER_NAMES;
static std::vector<std::wstring> CHARACTER_NAMES_FIXED;

struct Character {
	std::vector<std::wstring> sprites;
	std::wstring name;
	Character()
	{
		name = L"";
	};
};

bool isCharacter(std::wstring _name);

std::wstring GenerateCharacterArray(Character& _char);

std::wstring CheckForAnimation(std::vector<std::wstring>& _vector, size_t _pos);