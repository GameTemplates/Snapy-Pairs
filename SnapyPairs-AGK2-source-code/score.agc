/*
the score screen 
*/

//globals used to reference resources required on the score screen
global score_Txt as integer
global score_bestScoreTxt as integer
global score_bestScore as integer
global score_bestScoreFile as string
global score_restartButtonSpr as integer
global score_restartButtonTxt as integer

function loadScore()
	
	//set background color
	SetClearColor(16, 150, 143)
	
	//clear previous state from memory
	clearState()
	
	//reset best score value to 10000 this is because in this case the lower value the better and 0 would be the best score
	score_bestScore = 10000
	
	//set the best score save file at current difficulty level
	score_bestScoreFile = "_"+ds_difficulty+"bestscore"
	
	//attempt to load the best score at current difficulty level
	if GetFileExists(score_bestScoreFile)
		file = OpenToRead(score_bestScoreFile)
		score_bestScore = ReadInteger(file)
		CloseFile(file)
	endif
	
	//check if the current time is less or equal to the best score, if it is, save the current time as the best time at current difficulty level
	if Floor(game_Time) <= score_bestScore
		file = OpenToWrite(score_bestScoreFile)
		WriteInteger(file, floor(game_Time))
		CloseFile(file)
		score_bestScore = floor(game_Time)
	endif
	
	
	//create text displaying our time
	if game_time < game_targetTime then text$ = "                      Your time is " + Str(floor(game_Time)) + " seconds at " + ds_difficulty + " difficulty"
	if game_time >= game_targetTime then text$ = "                                     Sorry, you run out of time"
	score_Txt = CreateText(text$)
	SetTextY(score_Txt, 30)
	SetTextColor(score_Txt,  255,204,0,255)
	SetTextSize(score_Txt, 40)
	
	//create best score text
	score_bestScoreTxt = CreateText("                          Your best time at " + ds_difficulty + " was " + Str(score_bestScore) + " seconds")
	SetTextColor(score_bestScoreTxt, 255,204,0,255)
	SetTextSize(score_bestScoreTxt, 40)
	SetTextPosition(score_bestScoreTxt, 0, GetTextY(score_Txt) + 30)
	
	//create restart button and text
	score_restartButtonSpr = CreateSprite(global_buttonImg)
	SetSpriteSize(score_restartButtonSpr, 200,50)
	SetSpritePositionByOffset(score_restartButtonSpr, windowWidth/2, windowHeight - 100)
	
	score_restartButtonTxt = CreateText("RESTART")
	SetTextFont(score_restartButtonTxt, global_font)
	SetTextColor(score_restartButtonTxt, 255,204,0,255)
	SetTextSize(score_restartButtonTxt, 60)
	SetTextPosition(score_restartButtonTxt, GetSpriteX(score_restartButtonSpr) + 15, GetSpriteY(score_restartButtonSpr) - 5)
	
	gameState = "score"
endfunction

function updateScore()
	
	//if pointer is over button, swap colors
	If GetSpriteHitTest(mm_startGameButtonSpr, GetPointerX(), GetPointerY())
		SetTextColor(score_restartButtonTxt, 68,133,191,255)
	else
		SetTextColor(score_restartButtonTxt, 255,204,0,255)
	endif
	
	//if start game button is clicked, go to main menu
	if GetPointerPressed()
		if GetSpriteHitTest(score_restartButtonSpr, GetPointerX(), GetPointerY()) then loadMainMenu()
	endif
	
endfunction
