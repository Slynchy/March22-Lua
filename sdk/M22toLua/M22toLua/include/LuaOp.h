#pragma once

#include <string>
#include <vector>

enum LUAFUNCTION {
	PLAY_SOUND,
	PLAY_MUSIC,
	CHANGE_BACKGROUND,
	CHANGELINE,
	CLEAR_CHARACTER,
	NEW_CHARACTER,
	NEW_DECISION,
	SHOW_NVL,
	HIDE_NVL,
	CLEAR_NVL
};

struct DECISION
{
	std::wstring speaker, speech;
	std::vector<std::wstring> decisions;
};

std::wstring CreateLuaFunction(LUAFUNCTION _function, std::wstring _param, bool _newline = false, bool _prefixsuffix = false, std::wstring _param2 = L"", std::wstring _param3 = L"", std::wstring _param4 = L"", std::wstring _param5 = L"");
std::wstring CreateDecision(size_t& pos, std::vector<std::wstring>& _vector);