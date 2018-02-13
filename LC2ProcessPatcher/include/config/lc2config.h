#ifndef _LC2CONFIG_H_ 
#define _LC2CONFIG_H_
#include <conio.h>
#include <string> 
//#include ".\include\windows\lc2windows.h"
//#include ".\include\windows\lc2windows.cpp"
#include "..\windows\lc2windows.h"
//#include "..\windows\lc2windows.cpp"

using namespace std;

class LC2Config : public LC2Windows
{
	long _p;
	long _q;
	string glbPrgName;

public:
	string getCWD();
	LC2Config();
	//get
	string getPrgName();

	//string getComputerName();
	string getPath();
	//string getUserProfile();
	//string getWindowsDirectory();
	string getTitle();
	string getVersion();
	string getPrgNameAndVersion();
	//get dll file names
	const char * getDLLCore();
	const char * getDLLmci();
	//eof getting dll file names          
	//out !!!
	const char * getDLLConfig();
	int doLoadConfig(char * dllName, char * chrMethod, char * charValue);
	//print
	void display() const;
	void print();
	void printHeader();
	void printSystemInfo();
	//set
	void setPrgName(string argv);
	void setTitle(string value);
	int setConsoleColor(int Text, int Hintergrund);
};
#endif

