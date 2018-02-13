#ifndef _LC2WINDOWS_H_ 
#define _LC2WINDOWS_H_


using namespace std;

class LC2Windows
{
//void gcm (void);
//void gcm (string value);
//void gcm (const char* value);
//void gcm (const LC2Registry&);

public: 
//LC2Windows(); 
//LC2Windows();
//~LC2Windows ();
//get
string getUserProfile();

void get_OSVersion();
string getComputerName();
string getWindowsDirectory();
string getWindowsSystemDirectory();
string getTempPath();
DWORD getPath();

void printSysInfo();

void printError( TCHAR* msg );


};
#endif
