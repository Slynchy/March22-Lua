#pragma once

#include <string>
#include <vector>

class Label2
{
	public:
		struct LABEL
		{
			std::wstring name;
			unsigned int position; // in lua, so starts at 1
		};

		struct LABEL_INDEX_OBJ
		{
			std::wstring script_name;
			std::wstring label_name;
			Label2::LABEL_INDEX_OBJ()
			{
				script_name = L"";
				label_name = L"";
			}
		};
		static std::vector<Label2::LABEL> Label2::LABELS;
		static std::vector<Label2::LABEL_INDEX_OBJ> Label2::LABEL_INDEX;
};