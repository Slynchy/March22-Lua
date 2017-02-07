#include "Character.h"

#include <algorithm>
#include <FileOp.h>

bool isCharacter(std::wstring _name)
{
	for (size_t i = 0; i < CHARACTER_NAMES.size(); i++)
	{
		if (CHARACTER_NAMES.at(i) == _name)
		{
			return true;
		};
	}
	return false;
};

std::wstring CheckForAnimation(std::vector<std::wstring>& _vector, size_t _pos)
{
	bool exit = false;
	int pos = _pos;
	while (exit == false || pos < (_pos + 8))
	{
		pos++;
		if (pos < _vector.size())
		{
			std::vector<std::wstring> splitString;
			SplitString(_vector.at(pos), splitString, ' ');
			if (splitString.at(0) == L"with")
			{
				// found anim
				return splitString.at(1);
			}
		};
	}

	return L"";
}

std::wstring GenerateCharacterArray(Character& _char)
{
	std::wstring result = L"March22.CHARACTERS[\"";
	result += _char.name;
	result += L"\"] = Character.new(\"";
	result += _char.name;
	result += L"\", {\n";

	for (size_t i = 0; i < _char.sprites.size(); i++)
	{
		result += L"	\"";
		std::wstring temp = _char.sprites.at(i);
		temp.erase(std::remove(temp.begin(), temp.end(), ':'), temp.end());
		result += temp;
		result += L"\"";

		// if not the last emotion
		if (!(i == (_char.sprites.size() - 1)))
		{
			result += L",\n";
		}
	}
	result += L"});\n\n";

	return result;
}