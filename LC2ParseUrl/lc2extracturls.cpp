//#include "string.h"
//#include "stdio.h"
#include <iostream>
#include <string>

#include <fstream>
#include <iterator>
#include <set>
#include <regex>
using std::string;
//#define BAD(x) (!(x) || (*(x) == '\0'))

void printUsage()
{
	printf("LETZTECHANCE.ORG - LC2UrlParser in C++\n");
	printf("\n%s\n%s %s", "Usage:", "lc2extracturls_x64.exe", "<url>");
	printf("\n");
	printf("For example:\n");
	printf("\n%s\n%s %s", "Usage:", "lc2extracturls_x64.exe", "test.html");
}

string getPathName(const string& s) {

	char sep = '/';

#ifdef _WIN32
	sep = '\\';
#endif

	size_t i = s.rfind(sep, s.length());
	if (i != string::npos) {
		return(s.substr(0, i));
	}

	return("");
}
int isUrl(std::string url_test)
{
	int result = 0;
	std::regex url(".*\\..*");
	if (!regex_match(url_test, url)) {
		result = 1;
	}
	return result;
}
int isWebUrl(std::string url_test)
{
	int result = 0;
	std::regex url("http.*\\..*");
	if (!regex_match(url_test, url)) {
		result = 1;
	}
	return result;
}

std::string file_to_string(std::string file_name)
{
	std::ifstream file(file_name);
	return { std::istreambuf_iterator<char>(file), std::istreambuf_iterator<char>{} };
}

std::set<std::string> extract_hyperlinks(std::string html_file_name)
{
	static const std::regex hl_regex("<a href=\"(.*?)\">", std::regex_constants::icase);

	const std::string text = file_to_string(html_file_name);

	return { std::sregex_token_iterator(text.begin(), text.end(), hl_regex, 1),
		std::sregex_token_iterator{} };
}

int main(int argc, char** argv)
{
	string fileName = "";
	string filePath = "";
	if (argc == 1)
	{		
		printUsage();
	}
	if (argc > 1)
	{
		fileName = argv[1];
		filePath = getPathName(fileName);
		
	}
	if (!fileName.empty())
	{
		for (auto str : extract_hyperlinks("urls.html")) {
			if (argc > 2 && argv[2] == "true") {
				if (isWebUrl(str) == 0) {
					std::cout << str << '\n';
				}				
			}
			else
			{
				if (isUrl(str) == 0) {
					std::cout << str << '\n';
				}
			}
		}
	}
	return 0;
}
