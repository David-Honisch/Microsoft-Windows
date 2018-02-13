#include <windows.h>
#include <commdlg.h>
#include <iostream>
//#include <fstream.h>
//#include <stdio.h>
//#include <string>
//#include <vector>
//#include <ctype.h>

#include "..\..\include\config\lc2config.h"
#include "..\..\include\config\lc2config.cpp"

#include "LC2io.h"

#define IDC_MAIN_TEXT   1001
using namespace std;

//typedef std::vector<int> Turm;
//typedef std::vector<Turm> Tuerme;

//Tuerme tuerme;
//typedef std::vector<string> SteinBild;

//int scheiben;

//extern "C" _declspec(dllexport)BOOL LoadFile(HWND hEdit, LPSTR pszFileName);
//extern "C" _declspec(dllexport)BOOL SaveFile(HWND hEdit, LPSTR pszFileName);
//extern "C" _declspec(dllexport)BOOL DoFileOpenSave(HWND hwnd, BOOL bSave);


LC2io::LC2io() {
}

LC2io::~LC2io() {
}

    BOOL LoadFile(HWND hEdit, LPSTR pszFileName)
    {
       HANDLE hFile;
       BOOL bSuccess = FALSE;
    
       hFile = CreateFile(pszFileName, GENERIC_READ, FILE_SHARE_READ, NULL,
          OPEN_EXISTING, 0, 0);
       if(hFile != INVALID_HANDLE_VALUE)
       {
          DWORD dwFileSize;
          dwFileSize = GetFileSize(hFile, NULL);
          if(dwFileSize != 0xFFFFFFFF)
          {
             LPSTR pszFileText;
             pszFileText = (LPSTR)GlobalAlloc(GPTR, dwFileSize + 1);
             if(pszFileText != NULL)
             {
                DWORD dwRead;
                if(ReadFile(hFile, pszFileText, dwFileSize, &dwRead, NULL))
                {
                   pszFileText[dwFileSize] = 0; // Null terminator
                   if(SetWindowText(hEdit, pszFileText))
                      bSuccess = TRUE; // It worked!
                }
                GlobalFree(pszFileText);
             }
          }
          CloseHandle(hFile);
       }
       return bSuccess;
    }
    
    BOOL SaveFile(HWND hEdit, LPSTR pszFileName)
    {
       HANDLE hFile;
       BOOL bSuccess = FALSE;
    
       hFile = CreateFile(pszFileName, GENERIC_WRITE, 0, 0,
          CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
       if(hFile != INVALID_HANDLE_VALUE)
       {
          DWORD dwTextLength;
          dwTextLength = GetWindowTextLength(hEdit);
          if(dwTextLength > 0)// No need to bother if there's no text.
          {
             LPSTR pszText;
             pszText = (LPSTR)GlobalAlloc(GPTR, dwTextLength + 1);
             if(pszText != NULL)
             {
                if(GetWindowText(hEdit, pszText, dwTextLength + 1))
                {
                   DWORD dwWritten;
                   if(WriteFile(hFile, pszText, dwTextLength, &dwWritten, NULL))
                      bSuccess = TRUE;
                }
                GlobalFree(pszText);
             }
          }
          CloseHandle(hFile);
       }
       return bSuccess;
    }
    
    BOOL DoFileOpenSave(HWND hwnd, BOOL bSave)
    {
       OPENFILENAME ofn;
       char szFileName[MAX_PATH];
    
       ZeroMemory(&ofn, sizeof(ofn));
       szFileName[0] = 0;
    
       ofn.lStructSize = sizeof(ofn);
       ofn.hwndOwner = hwnd;
       ofn.lpstrFilter = "Text Files (*.txt)\0*.txt\0All Files (*.*)\0*.*\0\0";
       ofn.lpstrFile = szFileName;
       ofn.nMaxFile = MAX_PATH;
       ofn.lpstrDefExt = "txt";
    
       if(bSave)
       {
          ofn.Flags = OFN_EXPLORER | OFN_PATHMUSTEXIST | OFN_HIDEREADONLY |
             OFN_OVERWRITEPROMPT;
   /*         
          if(GetSaveFileName(&ofn))
          {
             if(!SaveFile(GetDlgItem(hwnd, 1001), szFileName))
             {
                MessageBox(hwnd, "Save file failed.", "Error",
                   MB_OK | MB_ICONEXCLAMATION);
                return FALSE;
             }
          }
   */      
       }
       else
       {
          ofn.Flags = OFN_EXPLORER | OFN_FILEMUSTEXIST | OFN_HIDEREADONLY;
          /*
          if(GetOpenFileName(&ofn))
          {
             if(!LoadFile(GetDlgItem(hwnd, IDC_MAIN_TEXT), szFileName))
             {
                MessageBox(hwnd, "Load of file failed.", "Error",
                   MB_OK | MB_ICONEXCLAMATION);
                return FALSE;
             }
          }
          */
       }
       return TRUE;
    }
    
    void doOpenFile()
    {
        OPENFILENAME ofn;       // common dialog box structure
    char szFile[260];       // buffer for file name
    HWND hwnd;              // owner window
    HANDLE hf;              // file handle
    
    // Initialize OPENFILENAME
    ZeroMemory(&ofn, sizeof(ofn));
    ofn.lStructSize = sizeof(ofn);
    ofn.hwndOwner = hwnd;
    ofn.lpstrFile = szFile;
    // Set lpstrFile[0] to '\0' so that GetOpenFileName does not 
    // use the contents of szFile to initialize itself.
    ofn.lpstrFile[0] = '\0';
    ofn.nMaxFile = sizeof(szFile);
    ofn.lpstrFilter = "All\0*.*\0Text\0*.TXT\0";
    ofn.nFilterIndex = 1;
    ofn.lpstrFileTitle = NULL;
    ofn.nMaxFileTitle = 0;
    ofn.lpstrInitialDir = NULL;
    ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST;
    
    // Display the Open dialog box. 
    /*
    if (GetOpenFileName(&ofn)==TRUE) 
    {
        hf = CreateFile(ofn.lpstrFile, 
                        GENERIC_READ,
                        0,
                        (LPSECURITY_ATTRIBUTES) NULL,
                        OPEN_EXISTING,
                        FILE_ATTRIBUTE_NORMAL,
                        (HANDLE) NULL);
    }
    */
    }

//extern "C" __declspec(dllexport)void BoxProperties(double Length, double Height,


/*
extern "C" _declspec(dllexport) int log ()
{
	FILE * pFile;
	pFile = fopen ("log.txt","w");
	if (pFile!=NULL)
	{
		fputs ("-"+scheiben,pFile);
		fclose (pFile);
	}
	return 0;
}
*/
