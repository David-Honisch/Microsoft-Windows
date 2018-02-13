#include <windows.h>
#include "Main.h"
//#include "res.h"

//static char g_szClassName[] = "MyWindowClass";
//static HINSTANCE g_hInst = NULL;

#define IDC_MAIN_TEXT   1001
/*  Declare Windows procedure  */
LRESULT CALLBACK WindowProcedure (HWND, UINT, WPARAM, LPARAM);

/*  Make the class name into a global variable  */
char szClassName[ ] = "WindowsApp";
HDC hdcMem = NULL;
HBITMAP hBmp = NULL;
HBITMAP hBmpOld = NULL;
HINSTANCE hInst;

HBITMAP hSkinMBmp = NULL;
int i = 0;

// defines

//#define LWA_COLORKEY            0x00000001
//#define LWA_ALPHA               0x00000002

//#define bitmapHeight            217
//#define bitmapWidth             433    

//#define g_ColourKey             0xFF00FF // 0,0,255(pink) in hex RGB

/*

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
         
      if(GetSaveFileName(&ofn))
      {
         if(!SaveFile(GetDlgItem(hwnd, IDC_MAIN_TEXT), szFileName))
         {
            MessageBox(hwnd, "Save file failed.", "Error",
               MB_OK | MB_ICONEXCLAMATION);
            return FALSE;
         }
      }
   }
   else
   {
      ofn.Flags = OFN_EXPLORER | OFN_FILEMUSTEXIST | OFN_HIDEREADONLY;
      if(GetOpenFileName(&ofn))
      {
         if(!LoadFile(GetDlgItem(hwnd, IDC_MAIN_TEXT), szFileName))
         {
            MessageBox(hwnd, "Load of file failed.", "Error",
               MB_OK | MB_ICONEXCLAMATION);
            return FALSE;
         }
      }
   }
   return TRUE;
}

*/

int WINAPI WinMain (HINSTANCE hThisInstance,
                    HINSTANCE hPrevInstance,
                    LPSTR lpszArgument,
                    int nFunsterStil)

{
    HWND hwnd;               /* This is the handle for our window */
    MSG messages;            /* Here messages to the application are saved */
    WNDCLASSEX wincl;        /* Data structure for the windowclass */

    /* The Window structure */
    wincl.hInstance = hThisInstance;
    wincl.lpszClassName = szClassName;
    wincl.lpfnWndProc = WindowProcedure;      /* This function is called by windows */
    wincl.style = CS_DBLCLKS;                 /* Catch double-clicks */
    wincl.cbSize = sizeof (WNDCLASSEX);

    /* Use default icon and mouse-pointer */
    wincl.hIcon = LoadIcon (NULL, IDI_APPLICATION);
    wincl.hIconSm = LoadIcon (NULL, IDI_APPLICATION);
    wincl.hCursor = LoadCursor (NULL, IDC_ARROW);
    wincl.lpszMenuName = NULL;                 /* No menu */
    wincl.cbClsExtra = 0;                      /* No extra bytes after the window class */
    wincl.cbWndExtra = 0;                      /* structure or the window instance */
    /* Use Windows's default color as the background of the window */
    wincl.hbrBackground = GetSysColorBrush(COLOR_3DFACE);
    //
    
    
    /* Register the window class, and if it fails quit the program */
    if (!RegisterClassEx (&wincl))
        return 0;

    /* The class is registered, let's create the program*/
    hwnd = CreateWindowEx (
           0,                   /* Extended possibilites for variation */
           szClassName,         /* Classname */
           "LCLauncher",    /* Title Text */
           WS_SYSMENU, /* default window */
           //CW_USEDEFAULT,       /* Windows decides the position */
           CW_USEDEFAULT,       /* Windows decides the position */
           CW_USEDEFAULT,       /* where the window ends up on the screen */
           400,                 /* The programs width */
           400,                 /* and height in pixels */
           HWND_DESKTOP,        /* The window is a child-window to desktop */
           NULL,                /* No menu */
           hThisInstance,       /* Program Instance handler */
           NULL                 /* No Window Creation data */
           );

    /* Make the window visible on the screen */
    ShowWindow (hwnd, nFunsterStil);
    UpdateWindow(hwnd);

    /* Run the message loop. It will run until GetMessage() returns 0 */
    while (GetMessage (&messages, NULL, 0, 0))
    {
        /* Translate virtual-key messages into character messages */
        TranslateMessage(&messages);
        /* Send message to WindowProcedure */
        DispatchMessage(&messages);
    }

    /* The program return-value is 0 - The value that PostQuitMessage() gave */
    return messages.wParam;
}


/*  This function is called by the Windows function DispatchMessage()  */

LRESULT CALLBACK WindowProcedure (HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    PAINTSTRUCT Ps;
    HDC hDC, MemDCExercising;
    HBITMAP hBmp;
    
    switch (message)                  /* handle the messages */
    {
        case WM_PAINT:
        hDC = BeginPaint(hwnd, &Ps);
    	Arc(hDC, 20, 20, 226, 144, 202, 115, 105, 32);
        EndPaint(hwnd, &Ps);
        /*
            BITMAP bm;
            HDC hdc = BeginPaint(hwnd, &Ps);
            HDC dcSkin = CreateCompatibleDC(hdc); 
            GetObject(hSkinMBmp, sizeof(bm), &bm);
            SelectObject(dcSkin, hSkinMBmp);
            BitBlt(hdc, 0,0,bitmapWidth,bitmapHeight, dcSkin, 0, 0, SRCCOPY);
            DeleteDC(dcSkin);
         EndPaint(hwnd, &Ps);
        */
        //
        //hBmp = (HBITMAP)LoadBitmap(NULL, TEXT("title640.bmp"), IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE );
        //hBmp = LoadBitmap(hInst, MAKEINTRESOURCE(IDB_EXERCISING));
        // Create a memory device compatible with the above DC variable
	    //MemDCExercising = CreateCompatibleDC(hDC);
             // Select the new bitmap
        //SelectObject(MemDCExercising, hBmp);

	    // Copy the bits from the memory DC into the current dc
	    //BitBlt(hDC, 10, 10, 450, 400, MemDCExercising, 0, 0, SRCCOPY);

	    // Restore the old bitmap
	    //DeleteDC(MemDCExercising);
	    //DeleteObject(hBmp);
	    //EndPaint(hwnd, &Ps);
        
        
        break;
        case WM_CTLCOLORSTATIC:
        {
          SetBkColor ((HDC) wParam, RGB(84,254,0));//GetSysColor(COLOR_3DFACE)
          HBRUSH bkground = CreateSolidBrush(RGB(84,254,0));//GetSysColor(COLOR_3DFACE)
          //return((DWORD) bkground);
          break;
        }
        case WM_CREATE:
            
            //SetWindowText(hwnd, (LPSTR)"LCLauncher v.1.0");
            CreateWindow(
                TEXT("button"),
                TEXT("Load"),
                WS_VISIBLE | WS_CHILD,
                10, 10, 80, 25,
                hwnd, (HMENU) 1, NULL, NULL
            );            
            //
             CreateWindow(
                TEXT("button"),
                TEXT("Start"),
                WS_VISIBLE | WS_CHILD,
                10, 40, 80, 25,
                hwnd, (HMENU) 2, NULL, NULL
            );
            
            ///*
            //
             CreateWindow(
                TEXT("button"),
                TEXT("Schliessen"),
                WS_VISIBLE | WS_CHILD,
                10, 130, 80, 25,
                hwnd, (HMENU) 3, NULL, NULL
            );
            //*/
            ///*
            //Edit
            CreateWindow("EDIT", "",
            WS_CHILD | WS_VISIBLE | WS_HSCROLL | WS_VSCROLL | ES_MULTILINE |
               ES_WANTRETURN,
            CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
            hwnd, (HMENU)IDC_MAIN_TEXT, hInst, NULL);
            SendDlgItemMessage(hwnd, IDC_MAIN_TEXT, WM_SETFONT,
            (WPARAM)GetStockObject(DEFAULT_GUI_FONT), MAKELPARAM(TRUE, 0));
            //EOF Edit
         
         
        // */
            
            break;
      case WM_SIZE:
      
         if(wParam != SIZE_MINIMIZED)
            MoveWindow(GetDlgItem(hwnd, IDC_MAIN_TEXT), 100, 0, LOWORD(lParam),
               HIWORD(lParam), TRUE);
      
      break;
      //case WM_SETFOCUS:
         //SetFocus(GetDlgItem(hwnd, IDC_MAIN_TEXT));
      //break;
    
        case WM_COMMAND:
            if (LOWORD(wParam) == 1) {
                MessageBox(hwnd, "Loaded", "Load", MB_OK | MB_ICONINFORMATION);
                //
                
                //FIRST ATTEMPT
                //LCLauncher.LoadPic();
                if(hdcMem)
                return 1;  // already loaded, no need to load it again
                // note:  here you must put the file name in a TEXT() macro.  DO NOT CAST IT TO LPCSTR
                hBmp = (HBITMAP)LoadImage(NULL, TEXT(".\\img\\title640.bmp"), IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE );
                if(!hBmp)  // the load failed (couldn't find file?  Invalid file?)
                return 1;
                hdcMem = CreateCompatibleDC(NULL);
                hBmpOld = (HBITMAP)SelectObject(hdcMem, hBmp);
                //HBITMAP hImage = (HBITMAP) LoadImage(NULL, ".\img\title640.bmp", IMAGE_BITMAP, 500, 500, LR_LOADFROMFILE);
                //SendMessage(hwnd, STM_SETIMAGE, IMAGE_BITMAP, (LPARAM)hImage);
                
                //SECOND ATTEMPT
                /*
                //HBITMAP hImage = (HBITMAP)LoadImage(NULL, (LPCSTR)".\\img\\title640.bmp", IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE);
                HDC hdcMem = CreateCompatibleDC(hDC); // hDC is a DC structure supplied by Win32API
                SelectObject(hdcMem, hImage);
                StretchBlt(
                        hDC,         // destination DC
                        0,        // x upper left
                        0,         // y upper left
                        100,       // destination width
                        100,      // destination height
                        hdcMem,      // you just created this above
                        0,
                        0,                      // x and y upper left
                        500,                      // source bitmap width
                        500,                      // source bitmap height
                        SRCCOPY);       // raster operation
                     */   

            }
           if (LOWORD(wParam) == 2) {
                   MessageBox(hwnd, "Start initializing...", "Start", MB_OK | MB_ICONINFORMATION);

            }
            if (LOWORD(wParam) == 3) {
                   MessageBox(hwnd, "Bye...", "Start", MB_OK | MB_ICONINFORMATION);
                   PostQuitMessage (0);

            }
            break; 
        case WM_CLOSE:
             DestroyWindow(hwnd);    
        case WM_DESTROY:
            PostQuitMessage (0);       /* send a WM_QUIT to the message queue */
            break;
        default:                      /* for messages that we don't deal with */
            return DefWindowProc (hwnd, message, wParam, lParam);
    }

    return 0;
}
//--------------------------

static void LoadPic()
{
  if(hdcMem)
    return;  // already loaded, no need to load it again

  // note:  here you must put the file name in a TEXT() macro.  DO NOT CAST IT TO LPCSTR
  hBmp = (HBITMAP)LoadImage(NULL, TEXT("curFrame.bmp"), IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE );

  if(!hBmp)  // the load failed (couldn't find file?  Invalid file?)
    return;

  hdcMem = CreateCompatibleDC(NULL);
  hBmpOld = (HBITMAP)SelectObject(hdcMem, hBmp);
}

// call this function when the program is done (shutting down)
static void FreePic()
{
  if(hdcMem)
  {
    SelectObject(hdcMem, hBmpOld);
    DeleteObject(hBmp);
    DeleteDC(hdcMem);
  }
}

