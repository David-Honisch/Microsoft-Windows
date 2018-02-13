/* Replace "haonoi.h" with the name of your header */
#include "LC2Memory.h"
#include <windows.h>
#include <iostream>

#include <iostream>
#include <string>
#include <vector>

#include <ctype.h>

#include "..\..\include\config\lc2config.h"
#include "..\..\include\config\lc2config.cpp"

typedef std::vector<int> Turm;
typedef std::vector<Turm> Tuerme;

Tuerme tuerme;
typedef std::vector<string> SteinBild;

int scheiben;

LC2HANOI::LC2HANOI() {
	iAnzahlTuerme = 0;
	// int DLLFunc();
}

LC2HANOI::~LC2HANOI() {
	iAnzahlTuerme = 0;
}

//extern "C" __declspec(dllexport)void BoxProperties(double Length, double Height,
extern "C" _declspec(dllexport) int getConsoleInput(void);

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

extern "C" _declspec(dllexport) int getFunc() {
	MessageBox(NULL,"DLL Function 1","",MB_OK);
	return true;
}

extern "C" _declspec(dllexport) int __declspec(dllexport) __stdcall showMessageBox(char *TEXT) {
	MessageBox(NULL,TEXT,"",MB_OK);
	return true;
}

extern "C" _declspec(dllexport) char * getInfo()
{
	return "http://www.letztechance.org";
}

//extern "C" _declspec(dllexport) 
int getConsoleInput(void) {
	int check = 0;
	
	printf("Bitte geben Sie eine Anzahl von Scheiben an: ");

	check = scanf("%d", &scheiben);
	fflush( stdin); /* unter Linux entfernen */
	/* Ist check gleich 1, war die Eingabe richtig. */
	if (check == 1) {
		printf("Die Anzahl der Scheiben ist:%d\n", scheiben);
		//check = scanf("%d", &scheiben);
		fflush(stdin);
	} else {
		printf("Die Eingaben war falsch!\n");
		system("pause");
		//or exit(1);
		getConsoleInput();
	}
	printf("\nScheiben:%d\n", scheiben);
	system("pause");
	return 0;
}

void doCalc(int i) {
	system("cls");
}

extern "C" _declspec(dllexport) int doPrint(char * text)
{
	//system("cls");
	LC2Config cfg;
	cfg.setConsoleColor(15,0);
	printf(".____     ______________________________________________________\n");
	printf("|    |    \\_   _____/\\__    ___/\\____    /\\__    ___/\\_   _____/\n");
	printf("|    |     |    __)_   |    |     /     /   |    |    |    __)_ \n");
	printf("|    |___  |        \\  |    |    /     /_   |    |    |        \\\n");
	printf("|_______ \\/_______  /  |____|   /_______ \\  |____|   /_______  /\n");
	printf("        \\/        \\/                    \\/                   \\/ \n");
	cfg.setConsoleColor(10,0);
	printf("_________   ___ ___    _____    _______  _________ ___________  \n");
	printf("\\_   ___ \\ /   |   \\  /  _  \\   \\      \\ \\_   ___ \\\\_   _____/  \n");
	printf("/    \\  \\//    ~    \\/  /_\\  \\  /   |   \\/    \\  \\/ |    __)_   \n");
	printf("\\     \\___\\    Y    /    |    \\/    |    \\     \\____|        \\  \n");
	printf(" \\______  /\\___|_  /\\____|__  /\\____|__  /\\______  /_______  /  \n");
	printf("        \\/       \\/         \\/         \\/        \\/        \\/   \n");
	cfg.setConsoleColor(5,0);
	printf("     ________ __________  ________                              \n");
	printf("     \\_____  \\\\______   \\/  _____/                              \n");
	printf("      /   |   \\|       _/   \\  ___                              \n");
	printf("     /    |    \\    |   \\    \\_\\  \\                             \n");
	printf("  /\\ \\_______  /____|_  /\\______  /                             \n");
	printf("  \\/         \\/       \\/        \\/  \n");
	cfg.setConsoleColor(15,0);	
	printf("\n\nLC2HANOI v.1.0\n\n");
	cfg.setConsoleColor(14,0);	
	//LC2HANOI->doCalc(iAnzahlTuerme);
	//doCalc(iAnzahlTuerme);
	return 0;
}

SteinBild steinbild;

void male(const Tuerme& tuerme)//Visualisierungsfunktion
{
	int maxsize = 0;
	for (int i = 0; i < tuerme.size(); i++) {
		if (maxsize < tuerme[i].size())
			maxsize = tuerme[i].size();

		for (int i = maxsize - 1; i >= 0; i--) {
			int a = i < tuerme[0].size() ? tuerme[0][i] : 0;
			int b = i < tuerme[1].size() ? tuerme[1][i] : 0;
			int c = i < tuerme[2].size() ? tuerme[2][i] : 0;
			printf("%s         %s         %s\n",steinbild[a].c_str(),steinbild[b].c_str(),steinbild[c].c_str());
		}
	}
    printf("================================================================================\n");
	system("pause");
}

void Ziehe(int von, int nach, int ScheibenZahl) {

	int frei;
	if (ScheibenZahl == 0)
		return;// Bedingung zum Beenden
	frei = 6 - von - nach; //Bestimmung des freien Turms
	Ziehe(von, frei, ScheibenZahl - 1);
	int stein = tuerme[von - 1].back();
	tuerme[von - 1].pop_back();
	tuerme[nach - 1].push_back(stein);
	male(tuerme);
	//cout << von << " - " << nach << endl;//Ausgabe
	Ziehe(frei, nach, ScheibenZahl - 1);

}
extern "C" _declspec(dllexport) int doPrintResult(char * text)
{
	//system("cls");
	LC2Config cfg;
	cfg.setConsoleColor(14,0);
	//LC2HANOI->doCalc(iAnzahlTuerme);
	//	int scheiben;
	/*
	 cout << "Anzahl der Scheiben:\n";
	 cin >> scheiben;
	 getchar();
	 */
	printf("%d\n",scheiben);
	//
	cfg.setConsoleColor(12,0);
	cout<<"Loesung:\n";

	tuerme.resize(3);
 	int maxlength = 2.0*scheiben - 1;
	steinbild.resize(scheiben + 1);
	steinbild[0].resize(maxlength, ' ');
	for (int i = 1; i < scheiben + 1; i++)
	{
		int fill = 0.5 * (maxlength - (i*2-1));

		steinbild[i].resize(maxlength, ' ');
		steinbild[i].replace(fill, i * 2 - 1, i * 2 - 1, 'x');
		//steinbild[i].resize(maxlength, ' ');
		//steinbild[i].replace(steinbild[i].begin()+fill,steinbild[i].end()-fill,i * 2 - 1, 'x');
	}
	for (int i = scheiben; i >= 1; i--)
	{
		tuerme[0].push_back(i);

	}

	male(tuerme);
	Ziehe(1, 3, scheiben);

	getchar();
	return 0;
}
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

DWORD WINAPI LoopFunction( LPVOID lpParam )
{

    BYTE StandingON[] = {0x8B, 0x02, 0x90};
    BYTE CrouchingON[] = {0x8B, 0x11, 0x90};
    BYTE ProneON[] = {0x8B, 0x08, 0x90};
    BYTE StandingOFF[] = {0x8B, 0x42, 0x4C};
    BYTE CrouchingOFF[] = {0x8B, 0x51, 0x50};
    BYTE ProneOFF[] = {0x8B, 0x48, 0x54};

    bool Crosshair = false;

    HANDLE bf2142 = GetCurrentProcess();

    while(1) {
        if (GetAsyncKeyState(VK_F1)&0x80000) {
            if (Crosshair == true) {
                WriteProcessMemory(bf2142, (void*)(0x05E2C88), &StandingOFF, 3, 0);
                WriteProcessMemory(bf2142, (void*)(0x05E2C93), &CrouchingOFF, 3, 0);
                WriteProcessMemory(bf2142, (void*)(0x05E2C9E), &ProneOFF, 3, 0);
                Crosshair = false;

            }
            else if( Crosshair == false) {
                WriteProcessMemory(bf2142, (void*)(0x05E2C88), &StandingON, 3, 0);
                WriteProcessMemory(bf2142, (void*)(0x05E2C93), &CrouchingON, 3, 0);
                WriteProcessMemory(bf2142, (void*)(0x05E2C9E), &ProneON, 3, 0);
                Crosshair = true;
            }

        }
    }
//some CPU relief
    Sleep(200);
    return 0;
}


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
