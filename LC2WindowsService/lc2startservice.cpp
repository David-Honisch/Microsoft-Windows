#include <stdio.h>
#include <windows.h>
#include <string>

int main(int argc,char * argv[])
{
	printf("LetzteChance.Org Service Installer v.1.0");
	std::string prg = "";
	if (argc >= 2)
	{
		prg = argv[1];
		system("@ECHO OFF");
		system("cls");
		system("REM The following directory is for .NET 2.0");
		system("set DOTNETFX2=%SystemRoot%\\Microsoft.NET\\Framework\\v2.0.50727");
		system("set PATH=%PATH%;%DOTNETFX2%");
		system("echo Installing WindowsService...");
		system("echo ---------------------------------------------------");
		system(("%SystemRoot%\\Microsoft.NET\\Framework\\v2.0.50727\\InstallUtil /i "+prg).c_str());
		system("echo ---------------------------------------------------");
		//system("echo ---------------------------------------------------");
	}
	else
	{
		printf("\nUsage:lc2startservice.exe <service>");
		printf("\n\n");
		printf("Please type in the full path of the service .exe file.");	
	}
	system("pause");
	system("@ECHO ON");
}
