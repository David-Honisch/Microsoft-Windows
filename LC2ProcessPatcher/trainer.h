//trainer.cpp
//
// Copyright(C) 2010 by Webmaster
//
#include <stdio.h>
#include <windows.h>
#include <iostream>
#include <tlhelp32.h> 
#include <tchar.h>


//#define PROCESS "WormsReloaded.exe"
#define PROCESS "explorer.exe"

//Update 0
/*
00579EE0 8B15 F4619A00 MOV EDX,DWORD PTR DS:[9A61F4]
00579EE6 8B4A 7C MOV ECX,DWORD PTR DS:[EDX+7C]
*/

//Update 2
/*
005D6C50 8B15 64E39B00 MOV EDX,DWORD PTR DS:[9BE364]
005D6C56 8B4A 7C MOV ECX,DWORD PTR DS:[EDX+7C]
*/

#define GAMEPOINTERv0 0x9A61F4
#define GAMEPOINTERv2 0x9BE364
#define MONEYNUM 0x7c

DWORD getProcessByName(char * processName);
bool patchMemory( DWORD pid, DWORD address, DWORD replace );

int main(int argc, char *argv[])
{
	DWORD pid = 0;
	DWORD pointer = 0;
	int version;
	printf("Worms Reloaded Trainer +1 by beYond3r");
	printf("F1 - 9999 Money Which Worms Update do you have?\n\n");
	printf("0 = No Update\n1 = Update 2");
	system("pause");
	
	printf("\nAction:");
	scanf ("%d",&version);
	printf("\nYou selected: ");
	if (version == 0)
	{
		printf("No Update");
		pointer = GAMEPOINTERv0;
	}
	if (version == 1)
	{
		printf("Update 2");		
		pointer = GAMEPOINTERv2;
	}
	if (version != 0 && version != 1)
	{
		printf("No patch selected. Exit program.\n");
		system("pause");
		return 0;
}
//}


printf("Waiting for game...");

while (1)
{
if (pid != 0)
{
if ((GetAsyncKeyState(VK_F1)&1)==1)
{
	printf("Patch initializing...");
/*	
if(patchMemory(pid,pointer,9999))
{
printf("Patch successfull");
} else {
printf("Error patch");
}
*/
}
} else {
pid = getProcessByName(PROCESS);
if (pid != 0) {
printf("Game found");
}
}

if ((GetAsyncKeyState(VK_F3)&1)==1)
{
break;
}
Sleep(200);
}

return 0;
}

bool patchMemory( DWORD pid, DWORD address, DWORD replace )
{
DWORD rBuf = 0;
DWORD gamePointer = 0;
HANDLE hProcess = OpenProcess(PROCESS_VM_WRITE|PROCESS_VM_OPERATION|PROCESS_VM_READ, NULL, pid);
if(!hProcess) {
printf("Error OpenProcess %u",GetLastError());
return 0;
}

//BOOL rpmRet = ReadProcessMemory(hProcess,(LPCVOID)address,&gamePointer,4,&rBuf);
BOOL rpmRet = ReadProcessMemory(hProcess,(LPCVOID)address,&gamePointer,4,(SIZE_T *)&rBuf);
//BOOL rpmRet = ReadProcessMemory(hProcess,(LPCVOID)address,&gamePointer,4,(DWORD)&rBuf);
if (!rpmRet) {
printf("Error ReadProcessMemory %u",GetLastError());
return 0;
}

gamePointer += MONEYNUM;
//BOOL wpmRet = WriteProcessMemory(hProcess,(LPVOID)gamePointer,&replace,4,&rBuf);
BOOL wpmRet = WriteProcessMemory(hProcess,(LPVOID)gamePointer,&replace,4,(SIZE_T *)&rBuf);
//BOOL wpmRet = WriteProcessMemory(hProcess,(LPVOID)gamePointer,&replace,4,(DWORD)&rBuf);
if (!wpmRet) {
printf("Error WriteProcessMemory %u",GetLastError());
return 0;
}

CloseHandle(hProcess);

if (rBuf == 4)
{
return true;
} else {
return false;
}
}

DWORD getProcessByName(char * processName)
{
HANDLE hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
PROCESSENTRY32 pe32;
pe32.dwSize = sizeof(PROCESSENTRY32);

if( !Process32First( hProcessSnap, &pe32 ) )
{
printf("Error getting Process");
CloseHandle( hProcessSnap );
return 0;
}

do
{
if(!_stricmp(pe32.szExeFile, processName))
{
CloseHandle(hProcessSnap);
return pe32.th32ProcessID;
}
} while(Process32Next(hProcessSnap, &pe32));

CloseHandle(hProcessSnap);
return 0;
} 
