/*
 David Honisch
 */
#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include <string> 
//#include <stdio.h>
//#include <stdlib.h>

#include "lc2windows.h"

using namespace std;
///*
#define BUFSIZE MAX_PATH

TCHAR* envVarStrings[] = { TEXT("OS         = %OS%"), TEXT(
		"PATH       = %PATH%"), TEXT("HOMEPATH   = %HOMEPATH%"), TEXT(
		"TEMP       = %TEMP%") };
TCHAR* envApplication[] = { TEXT("LC2Launcher"), TEXT("1.0") };
#define  ENV_VAR_STRING_COUNT  (sizeof(envVarStrings)/sizeof(TCHAR*))
#define INFO_BUFFER_SIZE 32767
/**
 *
 */
void LC2Windows::get_OSVersion() {
	OSVERSIONINFO osvi;
	BOOL bIsWindowsXPorLater;

	ZeroMemory(&osvi, sizeof(OSVERSIONINFO));
	osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);

	GetVersionEx(&osvi);

	bIsWindowsXPorLater = ((osvi.dwMajorVersion > 5) || ((osvi.dwMajorVersion
			== 5) && (osvi.dwMinorVersion >= 1)));

	if (bIsWindowsXPorLater)
		printf("The system meets the requirements.\n");
	else
		printf("The system does not meet the requirements.\n");
}
/**
 *
 */
void LC2Windows::printSysInfo() {
	printf("Print System Information:");
	DWORD i;
	TCHAR infoBuf[INFO_BUFFER_SIZE];
	DWORD bufCharCount = INFO_BUFFER_SIZE;

	// Get and display the name of the computer.
	bufCharCount = INFO_BUFFER_SIZE;
	if (!GetComputerName(infoBuf, &bufCharCount))
		printf(TEXT("GetComputerName"));
	printf(TEXT("\nComputer name:      %s"), infoBuf);

	// Get and display the user name.
	bufCharCount = INFO_BUFFER_SIZE;
	if (!GetUserName(infoBuf, &bufCharCount))
		printf(TEXT("GetUserName"));
	printf(TEXT("\nUser name:          %s"), infoBuf);

	// Get and display the system directory.
	if (!GetSystemDirectory(infoBuf, INFO_BUFFER_SIZE))
		printf(TEXT("GetSystemDirectory"));
	printf(TEXT("\nSystem Directory:   %s"), infoBuf);

	// Get and display the Windows directory.
	if (!GetWindowsDirectory(infoBuf, INFO_BUFFER_SIZE))
		printf(TEXT("GetWindowsDirectory"));
	printf(TEXT("\nWindows Directory:  %s"), infoBuf);

	// Expand and display a few environment variables.
	printf(TEXT("\n\nSmall selection of Environment Variables:"));
	for (i = 0; i < ENV_VAR_STRING_COUNT; ++i) {
		bufCharCount = ExpandEnvironmentStrings(envVarStrings[i], infoBuf,
				INFO_BUFFER_SIZE);
		if (bufCharCount > INFO_BUFFER_SIZE)
			printf(TEXT("\n\t(Buffer too small to expand: \"%s\")"),
					envVarStrings[i]);
		else if (!bufCharCount)
			printf(TEXT("ExpandEnvironmentStrings"));
		else
			printf(TEXT("\n %s:\n%s"), infoBuf,envVarStrings[i]);
	}
	printf(TEXT("\n\n"));
}
/**
 *
 */
string LC2Windows::getComputerName() {
	DWORD i;
	TCHAR infoBuf[INFO_BUFFER_SIZE];
	DWORD bufCharCount = INFO_BUFFER_SIZE;

	// Get and display the name of the computer.
	bufCharCount = INFO_BUFFER_SIZE;
	if (!GetComputerName(infoBuf, &bufCharCount))
		printError(TEXT("GetComputerName"));
	return "" + (string) infoBuf;
}
/**
 *
 */
string LC2Windows::getWindowsDirectory() {
	DWORD i;
	TCHAR infoBuf[INFO_BUFFER_SIZE];
	DWORD bufCharCount = INFO_BUFFER_SIZE;

	// Get and display the name of the computer.
	bufCharCount = INFO_BUFFER_SIZE;
	if (!GetWindowsDirectory(infoBuf, INFO_BUFFER_SIZE))
		printf(TEXT("GetWindowsDirectory"));
	return "" + (string) infoBuf;
}
/**
 *
 */
string LC2Windows::getWindowsSystemDirectory() {
	DWORD i;
	TCHAR infoBuf[INFO_BUFFER_SIZE];
	DWORD bufCharCount = INFO_BUFFER_SIZE;

	// Get and display the name of the computer.
	bufCharCount = INFO_BUFFER_SIZE;
	if (!GetSystemDirectory(infoBuf, INFO_BUFFER_SIZE))
		printf(TEXT("GetSystemDirectory"));
	return "" + (string) infoBuf;
}
/**
 *
 */
string LC2Windows::getUserProfile() {
	DWORD i;
	TCHAR infoBuf[INFO_BUFFER_SIZE];
	DWORD bufCharCount = INFO_BUFFER_SIZE;
	bufCharCount = INFO_BUFFER_SIZE;
	if (!GetUserName(infoBuf, &bufCharCount))
		printf(TEXT("GetUserName"));
	return "" + (string) infoBuf;
}
/**
 *
 */
string LC2Windows::getTempPath() {
	DWORD i;
	TCHAR infoBuf[INFO_BUFFER_SIZE];
	DWORD bufCharCount = INFO_BUFFER_SIZE;

	// Get and display the name of the computer.
	bufCharCount = INFO_BUFFER_SIZE;
//	if (!GetTempPath(infoBuf, INFO_BUFFER_SIZE))
//		printf(TEXT("GetSystemDirectory"));
	return "" + (string) infoBuf;
}
/**
 *
 */
DWORD LC2Windows::getPath() {
	TCHAR Buffer[INFO_BUFFER_SIZE];
	//DWORD dwRet;
	return GetCurrentDirectory(INFO_BUFFER_SIZE, Buffer);
}
/**
 *
 */
void LC2Windows::printError(TCHAR* msg) {
	DWORD eNum;
	TCHAR sysMsg[256];
	TCHAR* p;

	eNum = GetLastError();
	FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
			NULL, eNum, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), sysMsg, 256,
			NULL);

	// Trim the end of the line and terminate it with a null
	p = sysMsg;
	while ((*p > 31) || (*p == 9))
		++p;
	do {
		*p-- = 0;
	} while ((p >= sysMsg) && ((*p == '.') || (*p < 33)));

	// Display the message
	printf(TEXT("\n\t%s failed with error %d (%s)"), msg, eNum, sysMsg);
}
