/*
main menu screen
*/

//globls used to reference resources required in the main menu screen
global mm_TitleTxt as integer
global mm_startGameButtonSpr as integer
global mm_startGameButtonTxt as integer
global mm_musicButtonSpr as integer
global mm_soundButtonSpr as integer
global mm_helpButtonSpr as integer
global mm_logoSpr as integer

function loadMainMenu()
	
	//set background color
	SetClearColor(16, 150, 143)
	
	//clear previous state from memory
	clearState()
	
	//reset values
	ds_difficulty = "" //if we don't do this, when we restart the game, it is going to skip the difficulty selection screen
	
	//create title text
	mm_TitleTxt = CreateText("Snapy Pairs")
	SetTextFont(mm_TitleTxt, global_font)
	SetTextColor(mm_TitleTxt,255,204,0,255)
	SetTextSize(mm_TitleTxt, 150)
	SetTextPosition(mm_TitleTxt, windowWidth/2 - 210, 10)
	
	//create start game button
	mm_startGameButtonSpr = CreateSprite(global_buttonImg)
	SetSpriteSize(mm_startGameButtonSpr, 200,50)
	SetSpritePositionByOffset(mm_startGameButtonSpr, windowWidth/2, windowHeight - 100)
	
	mm_startGameButtonTxt = CreateText("START")
	SetTextFont(mm_startGameButtonTxt, global_font)
	SetTextColor(mm_startGameButtonTxt, 255,204,0,255)
	SetTextSize(mm_startGameButtonTxt, 60)
	SetTextPosition(mm_startGameButtonTxt, GetSpriteX(mm_startGameButtonSpr) + 40, GetSpriteY(mm_startGameButtonSpr) - 5)
	
	//create music button
	mm_musicButtonSpr = CreateSprite(global_musicButtonImg[0])
	SetSpritePosition(mm_musicButtonSpr, GetScreenBoundsRight() - 50, GetScreenBoundsBottom() - 50)
	SetSpriteColor(mm_musicButtonSpr, 255,204,0,255)
	if musicOn = 0 then SetSpriteImage(mm_musicButtonSpr, global_musicButtonImg[1]) //set animation of music button to off if the music is off
	
	//create sound button
	mm_soundButtonSpr = CreateSprite(global_soundButtonImg[0])
	SetSpritePosition(mm_soundButtonSpr, GetScreenBoundsRight() - 50, GetScreenBoundsBottom() - 100)
	SetSpriteColor(mm_soundButtonSpr, 255,204,0,255)
	if soundOn = 0 then SetSpriteImage(mm_soundButtonSpr, global_soundButtonImg[1]) //set animation of sound button to off if the music is off
	
	//create help button
	mm_helpButtonSpr = CreateSprite(global_helpButtonImg)
	SetSpritePosition(mm_helpButtonSpr, GetScreenBoundsRight() - 50, GetScreenBoundsBottom() - 150)
	SetSpriteColor(mm_helpButtonSpr, 255,204,0,255)
	
	//create logo sprite
	mm_logoSpr = CreateSprite(global_logoImg)
	SetSpritePositionByOffset(mm_logoSpr, windowWidth/2, windowHeight/2)
	
	
	//play music if music is on
	if musicOn = 1
		if NOT GetMusicPlayingOGG(global_menuMusic) then PlayMusicOGG(global_menuMusic,1)
	endif
	
	//set music volume
	SetMusicVolumeOGG(global_menuMusic, musicVolume)
	
	gameState = "mainmenu"
endfunction

function updateMainMenu()
	
	//if pointer is over button, swap colors
	If GetSpriteHitTest(mm_startGameButtonSpr, GetPointerX(), GetPointerY())
		SetTextColor(mm_startGameButtonTxt, 68,133,191,255)
	else
		SetTextColor(mm_startGameButtonTxt, 255,204,0,255)
	endif
	
	//if the music button is clicked, change it animation and toggle the music on and off and save the state of the music
	if GetPointerPressed()
		if GetSpriteHitTest(mm_musicButtonSpr, GetpointerX(), GetPointerY())
			if GetSpriteImageID(mm_musicButtonSpr) = global_musicButtonImg[0]
				SetSpriteImage(mm_musicButtonSpr, global_musicButtonImg[1])
				StopMusicOGG(global_menuMusic)
				musicOn = 0
			else
				SetSpriteImage(mm_musicButtonSpr, global_musicButtonImg[0])
				PlayMusicOGG(global_menuMusic,1)
				musicOn = 1
			endif 
			saveMusicState() //save the state of the music, this function is declared in loadresources.agc
		endif
	endif
	
	//if the sound button is clicked, change it animation and toggle the sound on and off and save the state of the sound
	if GetPointerPressed()
		if GetSpriteHitTest(mm_soundButtonSpr, GetpointerX(), GetPointerY())
			if GetSpriteImageID(mm_soundButtonSpr) = global_soundButtonImg[0]
				SetSpriteImage(mm_soundButtonSpr, global_soundButtonImg[1])
				soundOn = 0
			else
				SetSpriteImage(mm_soundButtonSpr, global_soundButtonImg[0])
				soundOn = 1
			endif
			saveSoundState() //save the state of the sound, this function is declared in loadresources.agc 
		endif
	endif
	
	//if start game button is clicked, go to difficulty select screen
	if GetPointerPressed()
		if GetSpriteHitTest(mm_startGameButtonSpr, GetPointerX(), GetPointerY()) then loadDifficultySelect()
	endif
	
	//if the help button is clicked, go to the help screen
	if GetPointerPressed()
		if GetSpriteHitTest(mm_helpButtonSpr, GetPointerX(), GetPointerY()) then loadHelp()
	endif
	
endfunction
