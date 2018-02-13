/*
 David Honisch
 */
#include "windows.h"
#include "LC2CONTROL.h"

LC2CONTROL::LC2CONTROL(void) {
	//printf("1st Construct\n");
}
typedef void (CALLBACK* f_getConsoleInput)(void);
typedef int (CALLBACK* f_doPrint)(char * text);
typedef int (CALLBACK* f_showMessageBox)(char *TEXT);
typedef int (CALLBACK* f_doPlayNote)(char * text, BYTE volume,BYTE note);
//type definition of messageBox
//typedef string (CALLBACK* f_parseDirectory)(string readingDirectory, const string& aCurrentFolderName);
//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
/*
DWORD LC2CONTROL::doGetDLLDWORD(std::wstring &dllName, std::wstring &chrMethod, std::wstring &charValue1) {
	HINSTANCE hDLL; // Handle to DLL
	f_doPrint lpfnDllFunc1; // Function pointer
	//UINT uParam1;
	DWORD dwResult = 0;
	hDLL = LoadLibrary(dllName);
	//printf("%s method:%s value:%s!!!\n",dllName,chrMethod, charValue);
	if (hDLL != NULL) {
		lpfnDllFunc1 = (f_doPrint) GetProcAddress(hDLL, chrMethod);
		if (!lpfnDllFunc1) {
			// handle the error
			FreeLibrary(hDLL);
			//return "Error";
			printf("Error, method doDLLPrint %s not found in %s.", chrMethod,
					dllName);
		} else {
			// call the function
			dwResult = lpfnDllFunc1(charValue);
		}
	}
	return dwResult;
}
*/
DWORD LC2CONTROL::doGetDLLDWORD(std::wstring &dllName, std::wstring &chrMethod, std::wstring &charValue1, std::wstring &charValue2) {
	HINSTANCE hDLL; // Handle to DLL
	f_doPrint lpfnDllFunc1; // Function pointer
	//UINT uParam1;
	DWORD dwResult = 0;
	hDLL = LoadLibrary((char *)dllName.c_str());
	//printf("%s method:%s value:%s!!!\n",dllName,chrMethod, charValue);
	if (hDLL != NULL) {
		lpfnDllFunc1 = (f_doPrint) GetProcAddress(hDLL,(char *) chrMethod.c_str());
		if (!lpfnDllFunc1) {
			// handle the error
			FreeLibrary(hDLL);
			//return "Error";
			printf("Error, method doDLLPrint %s not found in %s.",(char *) chrMethod.c_str(),(char *) &dllName);
		} else {
			// call the function
//			dwResult = lpfnDllFunc1((char *)charValue1.c_str(),(char *) charValue2.c_str());
			dwResult = lpfnDllFunc1((char *)charValue1.c_str());
		}
	}
	return dwResult;
}

//------------------------------------------------------------------------------------				
//------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------
int LC2CONTROL::doDLLPrint(char * dllName, char * chrMethod, char * charValue) {
	HINSTANCE hDLL; // Handle to DLL
	f_doPrint lpfnDllFunc1; // Function pointer
	//DWORD dwParam1;
	//UINT uParam2, uReturnVal;
	int result = 0;
	hDLL = LoadLibrary(dllName);
	//printf("%s method:%s value:%s!!!\n",dllName,chrMethod, charValue);
	if (hDLL != NULL) {
		lpfnDllFunc1 = (f_doPrint) GetProcAddress(hDLL, chrMethod);
		if (!lpfnDllFunc1) {
			// handle the error
			FreeLibrary(hDLL);
			//return "Error";
			printf("Error, method doDLLPrint %s not found in %s.", chrMethod,
					dllName);
		} else {
			// call the function
			result = lpfnDllFunc1(charValue);
		}
	}
}

//------------------------------------------------------------------------------------				
//------------------------------------------------------------------------------------
//int doPlayNote(char * text, BYTE volume,BYTE note);
//------------------------------------------------------------------------------------
int LC2CONTROL::doPlayNote(char * dllName, char * chrMethod,char * charValue, BYTE volume,BYTE note) {
	HINSTANCE hDLL; // Handle to DLL
	f_doPlayNote lpfnDllFunc1; // Function pointer
	//DWORD dwParam1;
	//UINT uParam2, uReturnVal;
	int result = 0;
	hDLL = LoadLibrary(dllName);
	//printf("\n%s Method:%s\n!!!\n",charValue,chrMethod);
	if (hDLL != NULL) {
		lpfnDllFunc1 = (f_doPlayNote) GetProcAddress(hDLL, chrMethod);
		if (!lpfnDllFunc1) {
			// handle the error
			FreeLibrary(hDLL);
			//return "Error";
			printf("Error, method doDLLPrint %s not found in %s.", chrMethod,
					dllName);
		} else {
			// call the function
			//lpfnDllFunc1("", volume,note);
		}
	}
}

//------------------------------------------------------------------------------------				
//------------------------------------------------------------------------------------
int LC2CONTROL::getConsoleInput(char * dllName, char * chrMethod,
		char * charValue) {
	HINSTANCE hDLL; // Handle to DLL
	//LPFNDLLFUNC1 lpfnDllFunc1;    /			/ Function pointer
	f_getConsoleInput lpfnDllFunc1; // Function pointer
	//DWORD dwParam1;
	//UINT uParam2, uReturnVal;
	int result = 0;
	//hDLL = LoadLibrary(dllcore.c_str());
	hDLL = LoadLibrary(dllName);
	//printf("\n%s Method:%s\n!!!\n",charValue,chrMethod);
	if (hDLL != NULL) {
		//   lpfnDllFunc1 = (LPFNDLLFUNC1)GetProcAddress(hDLL, "DLLFunc1");
		//lpfnDllFunc1 = (f_getInfo) GetProcAddress(hDLL, "getInfo");
		lpfnDllFunc1 = (f_getConsoleInput) GetProcAddress(hDLL, chrMethod);
		if (!lpfnDllFunc1) {
			// handle the error
			FreeLibrary(hDLL);
			//return "Error";
			printf("Error, method doDLLPrint %s not found in %s.", chrMethod,
					dllName);
		} else {
			// call the function
			//uReturnVal = lpfnDllFunc1(dwParam1, uParam2);
			lpfnDllFunc1();
			//lpfnDllFunc1(charValue);
		}
		//printf("Out: %s\n", result);
		//printf(result);
	}
}

//------------------------------------------------------------------------------------
/**
 * LC2CONTROL::doLoadConfig()
 */
//------------------------------------------------------------------------------------				 
int LC2CONTROL::doLoadConfig(char * dllName, char * chrMethod, char * charValue) {
	HINSTANCE hDLL; // Handle to DLL
	//LPFNDLLFUNC1 lpfnDllFunc1;    // Function pointer
	f_showMessageBox lpfnDllFunc1; // Function pointer
	//DWORD dwParam1;
	//UINT uParam2, uReturnVal;
	int result;

	//hDLL = LoadLibrary(dllcore.c_str());
	hDLL = LoadLibrary(dllName);
	if (hDLL != NULL) {
		//   lpfnDllFunc1 = (LPFNDLLFUNC1)GetProcAddress(hDLL, "DLLFunc1");
		lpfnDllFunc1
		//= (f_showMessageBox) GetProcAddress(hDLL, "showMessageBox");
				= (f_showMessageBox) GetProcAddress(hDLL, chrMethod);
		if (!lpfnDllFunc1) {
			// handle the error
			FreeLibrary(hDLL);
			//return "Error";
			printf("Error, method %s not found in %s.", chrMethod, dllName);
		} else {
			// call the function
			//uReturnVal = lpfnDllFunc1(dwParam1, uParam2);
			//result = lpfnDllFunc1("LC2Main");
			result = lpfnDllFunc1(charValue);
		}
		//printf("Out: %d",result);

	}
}


//doPlayNote
//------------------------------------------------------------------------------------				
/**
 * int LC2CONTROL::doLoadSystem()
 * typedef char * (*tgetInfo) ();
 * return int;
 */
//int LC2CONTROL::doLoadSystem()
//------------------------------------------------------------------------------------		
/*
 int LC2CONTROL::doReadDireotory(char * dllName, char * chrMethod, char * charValue)
 {
 HINSTANCE hDLL; // Handle to DLL
 //LPFNDLLFUNC1 lpfnDllFunc1;    /			/ Function pointer
 f_parseDirectory lpfnDllFunc1; // Function pointer
 //DWORD dwParam1;
 string strParam1;
 string strParam2;
 string strParam3;
 //UINT uParam2, uReturnVal;
 //char * result;
 string result;

 //hDLL = LoadLibrary(dllcore.c_str());
 hDLL = LoadLibrary(dllName);
 if (hDLL != NULL) {
 //   lpfnDllFunc1 = (LPFNDLLFUNC1)GetProcAddress(hDLL, "DLLFunc1");
 //lpfnDllFunc1 = (f_getInfo) GetProcAddress(hDLL, "getInfo");
 lpfnDllFunc1 = (f_parseDirectory) GetProcAddress(hDLL, chrMethod);
 if (!lpfnDllFunc1) {
 // handle the error
 FreeLibrary(hDLL);
 //return "Error";
 printf("Error, method %s not found in %s.",chrMethod,dllName);
 } else {
 // call the function
 //uReturnVal = lpfnDllFunc1(dwParam1, uParam2);
 //result = lpfnDllFunc1();
 result = lpfnDllFunc1();
 }
 printf("Out: %s\n", result);
 //printf(result);
 }
 }
 */

