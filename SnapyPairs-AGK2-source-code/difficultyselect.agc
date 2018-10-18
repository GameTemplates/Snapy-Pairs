/*
difficulty select screen
*/

//global to reference resources used in the difficulty select screen
global ds_easyButtonSpr as integer
global ds_easyButtonTxt as integer
global ds_normalButtonSpr as integer
global ds_normalButtonTxt as integer
global ds_hardButtonSpr as integer
global ds_hardButtonTxt as integer
global ds_difficulty as string

function loadDifficultySelect()
	
	//set background color
	SetClearColor(16, 150, 143)
	
	//clear previous state from memory
	clearState()
	
	//create easy button
	ds_easyButtonSpr = CreateSprite(global_buttonImg)
	SetSpriteSize(ds_easyButtonSpr, 200, 70)
	SetSpritePositionByOffset(ds_easyButtonSpr, windowWidth/2, 170)
	
	ds_easyButtonTxt = CreateText("EASY")
	SetTextSize(ds_easyButtonTxt,70)
	SetTextColor(ds_easyButtonTxt,68,133,191,255)
	SetTextPosition(ds_easyButtonTxt, GetSpriteX(ds_easyButtonSpr) + 40, GetSpriteY(ds_easyButtonSpr))
	
	//create normal button
	ds_normalButtonSpr = CreateSprite(global_buttonImg)
	SetSpriteSize(ds_normalButtonSpr, 200, 70)
	SetSpritePositionByOffset(ds_normalButtonSpr, windowWidth/2, GetSpriteY(ds_easyButtonSpr) + 110) 
	
	ds_normalButtonTxt = CreateText("NORMAL")
	SetTextSize(ds_normalButtonTxt,60)
	SetTextColor(ds_normalButtonTxt,68,133,191,255)
	SetTextPosition(ds_normalButtonTxt, GetSpriteX(ds_normalButtonSpr) + 5, GetSpriteY(ds_normalButtonSpr) + 5)
	
	//create hard button
	ds_hardButtonSpr = CreateSprite(global_buttonImg)
	SetSpriteSize(ds_hardButtonSpr, 200, 70)
	SetSpritePositionByOffset(ds_hardButtonSpr, windowWidth/2, GetSpriteY(ds_normalButtonSpr) + 110) 
	
	ds_hardButtonTxt = CreateText("HARD")
	SetTextSize(ds_hardButtonTxt,60)
	SetTextColor(ds_hardButtonTxt,68,133,191,255)
	SetTextPosition(ds_hardButtonTxt, GetSpriteX(ds_hardButtonSpr) + 40, GetSpriteY(ds_hardButtonSpr) + 5)
	
	
	gameState = "difficultyselect"
endfunction

function updateDifficultySelect()
	
	//if mouse is over button, swap colors and also set difficulty
	//EASY
	If GetSpriteHitTest(ds_easyButtonSpr, GetPointerX(), GetPointerY())
		SetTextColor(ds_easyButtonTxt, 68,133,191,255)
		if GetPointerPressed() then ds_difficulty = "Easy"
	else
		SetTextColor(ds_easyButtonTxt, 255,204,0,255)
	endif
	//NORMAL
	If GetSpriteHitTest(ds_normalButtonSpr, GetPointerX(), GetPointerY())
		SetTextColor(ds_normalButtonTxt, 68,133,191,255)
		if GetPointerPressed() then ds_difficulty = "Normal"
	else
		SetTextColor(ds_normalButtonSpr, 255,204,0,255)
	endif
	//HARD
	If GetSpriteHitTest(ds_hardButtonSpr, GetPointerX(), GetPointerY())
		SetTextColor(ds_hardButtonSpr, 68,133,191,255)
		if GetPointerPressed() then ds_difficulty = "Hard"
	else
		SetTextColor(ds_hardButtonSpr, 255,204,0,255)
	endif
	
	// if ds_difficulty is set, set values and load the game
	if NOT ds_difficulty = ""
		ResetTimer()
		if ds_difficulty = "Easy" 
			game_secondsToWait = 5 //displaying card animations before start for 5 seconds
		elseif ds_difficulty = "Normal" 
			game_secondsToWait = 3 //displaying card animations before start for 3 seconds
		elseif ds_difficulty = "Hard" 
			game_secondsToWait = 2 //displaying card animations before start only for 2 second
		endif
	
		game_cardNumber = 4 //we start the game with 4 cards
		game_targetTime = 300 //the game must be completed in 5 minutes
		loadGame()
	endif
	
endfunction
