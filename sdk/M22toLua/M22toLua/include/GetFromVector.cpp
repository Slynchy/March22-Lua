#include "GetFromVector.h"
#include "FileOp.h"
#include <LuaOp.h>
#include <Label.h>

std::vector<std::wstring> GetLoadedBackgroundsFromVector(std::vector<std::wstring>& _vector)
{
	std::vector<std::wstring> result;
	std::vector<std::wstring> loadedBackgroundsTemp;

	for (size_t i = 0; i < _vector.size(); i++)
	{
		std::vector<std::wstring> splitStr;
		SplitString(_vector.at(i), splitStr, ' ');
		if (splitStr.front() == L"DrawBackground")
		{
			std::wstring backgroundEntry = L"";

			bool alreadyLoaded = false;
			for (size_t ch = 0; ch < loadedBackgroundsTemp.size(); ch++)
			{
				if (loadedBackgroundsTemp.at(ch) == splitStr.at(1))
				{
					alreadyLoaded = true;
					break;
				};
			}
			if (!alreadyLoaded)
			{
				backgroundEntry += L"LoadBackground(\"";
				backgroundEntry += splitStr.at(1);
				backgroundEntry += L"\");\n";
				result.push_back(backgroundEntry);
				loadedBackgroundsTemp.push_back(splitStr.at(1));
			};
		}
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
			std::vector<std::wstring> splitStr;
			SplitString(_vector.at(i), splitStr, ' ');
			if (splitStr.front() == L"PlaySound")
			{
				std::wstring sfxEntry = L"";
				bool alreadyLoaded = false;
				for (size_t ch = 0; ch < loadedSFXTemp.size(); ch++)
				{
					if (loadedSFXTemp.at(ch) == splitStr.at(1))
					{
						alreadyLoaded = true;
						break;
					};
				}
				if (!alreadyLoaded)
				{
					sfxEntry += L"LOADEDSFX[\"";
					sfxEntry += splitStr.at(1);
					sfxEntry += L"\"] = Sound.openOgg(\"app0:/sfx/";
					sfxEntry += splitStr.at(1);
					sfxEntry += L".ogg\");\n";
					result.push_back(sfxEntry);
					loadedSFXTemp.push_back(splitStr.at(1));
				};
			}
		};
	}

	return result;
}

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
			std::vector<std::wstring> splitStr;
			SplitString(_vector.at(i), splitStr, ' ');
			if (splitStr.front() == L"PlayMusic")
			{
				std::wstring sfxEntry = L"";

				bool alreadyLoaded = false;
				for (size_t ch = 0; ch < loadedMUSTemp.size(); ch++)
				{
					if (loadedMUSTemp.at(ch) == splitStr.at(1))
					{
						alreadyLoaded = true;
						break;
					};
				}
				if (!alreadyLoaded)
				{
					sfxEntry += L"LOADEDMUSIC[\"";
					sfxEntry += splitStr.at(1);
					sfxEntry += L"\"] = Sound.openOgg(\"app0:/music/";
					sfxEntry += splitStr.at(1);
					sfxEntry += L".ogg\");\n";
					result.push_back(sfxEntry);
					loadedMUSTemp.push_back(splitStr.at(1));
				};
			}
		};
	}

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
			if (isCharacter(splitString.at(1)))
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

	RemoveSSFromEmotionName(result);

	return result;
};

void RemoveSSFromEmotionName(std::vector<Character>& _array)
{
	for (auto chara = 0; chara < _array.size(); chara++)
	{
		for (auto emote = 0; emote < _array.at(chara).sprites.size(); emote++)
		{
			myReplace(_array.at(chara).sprites.at(emote), L"_ss", L"");
		}
	}
}

std::vector<std::wstring> GetLinesFromVector(std::vector<std::wstring>& _vector, std::wstring _filename)
{
	std::wstring COLOR = L"March22.WHITE_COLOUR, ";
	std::vector<std::wstring> result;

	std::wstring* ACTIVE_THING;

	enum TYPE { UNKNOWN, PLAYSOUND, FADETOBLACKFANCY, PLAYMUSIC, CHANGEBACKGROUND, ADDSPRITE, CLEARSPRITE, COMMENT,SPEECH, NARRATIVE, LABEL_TYPE, NEW_DECISION, SET_ACTV_TRANS, CLEAR_NVL, DARKEN_SCREEN, SHOW_NVL, HIDE_NVL, NEW_PAGE };

	for (size_t i = 0; i < _vector.size(); i++)
	{
		ACTIVE_THING = &_vector.at(i);
		TYPE type = UNKNOWN;

		myReplace(_vector.at(i), L"\\n", L"");

		std::vector<std::wstring> splitString;
		SplitString(_vector.at(i), splitString, ' ');
		std::wstring tempStr = L"Line.new(";
		if (splitString.at(0) == L"PlayMusic")
		{
			type = PLAYMUSIC;
		}
		else if (splitString.at(0) == L"NewPage")
		{
			type = NEW_PAGE;
		}
		else if (splitString.at(0) == L"FadeToBlackFancy")
		{
			type = FADETOBLACKFANCY;
		}
		else if (splitString.at(0).size() > 1 && (splitString.at(0).at(0) == L'/' && splitString.at(0).at(1) == L'/'))
		{
			type = COMMENT;
		}
		else if (splitString.at(0) == L"DarkenScreen")
		{
			type = DARKEN_SCREEN;
		}
		else if (splitString.at(0) == L"SetActiveTransition")
		{
			type = SET_ACTV_TRANS;
		}
		else if (splitString.at(0) == L"PlaySting")
		{
			type = ADDSPRITE;
		}
		else if (splitString.at(0) == L"DrawCharacter")
		{
			type = ADDSPRITE;
		}
		else if (splitString.at(0) == L"ClearCharacters")
		{
			type = CLEARSPRITE;
		}
		else if (splitString.at(0) == L"DrawBackground")
		{
			type = CHANGEBACKGROUND;
		}
		else if (splitString.at(0).size() > 2 && (splitString.at(0).at(0) == L'-' && splitString.at(0).at(1) == L'-'))
		{
			type = LABEL_TYPE;
		}
		else if (splitString.at(0) == L"MakeDecision")
		{
			type = NEW_DECISION;
		}
		else if (splitString.at(0) == L"nvl")
		{
			if (splitString.at(1) == L"show")
			{
				type = SHOW_NVL;
			}
			else if (splitString.at(1) == L"clear")
			{
				type = CLEAR_NVL;
			}
			else
			{
				type = HIDE_NVL;
			}
		}
		else
		{
			type = NARRATIVE;
		}
		tempStr += L"\"\"";
		tempStr += L", ";
		tempStr += COLOR;


		if (type == NARRATIVE)
		{
			tempStr += L"\"";
			myReplace(_vector.at(i), L"\"", L"\\\"");
			tempStr += _vector.at(i);
			tempStr += L"\"";
		}
		else if (type == SPEECH)
		{
			std::wstring temp = _vector.at(i);
			temp.erase(0, splitString.at(0).size() + 1);
			temp.pop_back();
			tempStr += (L"\"\\" + temp + L"\\\"\"");
		}
		else
		{
			tempStr += L"\"\"";
		}

		if (type == PLAYSOUND)
		{
			tempStr += L", ";
			tempStr += CreateLuaFunction(LUAFUNCTION::PLAY_SOUND, splitString.at(1), true, true);
			tempStr += L"),\n";
		}
		else if (type == PLAYMUSIC)
		{
			tempStr += L", ";
			tempStr += CreateLuaFunction(LUAFUNCTION::PLAY_MUSIC, splitString.at(1), true, true);
			tempStr += L"),\n";
		}
		else if (type == NEW_DECISION)
		{
			tempStr += L", ";
			//todo
			//tempStr += CreateDecision(i, _vector);
			i--;
			tempStr += L"),\n";
		}
		else if (type == LABEL_TYPE)
		{
			tempStr += L", ";
			
			//splitString.front().erase(splitString.front().at(0));
			//splitString.front().erase(splitString.front().at(0));
			splitString.at(0).erase(splitString.at(0).begin(), splitString.at(0).begin()+2);
			//splitString.at(1).pop_back();

			// REMOVING en_ FROM Label2::LABEL NAME
			//splitString.at(1).erase(0, 3);
			// REMOVING en_ FROM Label2::LABEL NAME

			tempStr += L"function() --[[ " + splitString.at(0) + L" ]] end";
			tempStr += L"),\n";
			Label2::LABEL templabel;
			templabel.name = splitString.at(0);
			templabel.position = result.size() + 1; // lua starts at 1

			Label2::LABEL_INDEX_OBJ tempindex;
			tempindex.label_name = templabel.name;
			tempindex.script_name = _filename;
			Label2::LABEL_INDEX.push_back(tempindex);

			Label2::LABELS.push_back(templabel);
		}
		else if (type == CHANGEBACKGROUND)
		{
			tempStr += L", ";
			tempStr += CreateLuaFunction(LUAFUNCTION::CHANGE_BACKGROUND, splitString.at(1), true, true);
			tempStr += L"),\n";
		}
		else if (type == TYPE::ADDSPRITE)
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
						tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::NEW_CHARACTER, splitString.at(1), false, true, splitString.at(2), animation));
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
		else if (type == TYPE::CLEAR_NVL)
		{
			//nothing
			tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::CLEAR_NVL, L"", true, true) + L"),\n");
		}
		else if (type == TYPE::NEW_PAGE)
		{
			//nothing
			tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::NEW_PAGE, L"", true, true) + L"),\n");
		}
		else if (type == TYPE::DARKEN_SCREEN)
		{
			//nothing
			tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::COMMENT, L"", true, true) + L"),\n");
		}
		else if (type == TYPE::COMMENT)
		{
			//nothing
			tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::COMMENT, L"", true, true) + L"),\n");
		}
		else if (type == TYPE::SET_ACTV_TRANS)
		{
			//nothing
			tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::COMMENT, L"", true, true) + L"),\n");
		}
		else if (type == TYPE::HIDE_NVL)
		{
			//nothing
			tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::HIDE_NVL, L"", true, true) + L"),\n");
		}
		else if (type == TYPE::FADETOBLACKFANCY)
		{
			//nothing
			tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::COMMENT, L"", true, true) + L"),\n");
		}
		else if (type == TYPE::SHOW_NVL)
		{
			//nothing
			tempStr += (L", " + CreateLuaFunction(LUAFUNCTION::SHOW_NVL, L"", true, true) + L"),\n");
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