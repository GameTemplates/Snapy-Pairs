
/*
This is the splash screen to give attribution to Eric Matyas
*/

//globals to reference resources used on this screen
global splash2_Txt as integer
global splash2_Time as float

function loadSplash2()
	
	//set background color
	SetClearColor(16, 150, 143)
	
	//clear previous state from memory
	clearState()
	
	
	//Create Text
	splash2_Txt = CreateText("Music by Eric Matyas" + Chr(10) + "www.soundimage.org")
	SetTextColor(splash2_Txt, 255,204,0,255)
	SetTextSize(splash2_Txt, 70)
	SetTextPosition(splash2_Txt, windowWidth/2 - 270, windowHeight/2 - 100)
	
	gameState = "splash2"
endfunction

function updateSplash2()
	
	//after 5 seconds, move on to the main menu
	splash2_Time = splash2_Time + 1 * GetFrameTime()
	if splash2_Time >= 5 then loadMainMenu()
	
endfunction
