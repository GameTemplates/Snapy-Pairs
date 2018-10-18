/*
this is the first screen where I mention you can get the source code at gametemplates.itch.io
*/

//globals to reference resources used in the splash1 screen
global splash1_TitleTxt as integer
global splash1_Txt as integer
global splash1_buttonSpr as integer
global splash1_buttonTxt as integer
global splash1_Time as float
global splash1_TimeTxt as integer

function loadSplash1()
	
	//set background color
	SetClearColor(16, 150, 143)
	
	//clear previous state from memory
	clearState()
	
	//create the title text
	splash1_TitleTxt = CreateText("Snapy Pairs")
	SetTextFont(splash1_TitleTxt, global_font)
	SetTextColor(splash1_TitleTxt,255,204,0,255)
	SetTextSize(splash1_TitleTxt, 150)
	SetTextPosition(splash1_TitleTxt, windowWidth/2 - 210, 10)
	
	//create text explaning you can get the source
	splash1_Txt = CreateText(" Get the full source code at" + Chr(10) + "www.gametemplates.itch.io")
	SetTextSize(splash1_Txt, 50)
	SetTextPosition(splash1_Txt, windowWidth/2 - 250, GetTextY(splash1_TitleTxt) + 150)
	
	//create visit website button
	splash1_buttonSpr = CreateSprite(global_buttonImg)
	SetSpriteSize(splash1_buttonSpr, 200,50)
	SetSpritePositionByOffset(splash1_buttonSpr, windowWidth/2, GetTexty(splash1_Txt) + 130)
	
	splash1_buttonTxt = CreateText("Visit Website")
	SetTextFont(splash1_buttonTxt, global_font)
	SetTextColor(splash1_buttonTxt, 255,204,0,255)
	SetTextSize(splash1_buttonTxt, 60)
	SetTextPosition(splash1_buttonTxt, GetSpriteX(splash1_buttonSpr) + 5, GetSpriteY(splash1_buttonSpr) - 5)
	
	//create text displaying when the game start
	splash1_TimeTxt = CreateText("The game will start in: " + Str(splash1_Time))
	SetTextFont(splash1_TimeTxt, global_font)
	SetTextColor(splash1_TimeTxt,255,204,0,255)
	SetTextSize(splash1_TimeTxt, 70)
	SetTextPosition(splash1_TimeTxt, windowWidth/2 - 210, GetSpriteY(splash1_buttonSpr) + 50)
	
	gameState = "splash1"
endfunction

function updateSplash1()
	//chance text color when mouse if over the button
	If GetSpriteHitTest(splash1_buttonSpr, GetPointerX(), GetPointerY())
		SetTextColor(splash1_buttonTxt, 68,133,191,255)
	else
		SetTextColor(splash1_buttonTxt, 255,204,0,255)
	endif
	
	//go to website when the button is clicked
	if GetPointerPressed()
		if GetSpriteHitTest(splash1_buttonSpr, GetPointerX(), GetPointerY()) then OpenBrowser("gametemplates.itch.io")
	endif
	
	//update timer and text
	splash1_Time = splash1_Time + 1 * GetFrameTime()
	SetTextString(splash1_TimeTxt,"The game will start in: " + Str(floor(10 - splash1_Time)))
	
	//after 10 seconds, continue to splash2
	if splash1_Time >= 10 then loadSplash2()
	
endfunction
