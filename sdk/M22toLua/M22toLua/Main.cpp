/*
	M22toLua
	A tool for converting March22 C++ script into March22-Lua-compliant Lua

	By Sam Lynch
*/

#include <iostream>
#include <fstream>
#include <vector>

#include <FileOp.h>
#include <Label.h>
#include <Character.h>
#include <GetFromVector.h>
#include <M22toLua.h>

int main(int argc, wchar_t* argv[])
{
	std::wstring filename;
	bool loadscriptfiletext = false;
	if (argc < 2)
	{
		printf("No parameters!\nLoading scriptfiles.txt...\n");
		//filename = L"script-a1-monday.rpy";
		loadscriptfiletext = true;
		//return -1;
	}
	else
	{
		filename = argv[1];
	}

	if (loadscriptfiletext == true)
	{
		std::vector<std::wstring> SCRIPT_FILE_NAMES;
		LoadTXTIntoVector("./scriptfiles.txt", SCRIPT_FILE_NAMES);
		for (size_t scrp = 0; scrp < SCRIPT_FILE_NAMES.size(); scrp++)
		{
			Label2::LABELS.clear();
			filename = SCRIPT_FILE_NAMES.at(scrp);

			std::vector<std::wstring> SCRIPT;
			std::vector<std::wstring> BACKGROUNDS;
			std::vector<Character> CHARACTERS;
			std::vector<std::wstring> SFX;
			std::vector<std::wstring> MUSIC;
			std::vector<std::wstring> LINES;

			LoadScriptIntoVector(filename.c_str(), SCRIPT);

			std::vector<std::wstring> splitString;
			SplitString(filename, splitString, '/');
			filename = splitString.back();

			CHARACTERS = GetLoadedCharactersFromVector(SCRIPT);
			BACKGROUNDS = GetLoadedBackgroundsFromVector(SCRIPT);
			SFX = GetLoadedSFXFromVector(SCRIPT);
			MUSIC = GetLoadedMusicFromVector(SCRIPT);
			LINES = GetLinesFromVector(SCRIPT, filename);

			WriteCompiledScript(filename, BACKGROUNDS, LINES, SFX, CHARACTERS, MUSIC);
		}
		WriteLabelIndexFile();
	}
	else
	{
		std::vector<Character> CHARACTERS;
		std::vector<std::wstring> SCRIPT;
		std::vector<std::wstring> BACKGROUNDS;
		std::vector<std::wstring> SFX;
		std::vector<std::wstring> MUSIC;
		std::vector<std::wstring> LINES;


		LoadScriptIntoVector(filename.c_str(), SCRIPT);

		std::vector<std::wstring> splitString;
		SplitString(filename, splitString, '/');
		filename = splitString.back();

		CHARACTERS = GetLoadedCharactersFromVector(SCRIPT);
		BACKGROUNDS = GetLoadedBackgroundsFromVector(SCRIPT);
		SFX = GetLoadedSFXFromVector(SCRIPT);
		MUSIC = GetLoadedMusicFromVector(SCRIPT);
		LINES = GetLinesFromVector(SCRIPT);


		WriteCompiledScript(filename, BACKGROUNDS, LINES, SFX, CHARACTERS, MUSIC);
	}

	printf("\nsuccesful!");


	return 0;
}