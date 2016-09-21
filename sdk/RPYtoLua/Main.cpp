/*
	RPYtoLua 
	A tool for converting RPY to March22-Lua-compliant Lua

	By Sam Lynch
*/

#define VERSION_MAJOR 0
#define VERSION_MINOR 6
#define VERSION_PATCH 0

#include <string>
#include <iostream>
#include <codecvt>
#include <vector>
#include <fstream>
#include <sstream>
#include <algorithm>
#include <chrono>

enum LUAFUNCTION {
	PLAY_SOUND,
	PLAY_MUSIC,
	CHANGE_BACKGROUND,
	CHANGELINE,
	CLEAR_CHARACTER, 
	NEW_CHARACTER,
	NEW_DECISION
};

struct Character {
	std::vector<std::wstring> sprites;
	std::wstring name;
	Character()
	{
		name = L"";
	};
};

struct DECISION
{
	/*decobj.speaker = _speaker;
	decobj.speech = _speech;
	decobj.decision1 = _decision1;
	decobj.decision2 = _decision2;
	decobj.decision3 = nil;*/
	std::wstring speaker, speech;
	std::vector<std::wstring> decisions;
};

int LoadScriptIntoVector(const wchar_t* _input, std::vector<std::wstring>& _vector);
std::vector<std::wstring> GetLoadedBackgroundsFromVector(std::vector<std::wstring>& _vector);
std::vector<std::wstring> GetLoadedSFXFromVector(std::vector<std::wstring>& _vector);
std::vector<std::wstring> GetLoadedMusicFromVector(std::vector<std::wstring>& _vector);
unsigned int SplitString(const std::wstring &txt, std::vector<std::wstring> &strs, char ch);
std::vector<std::wstring> GetLinesFromVector(std::vector<std::wstring>& _vector, std::wstring _filename = L"");
void WriteCompiledScript(std::wstring _filename, std::vector<std::wstring>& _backgrounds, std::vector<std::wstring>& _lines, std::vector<std::wstring>& _sfx, std::vector<Character>& _characters, std::vector<std::wstring>& _music);
int LoadTXTIntoVector(const char* _file, std::vector<std::wstring>& _vector);
std::wstring CreateLuaFunction(LUAFUNCTION _function, std::wstring _param, bool _newline = false, bool _prefixsuffix = false, std::wstring _param2 = L"", std::wstring _param3 = L"", std::wstring _param4 = L"", std::wstring _param5 = L"");
std::vector<Character> GetLoadedCharactersFromVector(std::vector<std::wstring>& _vector);
std::wstring CreateDecision(size_t& pos, std::vector<std::wstring>& _vector);
bool isCharacter(std::wstring _name);

struct LABEL
{
	std::wstring name;
	unsigned int position; // in lua, so starts at 1
};

struct LABEL_INDEX_OBJ
{
	std::wstring script_name;
	std::wstring label_name;
	LABEL_INDEX_OBJ()
	{
		script_name = L"";
		label_name = L"";
	}
	~LABEL_INDEX_OBJ()
	{
		script_name.clear();
		label_name.clear();
	}
};

std::vector<std::wstring> CHARACTER_NAMES;
std::vector<std::wstring> CHARACTER_NAMES_FIXED;
std::vector<LABEL> LABELS;
std::vector<LABEL_INDEX_OBJ> LABEL_INDEX;
std::wstring to_wstring(const char* _input)
{
	std::wstring output;
	std::string input = _input;
	output.assign(input.begin(), input.end());
	return output;
};
std::wstring to_wstring(std::string _input)
{
	std::wstring output;
	output.assign(_input.begin(), _input.end());
	return output;
};

void WriteLabelIndexFile(void);
void myReplace(std::wstring& str,
	const std::wstring& oldStr,
	const std::wstring& newStr);

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
	LoadTXTIntoVector("./charnames.txt", CHARACTER_NAMES);
	LoadTXTIntoVector("./charnames_fixed.txt", CHARACTER_NAMES_FIXED);

	if (loadscriptfiletext == true)
	{
		std::vector<std::wstring> SCRIPT_FILE_NAMES;
		LoadTXTIntoVector("./scriptfiles.txt", SCRIPT_FILE_NAMES);
		for (size_t scrp = 0; scrp < SCRIPT_FILE_NAMES.size(); scrp++)
		{
			LABELS.clear();
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

void WriteLabelIndexFile(void)
{
	std::wofstream textOutput(L"./output/LabelIndex.lua");
	textOutput.imbue(std::locale(std::locale::empty(), new std::codecvt_utf8<wchar_t, 0x10ffff>));

	if (textOutput)
	{
		textOutput << L"-- This file was automatically generated by RPYtoLua v" << VERSION_MAJOR << L"." << VERSION_MINOR << L"." << VERSION_PATCH;
		textOutput << L"\n-- For use with March22-Lua\n-- By Sam Lynch\n\n";
		textOutput << L"LABELINDEX = {};\n\n";
		for (size_t i = 0; i < LABEL_INDEX.size(); i++)
		{
			myReplace(LABEL_INDEX.at(i).script_name, L".rpy", L"");
			myReplace(LABEL_INDEX.at(i).script_name, L".lua", L""); // just in case
			LABEL_INDEX.at(i).script_name += L".lua";
			textOutput << L"LABELINDEX[\"" << LABEL_INDEX.at(i).label_name << L"\"] = \"" << LABEL_INDEX.at(i).script_name << "\";\n";
		}
		textOutput.close();
	}
	else
	{
		printf("Failed to create index file!\n");
	}

	return;
}

// http://stackoverflow.com/questions/1494399/how-do-i-search-find-and-replace-in-a-standard-string
void myReplace(std::wstring& str,
	const std::wstring& oldStr,
	const std::wstring& newStr)
{
	std::wstring::size_type pos = 0u;
	while ((pos = str.find(oldStr, pos)) != std::wstring::npos) {
		str.replace(pos, oldStr.length(), newStr);
		pos += newStr.length();
	}
}

std::wstring CreateDecision(size_t& pos, std::vector<std::wstring>& _vector)
{
	DECISION newDec;
	size_t endpos;
	for(size_t i = pos; i < _vector.size(); i++)
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
			_vector.at(i).erase(0, splitString.at(0).size()+1);
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

int LoadTXTIntoVector(const char* _file, std::vector<std::wstring>& _vector)
{
	std::wifstream inputFile;
	inputFile.open(_file);

	if (!inputFile) {
		printf("Failed to load: %s\n", _file);
		return -1;
	};

	std::wstring line;
	while (std::getline(inputFile, line))
	{
		_vector.push_back(line);
	};

	inputFile.close();
	return 0;
};

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
		if ( !(i == (_char.sprites.size() - 1) ) )
		{
			result += L",\n";
		}
	}
	result += L"});\n\n";

	return result;
}

void WriteCompiledScript(std::wstring _filename, std::vector<std::wstring>& _backgrounds, std::vector<std::wstring>& _lines, std::vector<std::wstring>& _sfx, std::vector<Character>& _characters, std::vector<std::wstring>& _music)
{
	_filename += L".lua";
	myReplace(_filename, L".rpy", L"");
	_filename.insert(0, L"./output/");
	std::wofstream textOutput(_filename);
	_filename.erase(0, 9);
	textOutput.imbue(std::locale(std::locale::empty(), new std::codecvt_utf8<wchar_t, 0x10ffff>));

	textOutput << L"-- This file was automatically generated by RPYtoLua v" << VERSION_MAJOR << L"." << VERSION_MINOR << L"." << VERSION_PATCH; 
	textOutput << L"\n-- For use with March22-Lua\n-- By Sam Lynch\n\n";
	textOutput << L"dofile(\"app0:/LUA_CLASSES/Line.lua\");\ndofile(\"app0:/March22_background.lua\");\n\n";
	textOutput << L"\nLOADEDSFX = {};\nLOADEDMUSIC = {};\nLABEL_POSITIONS = {};\n";
	textOutput << L"March22.CURRENTSCRIPTNAME = \"" << _filename << L"\";\n\n";

	for (size_t i = 0; i < LABELS.size(); i++)
	{
		textOutput << L"LABEL_POSITIONS[\"" << LABELS.at(i).name << L"\"] = " << LABELS.at(i).position << L";\n";
	}
	textOutput << L"\n\n";

	float percentage = 0.0f;
	for (size_t i = 0; i < _characters.size(); i++)
	{
		percentage = ((((float)i / (float)_characters.size()) * (float)20));
		textOutput << L"UpdateLoadingProgress(" << (int)percentage << L");\n";
		textOutput << GenerateCharacterArray(_characters.at(i));
	}

	for (size_t i = 0; i < _backgrounds.size(); i++)
	{
		percentage = ((((float)i / (float)_backgrounds.size()) * (float)40) + 20);
		textOutput << L"UpdateLoadingProgress(" << (int)percentage << L");\n";
		textOutput << _backgrounds.at(i);
	}
	for (size_t i = 0; i < _sfx.size(); i++)
	{
		percentage = ((((float)i / (float)_sfx.size()) * (float)20) + 60);
		textOutput << L"UpdateLoadingProgress(" << (int)percentage << L");\n";
		textOutput << _sfx.at(i);
	}
	for (size_t i = 0; i < _music.size(); i++)
	{
		percentage = ((((float)i / (float)_music.size()) * (float)20) + 80);
		textOutput << L"UpdateLoadingProgress(" << (int)percentage << L");\n";
		textOutput << _music.at(i);
	}

	textOutput << "\nACTIVE_SCRIPT = {\n";
	for (size_t i = 0; i < _lines.size()-1; i++)
	{
		textOutput << "	" << _lines.at(i);
	}

	// This is hack to stop a comma appearing at the end of the table
	std::wstring temp = _lines.at(_lines.size() - 1);
	temp.pop_back();
	temp.pop_back();
	textOutput << "	" << temp << '\n';

	textOutput << "};\n";
	textOutput << L"UpdateLoadingProgress(100);\n" << L"SIZE_OF_ACTIVE_SCRIPT = " << _lines.size() << L";\n";
	textOutput.close();
	return;
}

std::wstring CreateLuaFunction(LUAFUNCTION _function, std::wstring _param, bool _newline, bool _prefixsuffix, std::wstring _param2, std::wstring _param3, std::wstring _param4, std::wstring _param5)
{
	std::wstring result = L"";
	if (_prefixsuffix)
	{
		result += L"function() ";
	};

	switch (_function)
	{
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
			result += std::wstring(L"March22.ClearCharacter(\""+ _param + L"\");");
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
	while (exit == false || pos < (_pos+8))
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

std::vector<std::wstring> GetLinesFromVector(std::vector<std::wstring>& _vector, std::wstring _filename)
{
	std::wstring COLOR = L"March22.WHITE_COLOUR, ";
	std::vector<std::wstring> result;

	std::wstring* ACTIVE_THING;

	enum TYPE {UNKNOWN, PLAYSOUND, PLAYMUSIC, CHANGEBACKGROUND, ADDSPRITE, CLEARSPRITE, SPEECH, NARRATIVE, LABEL_TYPE, NEW_DECISION};

	for (size_t i = 0; i < _vector.size(); i++)
	{
		ACTIVE_THING = &_vector.at(i);
		TYPE type = UNKNOWN;
		std::vector<std::wstring> splitString;
		SplitString(_vector.at(i), splitString, ' ');
		std::wstring tempStr = L"Line.new(";
		if (splitString.at(0).size() > 0 && splitString.at(0).at(0) == L'\"') // narrative
		{
			size_t n = std::count(_vector.at(i).begin(), _vector.at(i).end(), '\"');
			if (n > 2)
			{
				type = SPEECH;
				tempStr += splitString.at(0);
			}
			else
			{
				tempStr += L"\"\"";
				type = NARRATIVE;
				//tempStr += _vector.at(i);
			};
		}
		else
		{
			if (splitString.at(0) == L"play")
			{
				if (splitString.at(1) == L"sound")
				{
					type = PLAYSOUND;
				}
				else if(splitString.at(1) == L"music")
				{
					type = PLAYMUSIC;
				}
			}
			else if (splitString.at(0) == L"show")
			{
				type = ADDSPRITE;
			}
			else if (splitString.at(0) == L"hide")
			{
				type = CLEARSPRITE;
			}
			else if (splitString.at(0) == L"scene")
			{
				type = CHANGEBACKGROUND;
			}
			else if (splitString.at(0) == L"label")
			{
				type = LABEL_TYPE;
			}
			else if (splitString.at(0) == L"menu:")
			{
				type = NEW_DECISION;
			}
			
			bool characterNameFound = false;
			for (size_t chr = 0; chr < CHARACTER_NAMES.size(); chr++)
			{
				if (splitString.at(0) == CHARACTER_NAMES.at(chr))
				{
					characterNameFound = true;
					type = SPEECH;
					tempStr += (L"\""+CHARACTER_NAMES_FIXED.at(chr)+L"\"");
				}
			}
			if(!characterNameFound) tempStr += L"\"\"";
		}
		tempStr += L", ";
		tempStr += COLOR;
		if (type == NARRATIVE)
		{
			tempStr += _vector.at(i);
		}
		else if (type == SPEECH)
		{
			std::wstring temp = _vector.at(i);
			temp.erase(0, splitString.at(0).size() + 1);
			temp.pop_back();
			tempStr += (L"\"\\"+temp+L"\\\"\"");
		}
		else
		{
			tempStr += L"\"\"";
		}

		if (type == PLAYSOUND)
		{
			tempStr += L", ";
			tempStr += CreateLuaFunction(LUAFUNCTION::PLAY_SOUND, splitString.at(2), true, true);
			tempStr += L"),\n";
		}
		else if (type == PLAYMUSIC)
		{
			tempStr += L", ";
			tempStr += CreateLuaFunction(LUAFUNCTION::PLAY_MUSIC, splitString.at(2), true, true);
			tempStr += L"),\n";
		}
		else if (type == NEW_DECISION)
		{
			tempStr += L", ";
			tempStr += CreateDecision(i, _vector);
			//ACTIVE_THING = &_vector.at(i);
			i--;
			tempStr += L"),\n";
			// std::wstring CreateDecision(size_t& pos, std::vector<std::wstring>& _vector)
		}
		else if (type == LABEL_TYPE)
		{
			tempStr += L", ";
			splitString.at(1).pop_back();

			// REMOVING en_ FROM LABEL NAME
				splitString.at(1).erase(0, 3);
			// REMOVING en_ FROM LABEL NAME

			tempStr += L"function() --[[ " + splitString.at(1) + L" ]] end";
			tempStr += L"),\n";
			LABEL templabel;
			templabel.name = splitString.at(1);
			templabel.position = result.size() + 1; // lua starts at 1

			LABEL_INDEX_OBJ tempindex;
			tempindex.label_name = templabel.name;
			tempindex.script_name = _filename;
			LABEL_INDEX.push_back(tempindex);

			LABELS.push_back(templabel);
		}
		else if (type == CHANGEBACKGROUND)
		{
			tempStr += L", ";
			if (splitString.size() >= 3)
			{
				tempStr += CreateLuaFunction(LUAFUNCTION::CHANGE_BACKGROUND, splitString.at(2), true, true);
			}
			else
			{
				tempStr += CreateLuaFunction(LUAFUNCTION::CHANGE_BACKGROUND, splitString.at(1), true, true);
			}
			tempStr += L"),\n";
		}
		else if(type == TYPE::ADDSPRITE)
		{
			//splitString.at(1)
			// show muto normal at center
			if (isCharacter(splitString.at(1)))
			{
				std::wstring animation = CheckForAnimation(_vector, i);
				if (animation == L"")
				{
					if (splitString.size() > 3 && splitString.at(3) == L"at")
					{
						tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::NEW_CHARACTER, splitString.at(1), true, true, splitString.at(2), splitString.at(4)));
					}
					else
					{
						tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::NEW_CHARACTER, splitString.at(1), true, true, splitString.at(2)));
					}
				}
				else
				{
					if (splitString.size() > 3 && splitString.at(3) == L"at")
					{
						tempStr += (L", " + CreateLuaFunction(
							LUAFUNCTION::NEW_CHARACTER, 
							splitString.at(1), 
							false, 
							true, 
							splitString.at(2), 
							splitString.at(4),
							animation
						));
					}
					else
					{
						tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::NEW_CHARACTER, splitString.at(1), false, true, splitString.at(2),animation));
					}
				}
				tempStr += L"),\n";
			}
			else
			{
				tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::CHANGELINE, L"", true, true) + L"),\n");
			}
		}
		else if (type == TYPE::CLEARSPRITE)
		{
			if (isCharacter(splitString.at(1)))
			{
				tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::CLEAR_CHARACTER, splitString.at(1), true, true) + L"),\n");
			}
			else
			{
				tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::CHANGELINE, L"", true, true) + L"),\n");
			}
		}
		else if (type == TYPE::SPEECH || type == TYPE::NARRATIVE)
		{
			//nothing
			tempStr += L"),\n";
		}
		else
		{
			tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::CHANGELINE, L"", true, true) + L"),\n");
		};
		result.push_back(tempStr);
	};
	return result;
}

std::vector<Character> GetLoadedCharactersFromVector(std::vector<std::wstring>& _vector)
{
	std::vector<Character> result;

	for (size_t i = 0; i < _vector.size(); i++)
	{
		//show muto smile
		std::vector<std::wstring> splitString;
		SplitString(_vector.at(i), splitString, ' ');

		bool characterExists = false;
		bool emoteExists = false;

		if (splitString.at(0) == L"show")
		{
			// check if character name
			if ( isCharacter(splitString.at(1) ) )
			{
				for (size_t res = 0; res < result.size(); res++)
				{
					// if name already exists
					if (result.at(res).name == splitString.at(1))
					{
						characterExists = true;
						// check if emotion already exists
						for (size_t emo = 0; emo < result.at(res).sprites.size(); emo++)
						{
							if (result.at(res).sprites.at(emo) == splitString.at(2))
							{
								// emotion + character already exists, break it
								emoteExists = true;
								break;
							}
						}

						// emotion doesn't exist!
						if (emoteExists == false)
						{
							result.at(res).sprites.push_back(splitString.at(2));
							emoteExists = true;
						};
						// emotion doesn't exist!

						if (characterExists) break;
					}
				}
				// character doesn't exist!
				if (characterExists == false)
				{
					Character newChar;
					newChar.name = splitString.at(1);
					newChar.sprites.push_back(splitString.at(2));
					result.push_back(newChar);
				};
				// character doesn't exist!
			}
		}
	};

	return result;
};

std::vector<std::wstring> GetLoadedMusicFromVector(std::vector<std::wstring>& _vector)
{
	std::vector<std::wstring> result;
	std::vector<std::wstring> loadedMUSTemp;

	for (size_t i = 0; i < _vector.size(); i++)
	{
		if (_vector.at(i).size() < 4)
		{
			//do nothing
		}
		else
		{
			std::wstring isScene = _vector.at(i).substr(0, 4);
			if (isScene == L"play")
			{
				std::vector<std::wstring> splitStr;
				SplitString(_vector.at(i), splitStr, ' ');
				std::wstring sfxEntry = L"";

				// March22 handles events and backgrounds the same way
				if (splitStr.at(1) == L"music")
				{
					bool alreadyLoaded = false;
					for (size_t ch = 0; ch < loadedMUSTemp.size(); ch++)
					{
						if (loadedMUSTemp.at(ch) == splitStr.at(2))
						{
							alreadyLoaded = true;
							break;
						};
					}
					if (!alreadyLoaded)
					{
						sfxEntry += L"LOADEDMUSIC[\"";
						sfxEntry += splitStr.at(2);
						sfxEntry += L"\"] = Sound.openOgg(\"app0:/music/";
						sfxEntry += splitStr.at(2);
						sfxEntry += L".ogg\");\n";
						result.push_back(sfxEntry);
						loadedMUSTemp.push_back(splitStr.at(2));
					};
				}
			};
		};
	}

	return result;
}

std::vector<std::wstring> GetLoadedSFXFromVector(std::vector<std::wstring>& _vector)
{
	std::vector<std::wstring> result;
	std::vector<std::wstring> loadedSFXTemp;

	for (size_t i = 0; i < _vector.size(); i++)
	{
		if (_vector.at(i).size() < 4)
		{
			//do nothing
		}
		else
		{
			std::wstring isScene = _vector.at(i).substr(0, 4);
			if (isScene == L"play")
			{
				std::vector<std::wstring> splitStr;
				SplitString(_vector.at(i), splitStr, ' ');
				std::wstring sfxEntry = L"";

				// March22 handles events and backgrounds the same way
				if (splitStr.at(1) == L"sound")
				{
					bool alreadyLoaded = false;
					for (size_t ch = 0; ch < loadedSFXTemp.size(); ch++)
					{
						if (loadedSFXTemp.at(ch) == splitStr.at(2))
						{
							alreadyLoaded = true;
							break;
						};
					}
					if (!alreadyLoaded)
					{
						sfxEntry += L"LOADEDSFX[\"";
						sfxEntry += splitStr.at(2);
						sfxEntry += L"\"] = Sound.openOgg(\"app0:/sfx/";
						sfxEntry += splitStr.at(2);
						sfxEntry += L".ogg\");\n";
						result.push_back(sfxEntry);
						loadedSFXTemp.push_back(splitStr.at(2));
					};
				}
			};
		};
	}

	return result;
}

std::vector<std::wstring> GetLoadedBackgroundsFromVector(std::vector<std::wstring>& _vector)
{
	//LOADEDBACKGROUNDS = {};
	//LOADEDBACKGROUNDS["op_snowywoods"] = Graphics.loadImage("app0:/graphics/backgrounds/op_snowywoods.jpg");
	std::vector<std::wstring> result;
	std::vector<std::wstring> loadedBackgroundsTemp;

	for (size_t i = 0; i < _vector.size(); i++)
	{
		std::wstring isScene = _vector.at(i).substr(0, 5);
		if (isScene == L"scene")
		{
			std::vector<std::wstring> splitStr;
			SplitString(_vector.at(i), splitStr, ' ');
			std::wstring backgroundEntry = L"";

			// March22 handles events and backgrounds the same way
			if (splitStr.at(1) == L"ev" || splitStr.at(1) == L"bg") 
			{
				bool alreadyLoaded = false;
				for (size_t ch = 0; ch < loadedBackgroundsTemp.size(); ch++)
				{
					if (loadedBackgroundsTemp.at(ch) == splitStr.at(2))
					{
						alreadyLoaded = true;
						break;
					};
				}
				if (!alreadyLoaded)
				{
					backgroundEntry += L"LoadBackground(\"";
					backgroundEntry += splitStr.at(2);
					backgroundEntry += L"\");\n";
					result.push_back(backgroundEntry);
					loadedBackgroundsTemp.push_back(splitStr.at(2));
				};
			}
			else if (splitStr.at(1) == L"bl") // black
			{

			}
			else if (splitStr.at(1) == L"wh") // white
			{

			};
		};
	}

	return result;
}

unsigned int SplitString(const std::wstring &txt, std::vector<std::wstring> &strs, char ch)
{
	unsigned int pos = txt.find(ch);
	unsigned int initialPos = 0;
	strs.clear();

	// Decompose statement
	while (pos != std::string::npos) {
		strs.push_back(txt.substr(initialPos, pos - initialPos + 1));
		initialPos = pos + 1;

		pos = txt.find(ch, initialPos);
	}

	// Add the last one
	strs.push_back(txt.substr(initialPos, std::min(pos, txt.size()) - initialPos + 1));

	for (size_t i = 0; i < strs.size(); i++)
	{
		strs.at(i).erase(std::remove_if(strs.at(i).begin(), strs.at(i).end(), iswspace), strs.at(i).end());
	}

	return strs.size();
};

int LoadScriptIntoVector(const wchar_t* _input, std::vector<std::wstring>& _vector)
{
	// Load file
	std::locale ulocale(std::locale(), new std::codecvt_utf8<wchar_t>);
	std::wifstream inputFile;
	inputFile.open(_input);
	inputFile.imbue(ulocale);

	// Check file
	if (!inputFile) {
		wprintf(L"Failed to load: %s\n", _input);
		return -1;
	};

	// Load meaningful lines into vector
	std::wstring line;
	while (std::getline(inputFile, line))
	{
		if (line != L"") {
			//std::wstringstream iss(line);
			//::wstring item;
			//iss >> item;

			_vector.push_back(line);
		};
	};
	inputFile.seekg(0, inputFile.beg);

	// Cleanup
	inputFile.close();
	return 0;
};