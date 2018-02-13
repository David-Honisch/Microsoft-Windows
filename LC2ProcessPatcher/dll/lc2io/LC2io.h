#ifndef _LC2IO_H_
#define _LC2IO_H_


#if BUILDING_DLL
# define DLLIMPORT __declspec (dllexport)
#else /* Not BUILDING_DLL */
# define DLLIMPORT __declspec (dllimport)
#endif /* Not BUILDING_DLL */

class DLLIMPORT LC2io {
public:
	LC2io();
	virtual ~LC2io(void);
    BOOL LoadFile(HWND hEdit, LPSTR pszFileName);
    BOOL SaveFile(HWND hEdit, LPSTR pszFileName);
    BOOL DoFileOpenSave(HWND hwnd, BOOL bSave);
//	int log ();
private:

};




#endif  _LC2IO_H_ 
