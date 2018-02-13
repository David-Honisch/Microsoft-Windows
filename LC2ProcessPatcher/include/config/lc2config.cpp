/*
 David Honisch
 */
#include "windows.h"
#include "lc2config.h"

#include "..\windows\lc2windows.h"
#include "..\windows\lc2windows.cpp"

#define BUFSIZE MAX_PATH

#define schwarz 0
#define blau 1
#define gruen 2
#define cyan 3
#define rot 4
#define magenta 5
#define braun 6
#define hellgrau 7
#define dunkelgrau 8
#define hellblau 9
#define hellgruen 10
#define hellcyan 11
#define hellrot 12
#define hellmagenta 13
#define gelb 14
#define weiss 15
#define hellgelb 16

string glbStrTitle = "LC2Config";
string glbStrVersion = "1.0";

LC2Config::LC2Config(void) {
	//printf("1st Construct\n");
}
//typedef void (CALLBACK* f_print)(char * text);

const char * dllcore = "LC2Core.dll";
const char * dllconfig = "LC2Config.dll";
const char * dllmci = "LC2mci.dll";
const char * dllsystem = "LC2System.dll";
//-----------------------------------------------------------
//-----------------------------------------------------------
const char * LC2Config::getDLLConfig() {
	return dllconfig;
}

const char * LC2Config::getDLLCore() {
	return dllcore;
}
const char * LC2Config::getDLLmci() {
	return dllmci;
}
//-----------------------------------------------------------
//-----------------------------------------------------------
string LC2Config::getCWD() {
	char buffer[MAX_PATH];
	GetModuleFileName(NULL, buffer, MAX_PATH);
	string::size_type pos = string(buffer).find_last_of("\\/");
	return string(buffer).substr(0, pos);
}


int LC2Config::setConsoleColor(int Text, int Hintergrund) {
	int Colour = Text + 16 * Hintergrund;
	SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), Colour);
}

void LC2Config::printHeader() {
	system("cls");
	printf(".____     ______________________________________________________\n");
	printf(
			"|    |    \\_   _____/\\__    ___/\\____    /\\__    ___/\\_   _____/\n");
	printf("|    |     |    __)_   |    |     /     /   |    |    |    __)_ \n");
	printf(
			"|    |___  |        \\  |    |    /     /_   |    |    |        \\\n");
	printf(
			"|_______ \\/_______  /  |____|   /_______ \\  |____|   /_______  /\n");
	printf(
			"        \\/        \\/                    \\/                   \\/ \n");
	printf("_________   ___ ___    _____    _______  _________ ___________  \n");
	printf(
			"\\_   ___ \\ /   |   \\  /  _  \\   \\      \\ \\_   ___ \\\\_   _____/  \n");
	printf(
			"/    \\  \\//    ~    \\/  /_\\  \\  /   |   \\/    \\  \\/ |    __)_   \n");
	printf(
			"\\     \\___\\    Y    /    |    \\/    |    \\     \\____|        \\  \n");
	printf(
			" \\______  /\\___|_  /\\____|__  /\\____|__  /\\______  /_______  /  \n");
	printf(
			"        \\/       \\/         \\/         \\/        \\/        \\/   \n");
	printf("     ________ __________  ________                              \n");
	printf(
			"     \\_____  \\\\______   \\/  _____/                              \n");
	printf(
			"      /   |   \\|       _/   \\  ___                              \n");
	printf(
			"     /    |    \\    |   \\    \\_\\  \\                             \n");
	printf(
			"  /\\ \\_______  /____|_  /\\______  /                             \n");
	printf("  \\/         \\/       \\/        \\/  \n");
}

void LC2Config::display() const {
	printf("Initializing Configuration...\n");
}
void LC2Config::print() {
	printf("FREE PRINT\n");
}
string LC2Config::getTitle() {
	return glbStrTitle;
}
void LC2Config::setTitle(string value) {
	glbStrTitle = value;
}
string LC2Config::getVersion() {
	return glbStrVersion;
}
string LC2Config::getPrgNameAndVersion() {
	return glbStrTitle + " v." + glbStrVersion;
}

string LC2Config::getPrgName() {
	return this->glbPrgName;
}
void LC2Config::setPrgName(string argv) {
	this->glbPrgName = argv;
}
