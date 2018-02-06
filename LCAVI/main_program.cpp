#include "radc++.h"

Form form1("LCRadVideoPlayer C++ v.1.0");

ImageBox ibox(AUTO_ID,0,100,50,640,200,form1); //2nd arg : 0 = no image by default

//Create a container to play video in
// AUTO_ID is unique id of control (it is a macro)
// form is parent window of it
// 3rd argument is filename to play, see below

//Video avi(AUTO_ID,form1,"clock.avi");
Video avi(AUTO_ID,form1,"test.avi");


rad_main()
    
	
	avi.fitExact(); //fit exact to the parent form area
	
rad_end()
