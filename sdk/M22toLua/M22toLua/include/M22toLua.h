#pragma once

#define VERSION_MAJOR 0
#define VERSION_MINOR 7
#define VERSION_PATCH 0

#include <string>
#include <vector>
#include <Character.h>

void WriteCompiledScript(
	std::wstring _filename, 
	std::vector<std::wstring>& _backgrounds, 
	std::vector<std::wstring>& _lines, 
	std::vector<std::wstring>& _sfx, 
	std::vector<Character>& _characters, 
	std::vector<std::wstring>& _music
);
