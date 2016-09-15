
#include <string>
#include <sstream>
#include <fstream>
#include <vector>
#include <algorithm>

// http://stackoverflow.com/questions/1494399/how-do-i-search-find-and-replace-in-a-standard-string
void myReplace(std::string& str,
	const std::string& oldStr,
	const std::string& newStr)
{
	std::string::size_type pos = 0u;
	while ((pos = str.find(oldStr, pos)) != std::string::npos) {
		str.replace(pos, oldStr.length(), newStr);
		pos += newStr.length();
	}
}

unsigned int SplitString(const std::string &txt, std::vector<std::string> &strs, char ch)
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

void removeCharsFromString(std::string &str, std::string charsToRemove) {
	std::string::size_type i = str.find(charsToRemove);

	if (i != std::string::npos)
		str.erase(i, charsToRemove.length());
}

enum IF_ELSE_END
{
	IF,
	ELSE,
	END,
	NEITHER
};

struct LABEL_LINE
{
	std::string str;
	unsigned int indentation;
	IF_ELSE_END isIfStatement;
	LABEL_LINE()
	{
		indentation = 0;
		isIfStatement = NEITHER;
	}
};

struct LABEL
{
	std::string name;
	std::vector<LABEL_LINE> contents;
};

std::vector<std::string> VARIABLES;

void WriteTextFile(std::vector<LABEL>& _labels);

int main()
{
	std::vector<LABEL> testoutput;
	std::ifstream testfile("test.py");

	int temp = std::count(std::istreambuf_iterator<char>(testfile),
		std::istreambuf_iterator<char>(), '\n');
	temp++;

	testfile.seekg(0);

	int currentLabel = -1;

	for (int i = 0; i < temp; i++)
	{
		std::string tempstr;
		std::getline(testfile, tempstr);
		myReplace(tempstr, "    ", "\t");
		if (tempstr != "")
		{
			std::vector<std::string> splitstr;
			myReplace(tempstr, "+=", "+= ");
			myReplace(tempstr, "-=", "-= ");
			SplitString(tempstr, splitstr, ' ');
			if (splitstr.at(0) == "label")
			{
				LABEL templabel;
				removeCharsFromString(splitstr.at(1), ":");
				templabel.name = splitstr.at(1);
				testoutput.push_back(templabel);
				currentLabel++;
			}
			else
			{
				//

				if (splitstr.at(0) == "$")
				{
					bool matchfound = false;
					for (size_t var = 0; var < VARIABLES.size(); var++)
					{
						if (splitstr.at(1) == VARIABLES.at(var))
						{
							matchfound = true;
							break;
						}
					}
					if (matchfound != true)
					{
						VARIABLES.push_back(splitstr.at(1));
					}
				}
				removeCharsFromString(tempstr, "$");
				removeCharsFromString(tempstr, "call ");
				myReplace(tempstr, " (", "("); 
				myReplace(tempstr, "is_h=True", "true"); 
				myReplace(tempstr, "is_end=True", "true");
				myReplace(tempstr, "is_h=False", "false");
				myReplace(tempstr, "is_end=False", "false");
				myReplace(tempstr, "False", "false");
				myReplace(tempstr, "True", "true");
				//myReplace(tempstr, "path_end()", "path_end");

				LABEL_LINE templine;
				size_t indentcount = std::count(tempstr.begin(), tempstr.end(), '\t');
				templine.indentation = indentcount;

				if (splitstr.at(0) == "jump_out")
				{
					myReplace(tempstr, splitstr.at(1), "(\""+ splitstr.at(1) + "\")");
				}
				else if (splitstr.at(0) == "if")
				{
					myReplace(tempstr, ":", " then");
					templine.isIfStatement = IF;
				}
				else if (splitstr.size() > 1 && splitstr.at(1) == "path_end")
				{
					//myReplace(tempstr, "path_end", "path_end");
				} 
				else if (splitstr.at(0) == "else:" || splitstr.at(0) == "elif")
				{
					myReplace(tempstr, ":", "");
					if (splitstr.at(0) == "elif")
					{
						myReplace(tempstr, "elif", "elseif"); 
						tempstr += " then";
					}
					templine.isIfStatement = ELSE;
				}
				else if (splitstr.size() >= 3 && (splitstr.at(2) == "+=" || splitstr.at(2) == "-="))
				{
					myReplace(tempstr, "+=", "= " + splitstr.at(1) + " +");
					myReplace(tempstr, "-=", "= " + splitstr.at(1) + " -");
				}

				templine.str = tempstr;
				testoutput.at(currentLabel).contents.push_back(templine);
			};
		}
	}

	testfile.close();

	//done

	WriteTextFile(testoutput);

	return 0;
}

std::string MultiplyString(std::string input, int _mult)
{
	std::string output;
	for (int i = 0; i < _mult; i++)
	{
		output += input;
	}
	return output;
}

std::string FixIfStatement(LABEL& _label, size_t& pos)
{
	std::stringstream output;

	output << "\n" << _label.contents.at(pos).str << "\n";

	size_t indentation = _label.contents.at(pos).indentation;

	bool success = false;

	for (++pos; pos < _label.contents.size(); pos++)
	{
		std::vector<std::string> splitstr;
		SplitString(_label.contents.at(pos).str, splitstr, ' ');

		// if current indentation is higher than recorded, then it's still part of parenthesis
		if (_label.contents.at(pos).indentation > indentation)
		{
			if (_label.contents.at(pos).isIfStatement == IF)
			{
				//its a nested if statement, gotta correct it
				output << FixIfStatement(_label, pos);
				//pos--;
			}
			else
			{
				output << "\n" << _label.contents.at(pos).str;
			}
		}
		else
		{
			// it is not greater than so it must be equal to or less than.
			// in other words, the end parenthesis is here unless it is an else statement.
			if (_label.contents.at(pos).isIfStatement == ELSE && _label.contents.at(pos).indentation == indentation)
			{
				output << "\n" << _label.contents.at(pos).str;
				//pos++;
			}
			else
			{
				output << "\n" << MultiplyString("\t", indentation) << "end";
				success = true;
				break;
			}
		}

	}

	if (success == false)
	{
		output << "\n" << MultiplyString("\t", indentation) << "end";
	}

	return output.str();
}

void WriteTextFile(std::vector<LABEL>& _labels)
{

	std::stringstream output;//("output.lua");
	output << "-- This file was automatically generated by RPYtoLua";
	output << "\n-- For use with March22-Lua\n-- By Sam Lynch\n\n";
	output << "LABELS = {};\n\n";

	for (size_t i = 0; i < VARIABLES.size(); i++)
	{
		output << VARIABLES.at(i) << " = 0;\n";
	}

	output << "\n\n";

	unsigned int currentIndentation = 1;

	if (output)
	{

		for (size_t y = 0; y < _labels.size(); y++)
		{
			output 
				<< "\n\nLABELS[\"" //LABELS["label_R30"] = {
				<< _labels.at(y).name
				<< "\"] = {";
			
			for (size_t x = 0; x < _labels.at(y).contents.size(); x++)
			{

				LABEL_LINE* ACTIVELABEL = &_labels.at(y).contents.at(x);

				if (_labels.at(y).name == "R28")
				{
					printf("nadas");
				}
				//function() iscene("R30"); end,
				if (_labels.at(y).contents.at(x).isIfStatement == IF)
				{
					std::string temporary = FixIfStatement(_labels.at(y), x);
					output << "\n\tfunction() " << temporary << "; end";
					--x;
					if (x >= _labels.at(y).contents.size() - 1)
					{

					}
					else
					{
						output << ",";
					}
				}
				else
				{
					output << "\n\tfunction() " << _labels.at(y).contents.at(x).str << "; end";
					if (x == _labels.at(y).contents.size() - 1)
					{

					}
					else
					{
						output << ",";
					}
				}
			};
			output << "\n};";
		}

	}
	else
	{
		printf("\nFailed to output\n");
	}

	std::string output_stringified = output.str();
	myReplace(output_stringified, "path_end;", "path_end();");

	std::ofstream ofile("output.lua");
	if (ofile)
	{
		ofile << output_stringified;
		ofile.close();
	}

	return;
};