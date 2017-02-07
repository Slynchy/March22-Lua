#pragma once

#include <string>
#include <vector>

int LoadTXTIntoVector(const char* _file, std::vector<std::wstring>& _vector);

int LoadScriptIntoVector(const wchar_t* _input, std::vector<std::wstring>& _vector);

unsigned int SplitString(const std::wstring &txt, std::vector<std::wstring> &strs, char ch);

void WriteLabelIndexFile(void);

// http://stackoverflow.com/questions/1494399/how-do-i-search-find-and-replace-in-a-standard-string
void myReplace(std::wstring& str,
	const std::wstring& oldStr,
	const std::wstring& newStr);