#pragma once

#include <vector>
#include <string>
#include <Character.h>

std::vector<std::wstring> GetLoadedBackgroundsFromVector(std::vector<std::wstring>& _vector);

std::vector<std::wstring> GetLoadedSFXFromVector(std::vector<std::wstring>& _vector);

std::vector<std::wstring> GetLoadedMusicFromVector(std::vector<std::wstring>& _vector);

std::vector<Character> GetLoadedCharactersFromVector(std::vector<std::wstring>& _vector);

void RemoveSSFromEmotionName(std::vector<Character>& _array);

std::vector<std::wstring> GetLinesFromVector(std::vector<std::wstring>& _vector, std::wstring _filename = L"");