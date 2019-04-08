; lc2install.nsi
;
; This script attempts to test most of the functionality of the NSIS exehead.

;--------------------------------

!ifdef HAVE_UPX
!packhdr tmp.dat "upx\upx -9 tmp.dat"
!endif

!ifdef NOCOMPRESS
SetCompress off
!endif
;--------------------------------
; ################################################################
; appends \ to the path if missing
; example: !insertmacro GetCleanDir "c:\blabla"
; Pop $0 => "c:\blabla\"
!macro GetCleanDir INPUTDIR
  ; ATTENTION: USE ON YOUR OWN RISK!
  ; Please report bugs here: http://stefan.bertels.org/
  !define Index_GetCleanDir 'GetCleanDir_Line${__LINE__}'
  Push $R0
  Push $R1
  StrCpy $R0 "${INPUTDIR}"
  StrCmp $R0 "" ${Index_GetCleanDir}-finish
  StrCpy $R1 "$R0" "" -1
  StrCmp "$R1" "\" ${Index_GetCleanDir}-finish
  StrCpy $R0 "$R0\"
${Index_GetCleanDir}-finish:
  Pop $R1
  Exch $R0
  !undef Index_GetCleanDir
!macroend
 
; ################################################################
; similar to "RMDIR /r DIRECTORY", but does not remove DIRECTORY itself
; example: !insertmacro RemoveFilesAndSubDirs "$INSTDIR"
!macro RemoveFilesAndSubDirs DIRECTORY
  ; ATTENTION: USE ON YOUR OWN RISK!
  ; Please report bugs here: http://stefan.bertels.org/
  !define Index_RemoveFilesAndSubDirs 'RemoveFilesAndSubDirs_${__LINE__}'
 
  Push $R0
  Push $R1
  Push $R2
 
  !insertmacro GetCleanDir "${DIRECTORY}"
  Pop $R2
  FindFirst $R0 $R1 "$R2*.*"
${Index_RemoveFilesAndSubDirs}-loop:
  StrCmp $R1 "" ${Index_RemoveFilesAndSubDirs}-done
  StrCmp $R1 "." ${Index_RemoveFilesAndSubDirs}-next
  StrCmp $R1 ".." ${Index_RemoveFilesAndSubDirs}-next
  IfFileExists "$R2$R1\*.*" ${Index_RemoveFilesAndSubDirs}-directory
  ; file
  Delete "$R2$R1"
  goto ${Index_RemoveFilesAndSubDirs}-next
${Index_RemoveFilesAndSubDirs}-directory:
  ; directory
  RMDir /r "$R2$R1"
${Index_RemoveFilesAndSubDirs}-next:
  FindNext $R0 $R1
  Goto ${Index_RemoveFilesAndSubDirs}-loop
${Index_RemoveFilesAndSubDirs}-done:
  FindClose $R0
 
  Pop $R2
  Pop $R1
  Pop $R0
  !undef Index_RemoveFilesAndSubDirs
!macroend




;--------------------------------
;Multilanguage Support
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Dutch.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\French.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\German.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Korean.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Russian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Spanish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Swedish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\TradChinese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Slovak.nlf"
;--------------------------------
;--------------------------------
;Version Information

  VIProductVersion "1.2.3.4"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "LCAdressbookSQLite"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" "LCAdressbookSQLite Client"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "letztechance.org"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "no trademark"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "© 2014 by David Honisch"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "LCAdressbookSQLite"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "1.0.0"

;--------------------------------


Name "LCAdressbookSQLite"
Caption "LCAdressbookSQLite Install (c)by http://www.letztechance.org"
Icon "${NSISDIR}\Contrib\Graphics\Icons\lc.ico"
OutFile "LCAdressbookSQLiteinstall.exe"

SetDateSave on
SetDatablockOptimize on
CRCCheck on
SilentInstall normal
BGGradient FFFFFF A66E3C 000000
InstallColors A66E3C FFFFFF
XPStyle on

InstallDir "$PROGRAMFILES\LETZTECHANCE.ORG\LCAdressbookSQLite"
InstallDirRegKey HKLM "Software\LETZTECHANCE.ORG\LCAdressbookSQLite" "LCAdressbookSQLite"

CheckBitmap "${NSISDIR}\Contrib\Graphics\Checks\classic-cross.bmp"

;--------------------------------
;--------------------------------
;--------------------------------


LicenseText "HTTP://WWW.LETZTECHANCE.ORG"
LicenseData "readme.txt"

;--------------------------------
Page license
Page components
Page directory
Page instfiles

;--------------------------------

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------
;Function YESNO
;ClearErrors
;UserInfo::GetName
;IfErrors Win9x
;Pop $0
;UserInfo::GetAccountType
;Pop $1
;!if $1 != "Admin"
;MessageBox MB_YESNO "Startmenü Eintrag ohne Administrations Privilegien setzen ?" IDYES NoReadme
;      Exec notepad.exe ; view readme or whatever, if you want.
;	CreateShortCut "$SMPROGRAMS\$R0\All users LCAdressbookSQLite.lnk" $INSTDIR\LCAdressbookSQLite.exe
;Abort
;!else
;MessageBox MB_YESNO "Startmenü Eintrag mit Administrations Privilegien setzen ?" IDYES NoReadme
;      Exec notepad.exe ; view readme or whatever, if you want.
;	CreateShortCut "$SMPROGRAMS\$R0\All users LCAdressbookSQLite.lnk" $INSTDIR\LCAdressbookSQLite.exe
;!endif
;    NoReadme:
;
;FunctionEnd

Section
;Call YESNO
SectionEnd
;--------------------------------




!ifndef NOINSTTYPES ; only if not defined
  InstType "Die wichtigsten Komponenten"
  InstType "Komplett Installation"
  InstType "Empfohlene Installation"
  InstType "Basis Installation"
  ;InstType /NOCUSTOM
  ;InstType /COMPONENTSONLYONCUSTOM
!endif

AutoCloseWindow false
ShowInstDetails show

;--------------------------------

Section "" ; empty string makes it hidden, so would starting with -
;MessageBox MB_YESNO "Wollen Sie dieses Programm wirklich installieren ?" IDYES
  ; write reg info
  StrCpy $1 "POOOOOOOOOOOP"
  DetailPrint "I like to be able to see what is going on (debug) $1"
  WriteRegStr HKLM SOFTWARE\WWW.LETZTECHANCE.ORG\LCAdressbookSQLite "Install_Dir" "$INSTDIR"

  ; write uninstall strings
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LCAdressbookSQLite" "DisplayName" "LCAdressbookSQLite (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LCAdressbookSQLite" "UninstallString" '"$INSTDIR\uninst.exe"'
;---Extrahiere Dateien --------------------->
  SetOutPath $INSTDIR
  ;File /a "exe\LCAdressbookSQLite.exe"
  ;File /a "exe\*.*"
  File /a ".\install.zip"
  ;File /a /r "exe\Presents\*.*"	
  ;File /a "letztechance.org.url"
  ;File /a "favicon.ico"
;---Extrahiere HTML --------------------->
  ;CreateDirectory "$INSTDIR\html" ; 2 recursively create a directory for fun.
  ;SetOutPath $INSTDIR\html
;  File /a "html\search2.html"
  ;File /a "html\index.html"
  ;SetOutPath $INSTDIR\html\css
  ;File /a "html\css\*.*"
  ;File /a "html\iframe.html"
  ;File /a "html\addnav.html"
  ;File /a "css\lc.css"
  ;File /a "css\dc.css"
  ;File /a "html\index.html"
;---Extrahiere HTML --------------------->
;  CreateDirectory "$INSTDIR\WebSearch" ; WebSearch
;  SetOutPath $INSTDIR\WebSearch
;  File /a "exe\WebSearch\*.*"

  ;CreateDirectory "$INSTDIR\reg" ; 2 recursively create a directory for fun.
  WriteUninstaller "uninst.exe"
;---Extrahiere Bilder --------------------->
  ;CreateDirectory "$INSTDIR\images" ; 2 recursively create a directory for fun.
  ;SetOutPath $INSTDIR\images
  ;File /a "images\t.gif"
  ;File /a "images\bg.png"
  ;File /a "images\bg.jpg"
  ;File /a "images\help.jpg"
  ;File /a "images\start.jpg"
  ;File /a "images\title.jpg"
  ;File /a "images\update.jpg"
;---Extrahiere Bilder EOF--------------------->
;---Extrahiere Config --------------------->
;  CreateDirectory "$INSTDIR\config" ; 2 recursively create a directory for fun.
;  SetOutPath $INSTDIR\config
;  File /a "exe\config\*.*"
;---EOF Config --------------------->  
;---Extrahiere Daten --------------------->
  ;CreateDirectory "$INSTDIR\img\" ; 2 recursively create a directory for fun.
  ;SetOutPath $INSTDIR\img
  ;File /a "exe\img\*.*"  
;---Extrahiere Config Plugins EOF--------------------->
;---Extrahiere Config Plugins --------------------->
;  CreateDirectory "$INSTDIR\html\" ; 2 recursively create a directory for fun.
;  SetOutPath $INSTDIR\html
;  File /a "exe\html\*.*"  
;---Extrahiere Daten EOF --------------------->
;---Extrahiere Plugins --------------------->
;  CreateDirectory "$INSTDIR\Plugins" ; 2 recursively create a directory for fun.
;  SetOutPath $INSTDIR\plugins
;  File /a "exe\plugins\*.*"  
  ;CreateDirectory "$INSTDIR\plugins" ; 2 recursively create a directory for fun.
  ;SetOutPath $INSTDIR\plugins
  ;File /a "exe\plugins\*.*"  
;---Extrahiere Plugins EOF--------------------->
;---Extrahiere Plugins --------------------->
;  CreateDirectory "$INSTDIR\lib" ; 2 recursively create a directory for fun.
;  SetOutPath $INSTDIR\lib
;  File /a "exe\lib\*.*"  
;---Extrahiere Bilder EOF--------------------->
;---Extrahiere Images --------------------->
  ;CreateDirectory "$INSTDIR\img" ; 2 recursively create a directory for fun.
  ;SetOutPath $INSTDIR\img
  ;File /a "exe\img\*.*"  
;---Images EOF--------------------->
;---Extrahiere Data --------------------->
  
;---Extrahiere Data --------------------->
  ;CreateDirectory "$INSTDIR\pluginsupdate" ; 2 recursively create a directory for fun.
  ;SetOutPath $INSTDIR\pluginsupdate
  ;File /a "exe\pluginsupdate\*.*"  
;---Extrahiere Data --------------------->  
  ;CreateDirectory "$INSTDIR\data\database\" ; 2 recursively create a directory for fun.
  ;SetOutPath $INSTDIR\data\database
  ;File /a "exe\data\database\*.*"  
;---Images EOF--------------------->
  SetOutPath $INSTDIR
  Nop ; for fun

SectionEnd

Section "LCAdressbookSQLite"

SectionIn 1 2 3
;  Start: MessageBox MB_OK "Starte Installation"
;Start: MessageBox MB_YESNO "Wollen Sie dieses Programm wirklich installieren ?" IDYES Start

;MessageBox MB_YESNO "Wollen Sie dieses Programm wirklich installieren ?" IDYES

;  MessageBox MB_YESNO "Goto MyLabel" IDYES MyLabel

;  MessageBox MB_OK "Right before MyLabel:"

;  MyLabel: MessageBox MB_OK "MyLabel:"
  
;  MessageBox MB_OK "Right after MyLabel:"

;  MessageBox MB_YESNO "Goto Start:?" IDYES Start

SectionEnd

Section "Extract configuration files..." EXTRACT
InitPluginsDir
  SectionIn 1 2 3
   ;MessageBox MB_OK "Extract:"
  DetailPrint "------------------------"
  ;nsisunz::UnzipToStack "$INSTDIR\config.zip" "$INSTDIR"
  ;nsisunz::Unzip "$INSTDIR\config.zip" "$INSTDIR"
  
  ; Call plug-in. Push filename to ZIP first, and the dest. folder last.
  ;nsisunz::Unzip "$INSTDIR\install.zip" "$INSTDIR" 
  nsisunz::Unzip  "$INSTDIR\install.zip" "$INSTDIR" 
  ;Nsis7z::ExtractWithDetails "$INSTDIR\install.7z"
  ;Delete "$INSTDIR\install.zip"
  ; Always check result on stack
  Pop $0
  StrCmp $0 "success" ok
    DetailPrint "$0" ;print error message to log
  ok:
  DetailPrint "------------------------"
SectionEnd

SectionGroup /e Applikatonen

Section "Registry/INI functions"

SectionIn 1 4 3

  WriteRegStr HKLM SOFTWARE\LETZTECHANCE.ORG\LCAdressbookSQLite "StrTest_INSTDIR" "$INSTDIR"
  WriteRegDword HKLM SOFTWARE\LETZTECHANCE.ORG\LCAdressbookSQLite "DwordTest_0xDEADBEEF" 0xdeadbeef
  WriteRegDword HKLM SOFTWARE\LETZTECHANCE.ORG\LCAdressbookSQLite "DwordTest_123456" 123456
  WriteRegDword HKLM SOFTWARE\LETZTECHANCE.ORG\LCAdressbookSQLite "DwordTest_0123" 0123
  WriteRegBin HKLM SOFTWARE\LETZTECHANCE.ORG\LCAdressbookSQLite "BinTest_deadbeef01f00dbeef" "DEADBEEF01F00DBEEF"
;  StrCpy $8 "$SYSDIR\LC"
  WriteINIStr "$INSTDIR\lc.ini"  "LC2Applikationen" "Value1" $8
  WriteINIStr "$INSTDIR\lc.ini"  "server" "http://www.letztechance.org" $8
  WriteINIStr "$INSTDIR\lc.ini"  "LC2Ini" "Value1" $8
  WriteINIStr "$INSTDIR\lc.ini"  "LC2Ini" "Value2" $8
  WriteINIStr "$INSTDIR\lc.ini"  "LC2INI" "Value1" $8

  WriteINIStr "$INSTDIR\konfiguration.cfg"  "server" "name""http://www.letztechance.org"

  WriteINIStr "$INSTDIR\konfiguration.cfg"  "http" "download" "/read.php?f=3&i=30&t=30"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "http" "forum" "/"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "http" "suchen" "/?q=jssearch"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "http" "refresh" "30"

  WriteINIStr "$INSTDIR\konfiguration.cfg"  "groesse" "hoehe" "600"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "groesse" "breite" "800"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "update" "pfad" "/Suchen/"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "update" "datei" "search2.html"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "suchen" "dir" "/?q=jssearch"
  WriteINIStr "$INSTDIR\konfiguration.cfg"  "suchen" "main" "search2.html"


  Call MyFunctionTest

  DeleteINIStr "$INSTDIR\lc.ini" "LC2INI" "Value1"
  DeleteINISec "$INSTDIR\lc.ini" "LC2INi"

  ReadINIStr $1 "$INSTDIR\lc.ini" "LC2INi" "Value1"
  StrCmp $1 "" INIDelSuccess
    MessageBox MB_OK "DeleteINISec failed"
  INIDelSuccess:

  ClearErrors
;  ReadRegStr $1 HKCR "software\microsoft" xyz_¢¢_does_not_exist
;  IfErrors 0 NoError
;    MessageBox MB_OK "could not read from HKCR\software\microsoft\xyz_¢¢_does_not_exist"
;    Goto ErrorYay
;  NoError:
;    MessageBox MB_OK "read '$1' from HKCR\software\microsoft\xyz_¢¢_does_not_exist"
;  ErrorYay:
  
SectionEnd

Section "CreateShortCuts"
 CreateDirectory $SMPROGRAMS\$R0
 CreateDirectory $SMPROGRAMS\$R0\LETZTECHANCE.ORG
 CreateDirectory $SMPROGRAMS\$R0\LETZTECHANCE.ORG\LCAdressbookSQLite
 CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LCAdressbookSQLite\Start.LC2Launcher.lnk" $INSTDIR\LCAdressbookSQLite.exe
 CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LCAdressbookSQLite\LCAdressbookSQLite.lnk" $INSTDIR\LCAdressbookSQLite.exe
 CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LCAdressbookSQLite\_LC2Launcher.lnk" $INSTDIR\LCAdressbookSQLite.exe
 CreateShortCut "$INSTDIR\Update.lnk" $INSTDIR\LC2Start.NET.exe
 CreateShortCut "$DESKTOP\\LCAdressbookSQLite.exe.lnk" $INSTDIR\LC2Start.NET.exe
 CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LCAdressbookSQLite\AutoStart.lnk" $INSTDIR\LC2autostart.exe
 CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LCAdressbookSQLite\AutoStartConfig.lnk" $INSTDIR\LC2autostartConfig.exe
 CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LCAdressbookSQLite\AutoStartUninstall.lnk" $INSTDIR\LC2autostartUninstall.exe
 CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LCAdressbookSQLite\LC2Config.lnk" $INSTDIR\LC2Config.exe
 CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LCAdressbookSQLite\Uninstall.lnk" $INSTDIR\uninst.exe
 CreateShortCut "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LCAdressbookSQLite\Support.lnk" $INSTDIR\letztechance.org.url
  SectionIn 1 2 3

;  Call CSCTest

SectionEnd

Section ""
# Give ownership for file C:\test.txt to Waterloo\Mathias
;AccessControl::SetFileOwner \   "C:\test.txt" "Waterloo\Mathias"
# Make the directory "$INSTDIR\database" read write accessible by all users
AccessControl::GrantOnFile \
"$INSTDIR\" "(BU)" "GenericRead + GenericWrite"
 # Give all authentificated users (BUILTIN\Users) full access on
# the registry key HKEY_LOCAL_MACHINE\Software\Vendor\SomeApp
AccessControl::GrantOnRegKey \
HKLM "Software\letztechance.org" "(BU)" "FullAccess"
# Same as above, but with a numeric string SID
AccessControl::GrantOnRegKey \
HKLM "Software\letztechance.org" "(S-1-5-32-545)" "FullAccess"
# Same as above, but with a numeric string SID
#	AccessControl::GrantOnRegKey \
#    HKLM "Software\letztechance.org" "(S-1-5-32-545)" "FullAccess"	
SectionEnd

Section "Programm und Hilfe ausführen..." TESTIDX

  SectionIn 1 2 3
  
  SearchPath $1 $INSTDIR\LC2Start.NET.exe

;  MessageBox MB_OK "notepad.exe=$1"
  ;ExecShell "open" '"$INSTDIR\html\index.html"'
  ExecShell "open" '"http://www.letztechance.org"'
  ExecWait '"$1"'
  Sleep 500
  BringToFront

SectionEnd



Function MyFunctionTest

  ReadINIStr $1 "$INSTDIR\test.ini" "LC" "Value1"
  StrCmp $1 $8 NoFailedMsg
    MessageBox MB_OK "WriteINIStr failed"
  
  NoFailedMsg:

FunctionEnd

Function .onSelChange

  SectionGetText ${TESTIDX} $0
  StrCmp $0 "" e
    SectionSetText ${TESTIDX} ""
  Goto e2
e:
  SectionSetText ${TESTIDX} "Sections"
e2:

FunctionEnd
SectionGroupEnd
;--------------------------------

;Uninstaller

UninstallText "Uninstall LCAdressbookSQLite ?"
;UninstallIcon "${NSISDIR}\Contrib\Graphics\Icons\nsis1-uninstall.ico"
UninstallIcon "${NSISDIR}\Contrib\Graphics\Icons\lc.ico"

Section "Uninstall"

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LCAdressbookSQLite"
  DeleteRegKey HKLM "SOFTWARE\WWW.LETZTECHANCE.ORG\LCAdressbookSQLite"

;  Delete "$SMPROGRAMS\WWW.LETZTECHANCE.ORG\LCAdressbookSQLite\reg\*.*"
;  RMDir "$SMPROGRAMS\reg"
  Delete "$INSTDIR\reg\*.*"
  RMDir "$INSTDIR\reg"
  Delete "$INSTDIR\config\*.*"
  RMDir "$INSTDIR\config"
  
  Delete "$INSTDIR\data\img\*.*"
  RMDir "$INSTDIR\data\img"
  Delete "$INSTDIR\data\audio\*.*"
  RMDir "$INSTDIR\data\audio"
  Delete "$INSTDIR\data\*.*"
  RMDir "$INSTDIR\data"
  
  Delete "$INSTDIR\plugins\*.*"
  RMDir "$INSTDIR\plugins"
  
  !insertmacro RemoveFilesAndSubDirs "$INSTDIR\plugins"
  
  
  Delete "$INSTDIR\pluginsupdate\*.*"
  RMDir "$INSTDIR\pluginsupdate"
  ;shared
  Delete "$INSTDIR\shared\*.*"
  RMDir "$INSTDIR\shared"
  ;!insertmacro RemoveFilesAndSubDirs "$INSTDIR\lib"
  
  ;Delete "$INSTDIR\images\*.*"  
  ;RMDir "$INSTDIR\images"
  Delete "$INSTDIR\*.*"  
;  File /a "exe\lc2sys.dll"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\*.*"
  RMDir "$INSTDIR\"
  
  Delete "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LCAdressbookSQLite\LCAdressbookSQLite.lnk"
  Delete "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LCAdressbookSQLite\uninst.lnk"
  Delete "$SMPROGRAMS\$R0\LETZTECHANCE.ORG\LCAdressbookSQLite\*.*"
  ;RMDir "$SMPROGRAMS\$R0\LETZTECHANCE.ORG"
  ;RMDir "$SMPROGRAMS"
  !insertmacro RemoveFilesAndSubDirs "$INSTDIR"

  
;  MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to remove the directory $INSTDIR\cpdest?" IDNO ;NoDelete
;    Delete "$INSTDIR\cpdest\*.*"
;    RMDir "$INSTDIR\cpdest" ; skipped if no
;NoDelete:
  
;  RMDir "$INSTDIR\MyProjectFamily\MyProject"
;  RMDir "$INSTDIR\MyProjectFamily"
  RMDir "$INSTDIR\"
  RMDir "$INSTDIR"
  RMDir "$SMPROGRAMS"

  IfFileExists "$INSTDIR" 0 NoErrorMsg
    MessageBox MB_OK "Note: $INSTDIR could not be removed!" IDOK 0 ; skipped if file doesn't exist
  NoErrorMsg:

SectionEnd