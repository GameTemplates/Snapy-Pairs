/*
decribing how to play the game
*/

//globals to store reference to resources used in the help screen
global help_Txt as integer
global help_buttonSpr as integer
global help_buttonTxt as integer

function loadHelp()
	
	//set background color
	SetClearColor(16, 150, 143)
	
	//clear previous state from memory
	clearState()
	
	//create text explanining how to play the game
	text$ ="At the beginning, the game show you each card for a short time, try to remember the cards."
	text$ = text$ + Chr(10) + "You need to turn two cards and find the pair of each card as soon as you can."
	text$ = text$ + Chr(10) + "You have 5 minutes to complete the game"
	help_Txt = CreateText(text$)
	SetTextSize(help_Txt, 28)
	SetTextPosition(help_Txt, 10,30)
	
	//create button
	help_buttonSpr = CreateSprite(global_buttonImg)
	SetSpriteSize(help_buttonSpr, 200,50)
	SetSpritePositionByOffset(help_buttonSpr, windowWidth/2, windowHeight - 100)
	
	help_buttonTxt = CreateText("Back")
	SetTextFont(help_buttonTxt, global_font)
	SetTextColor(help_buttonTxt, 255,204,0,255)
	SetTextSize(help_buttonTxt, 60)
	SetTextPosition(help_buttonTxt, GetSpriteX(help_buttonSpr) + 60, GetSpriteY(help_buttonSpr) - 8)
	
	gameState = "help"
endfunction

function updateHelp()
	
	//chance text color when mouse if over the button
	If GetSpriteHitTest(help_buttonSpr, GetPointerX(), GetPointerY())
		SetTextColor(help_buttonTxt, 68,133,191,255)
	else
		SetTextColor(help_buttonTxt, 255,204,0,255)
	endif
	
	//go back to main menu when the button is pressed
	if GetPointerPressed()
		if GetSpriteHitTest(help_buttonSpr, GetPointerX(), GetPointerY()) then loadMainMenu()
	endif
	
endfunction
