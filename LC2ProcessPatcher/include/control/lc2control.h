#ifndef _LC2CONTROL_H_ 
#define _LC2CONTROL_H_
#include <conio.h>
#include <string> 
//#include <stdio.h>
//#include <stdlib.h>

using namespace std;

class LC2CONTROL {
	long _p;
	long _q;
	string glbPrgName;
	//void gcm (void);
	//void gcm (string value);
	//void gcm (const char* value);
	//void gcm (const LC2Registry&);

public:
	LC2CONTROL();
	//LC2Registry (const char* value);
	//LC2Registry (string value);
	//LC2Registry ( long = 0, long = 1 );
	//get
	string getPrgName();

	string getComputerName();
	string getPath();
	string getUserProfile();
	string getWindowsDirectory();
	string getTitle();
	string getVersion();
	string getPrgNameAndVersion();
	//get dll filenames
	const char * getDLLConfig();

	//int doLoadSystem();
	int doDLLPrint(char * dllName, char * chrMethod, char * charValue);
	int getConsoleInput(char * dllName, char * chrMethod, char * charValue);
    DWORD doGetDLLDWORD(std::wstring &dllName, std::wstring &chrMethod, std::wstring &charValue1, std::wstring &charValue2);
	//media mci
	int doPlayNote(char * dllName, char * chrMethod,char * charValue, BYTE volume,BYTE note);
	//eof get dll filenames
	int doLoadConfig(char * dllName, char * chrMethod, char * charValue);
	int doReadDireotory(char * dllName, char * chrMethod, char * charValue);
	//print
	void display() const;
	void print();
	
    
    //void printSystemInfo();
	//set
	void setPrgName(string argv);
	void setTitle(string value);
	int setConsoleColor(int Text, int Hintergrund);
};
#endif
