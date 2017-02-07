#include "LuaOp.h"

#include <algorithm>
#include <Character.h>
#include <FileOp.h>

std::wstring CreateLuaFunction(LUAFUNCTION _function, std::wstring _param, bool _newline, bool _prefixsuffix, std::wstring _param2, std::wstring _param3, std::wstring _param4, std::wstring _param5)
{
	std::wstring result = L"";
	if (_prefixsuffix)
	{
		result += L"function() ";
	};

	switch (_function)
	{
	case SHOW_NVL:
		result += std::wstring(L"March22.NVL_DISPLAY = 1;");
		break;
	case CLEAR_NVL:
		result += std::wstring(L"print(\"anus\");");
		break;
	case HIDE_NVL:
		result += std::wstring(L"March22.NVL_DISPLAY = 0;");
		break;
	case PLAY_SOUND:
		result += std::wstring(L"Sound.play(LOADEDSFX[\"" + _param + L"\"], NO_LOOP);");
		break;
	case PLAY_MUSIC:
		//March22.PlayTrack(_name)
		result += std::wstring(L"March22.PlayTrack(\"" + _param + L"\");");
		break;
	case CHANGE_BACKGROUND:
		//result += std::wstring(L"March22.ACTIVEBACKGROUND = LOADEDBACKGROUNDS[\"" + _param + L"\"];");
		result += std::wstring(L"ChangeBackground(\"" + _param + L"\");");
		break;
	case CLEAR_CHARACTER:
		result += std::wstring(L"March22.ClearCharacter(\"" + _param + L"\");");
		break;
	case NEW_CHARACTER:
		if (_param3 != L"" && _param3 != L"charachange")
		{// param3 = position, param = name, param2 = emotion
		 //March22.AddCharacterToActive(_x, _charname, _emotion, _anim, _animfunc, _speed)
			if (_param4 != L"")
			{
				result += std::wstring(L"March22.AddCharacterToActive(\"" + _param3 + L"\", \"" + _param + L"\", \"" + _param2 + L"\", \"" + _param4 + L"\", function() March22.NextLine(); end, 0.05);");
			}
			else
			{
				std::wstring temp = _param2;
				temp.erase(std::remove(temp.begin(), temp.end(), ':'), temp.end());
				result += std::wstring(L"March22.AddCharacterToActive(\"" + _param3 + L"\", \"" + _param + L"\", \"" + temp + L"\");");
			}
		}
		else
		{
			result += std::wstring(L"March22.AddCharacterToActive(\"None\", \"" + _param + L"\", \"" + _param2 + L"\");");
			_newline = true;
		}
		break;
	case CHANGELINE:
		result += L"March22.NextLine(); ";
		_newline = false;
		break;
	};

	if (_newline == true)
	{
		result += L"March22.NextLine(); ";
	};

	if (_prefixsuffix)
	{
		result += L"end ";
	};
	return result;
};

std::wstring CreateDecision(size_t& pos, std::vector<std::wstring>& _vector)
{
	DECISION newDec;
	size_t endpos;
	for (size_t i = pos; i < _vector.size(); i++)
	{
		std::vector<std::wstring> splitString;
		SplitString(_vector.at(i), splitString, ' ');
		if (splitString.at(0) == L"label")
		{
			endpos = i;
			break;
		}
	}

	for (size_t i = pos; i < endpos; i++)
	{
		// remove tabs
		myReplace(_vector.at(i), L"    ", L"");
		std::vector<std::wstring> splitString;
		SplitString(_vector.at(i), splitString, ' ');
		if (isCharacter(splitString.at(0)))
		{
			newDec.speaker = splitString.at(0);
			_vector.at(i).erase(0, splitString.at(0).size() + 1);
			myReplace(_vector.at(i), L"\"", L"");
			newDec.speech = _vector.at(i);
		}
		if (_vector.at(i).at(0) == L'\"')
		{
			myReplace(_vector.at(i), L"\"", L"");
			_vector.at(i).pop_back();
			newDec.decisions.push_back(_vector.at(i));
		}
	}

	pos = endpos;
	//Decision.new (_speaker, _speech, _decision1, _decision2, _decision3)

	std::wstring result;
	result += L"function() ";
	result += L"MakeDecision(Decision.new(\"";

	bool characterNameFound = false;
	for (size_t chr = 0; chr < CHARACTER_NAMES.size(); chr++)
	{
		if (newDec.speaker == CHARACTER_NAMES.at(chr))
		{
			characterNameFound = true;
			newDec.speaker = CHARACTER_NAMES_FIXED.at(chr);
		}
	}
	if (!characterNameFound) newDec.speaker = L"";

	result += newDec.speaker;
	result += L"\", \"";
	result += newDec.speech + L"\"";
	for (size_t i = 0; i < newDec.decisions.size(); i++)
	{
		result += L", \"";
		result += newDec.decisions.at(i) + L"\"";
	}
	result += L")); end ";

	return result;
}