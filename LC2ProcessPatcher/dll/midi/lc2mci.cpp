#include <iostream>
#include <windows.h>
#include <mmsystem.h>  // mciSendString()
#include <conio.h>
#include <string>

#include "lc2mci.h"


using namespace std;   // std::cout, std::cin

//typedef std::vector<int> midiFiles;
union {
   public:
   unsigned long word;
   unsigned char data[4];
} msg;

LC2MCI::LC2MCI() {
	// int DLLFunc();
}

LC2MCI::~LC2MCI() {
}
//Export function prototypes
extern "C" _declspec(dllexport) int setMCISendString(char * text);
extern "C" _declspec(dllexport) int doPlay(char * text);
extern "C" _declspec(dllexport) int doPlayInstrument(char * text);
extern "C" _declspec(dllexport) int doPlayInstruments(char * text);
extern "C" _declspec(dllexport) int doPlayNote(char * text, BYTE volume,BYTE note   );

//API
BOOL APIENTRY DllMain(HINSTANCE hInst /* Library instance handle. */,
		DWORD reason /* Reason this function is being called. */,
		LPVOID reserved /* Not used. */) {
	switch (reason) {
	case DLL_PROCESS_ATTACH:
		break;

	case DLL_PROCESS_DETACH:
		break;

	case DLL_THREAD_ATTACH:
		break;

	case DLL_THREAD_DETACH:
		break;
	}

	/* Returns TRUE on success, FALSE on failure */
	return TRUE;
}
//setMCISendString(char * text)
int setMCISendString(char * text)
{
    MCIERROR err;
    err = mciSendString(text,NULL,0,NULL);
	return 0;
}
//Ejecting devices...
int EjectCDDrive(char * text)
{
   std::cout << "Ejecting CD-Tray..." << std::endl;
    mciSendString("open cdaudio", 0, 0, 0);
    mciSendString("set cdaudio door open", 0, 0, 0);
    mciSendString("close cdaudio", 0, 0, 0);
 	return 0;
}
//play drums !!
//extern "C" _declspec(dllexport) 
int doPlayInstrument(char * text)
{
    HMIDIOUT hMidiOut;
    MCIERROR result;
    if(result != MMSYSERR_NOERROR)
//       ShowMessage("Error play instruments");
         printf("Error");
    BYTE volume = 127;
    BYTE note = 72;  // Ein C
    midiOutShortMsg(hMidiOut, (volume << 16) | (note << 8) | 0x91); // note on
    midiOutShortMsg(hMidiOut, (volume << 16) | (note << 8) | 0x81); // note off 
    midiOutClose(hMidiOut);

 	return 0; 	
}
int doPlayNote(char * text, BYTE volume,BYTE note   )
{
    HMIDIOUT hMidiOut;
    MCIERROR result;
    if(result != MMSYSERR_NOERROR)
//       ShowMessage("Error play instruments");
         printf("Error");
    //BYTE volume = 127;
    //BYTE note = 72;  // Ein C
    midiOutShortMsg(hMidiOut, (volume << 16) | (note << 8) | 0x91); // note on
    midiOutShortMsg(hMidiOut, (volume << 16) | (note << 8) | 0x81); // note off 
    midiOutClose(hMidiOut);

 	return 0; 	
}
//play instruments !!
//extern "C" _declspec(dllexport) 
int doPlayInstruments(char * text)
{
        if (midiOutGetNumDevs() < 1) return 1;
 
 
   int midiport = 0;
   HMIDIOUT midiDev;
   int note;
   msg.data[2] = 100;
   msg.data[3] = 0;
 
   midiOutOpen(&midiDev, midiport, 0, 0, CALLBACK_NULL);
 
   for (int i = 0 ; i <= 127; i++) {        // edit: nat. 0 bis 127
       note = 60;                           // Tonhöhe
 
       msg.data[0] = 0xC0;                  // Instrument festlegen
       msg.data[1] = i;
 
       midiOutShortMsg(midiDev, msg.word);
 
       msg.data[0] = 0x90;                  // Note an
       msg.data[1] = note;                  // Notenwert
 
       midiOutShortMsg(midiDev, msg.word);
 
       Sleep(150);
     
       msg.data[0] = 0x80;                  // Note aus
       msg.data[1] = note;                  // Notenwert
 
       midiOutShortMsg(midiDev, msg.word);  
   }
   midiOutClose(midiDev);
	return 0;
}
