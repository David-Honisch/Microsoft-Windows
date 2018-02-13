#ifndef _LC2MCI_H_
#define _LC2MCI_H_

#if BUILDING_DLL
# define DLLIMPORT __declspec (dllexport)
#else /* Not BUILDING_DLL */
# define DLLIMPORT __declspec (dllimport)
#endif /* Not BUILDING_DLL */
//#include <string>

class DLLIMPORT LC2MCI {
public:
	LC2MCI();
	virtual ~LC2MCI(void);
	int setMCISendString(char * text);
	int EjectCDDrive(char * text);
    int doPlayInstrument(char * text);
	int doPlayInstruments(char * text);
	int doPlayNote(char * text, BYTE volume,BYTE note);
private:


};

#endif  _LC2MCI_H_
