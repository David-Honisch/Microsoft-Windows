#ifndef _LC2HANOI_H_
#define _LC2HANOI_H_

#if BUILDING_DLL
# define DLLIMPORT __declspec (dllexport)
#else /* Not BUILDING_DLL */
# define DLLIMPORT __declspec (dllimport)
#endif /* Not BUILDING_DLL */

class DLLIMPORT LC2HANOI {
public:
	LC2HANOI();
	virtual ~LC2HANOI(void);
	int getConsoleInput(void);
	void doCalc(int i);
	int doPrint(char * text);
	int doPrintResult(char * text);
	int log ();
private:
	int iAnzahlTuerme;

};

#endif  _LC2HANOI_H_ 
