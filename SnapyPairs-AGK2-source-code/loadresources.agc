
/*
load resources that is globally used in the game, you may prefer to load resources at the beginning of each level but since we have only one level in this game, I load everything here.
*/

//globals to store reference to each resources used globally in the game
global global_cardImg as integer[20]
global global_shadowImg as integer
global global_cardFlipSound as integer[2]
global global_cardSlideSound as integer[7]
global global_buttonImg as integer
global global_font as integer
global global_menuMusic as integer
global global_exitImg as integer
global global_helpButtonImg as integer
global global_musicButtonImg as integer[1]
global global_soundButtonImg as integer[1]
global global_logoImg as integer

type cardObject
	sprite as integer
	animation as integer
	tween as integer
endtype

function loadResources()
	
	//laod sound and music state
	loadSoundState()
	loadMusicState()
	
	//load card images
	for i = 0 to 20
		global_cardImg[i] = LoadImage("images/card" + Str(i) + ".png")
	next i
	
	//create a tranpsarent dark image used as a shadow below the cards
	global_shadowImg = CreateImageColor(0,0,0,100)
	
	//load the image used for buttons
	global_buttonImg = LoadImage("images/blue_button05.png")
	
	//load exit icon image
	global_exitImg = LoadImage("images/return.png")
	
	//load music icon image
	global_musicButtonImg[0] = LoadImage("images/musicOn.png")
	global_musicButtonImg[1] = LoadImage("images/musicOff.png")
	
	//load sound icon image
	global_soundButtonImg[0] = LoadImage("images/audioOn.png")
	global_soundButtonImg[1] = LoadImage("images/audioOff.png")
	
	//load help icon image
	global_helpButtonImg = LoadImage("images/question.png")
	
	//load logo image
	global_logoImg = LoadImage("images/snapy_pairs_logo.png")
	
	//load flip sounds
	for i = 0 to 2
		global_cardFlipSound[i] = LoadSoundOgg("sounds/cardPlace" + Str(i+1) + ".ogg")
	next i
	
	//load slide sounds
	for i = 0 to 7
		global_cardSlideSound[i] = LoadSoundOGG("sounds/cardSlide" + Str(i+1) + ".ogg")
	next i
	
	//load font
	global_font = LoadFont("font/Pacifico-Regular.ttf")
	
	//load music to play it in main menu
	global_menuMusic = LoadMusicOGG("music/Puzzle-Game-2.ogg")
endfunction

function clearState()
	ClearScreen()
	DeleteAllSprites()
	DeleteAllText()
	Sync()
endfunction

function loadSoundState()
	//if the save file exists, load it value otherwise we are using the defailt value which is 1 and set in the main.agc
	if GetFileExists("_soundOn")
		file = OpenToRead("_soundOn")
		soundOn = ReadInteger(file)
		CloseFile(file)
	endif
endfunction

function loadMusicState()
	//if the save file exists, load it value otherwise we are using the default value which is 1 and set in the main.agc
	if GetFileExists("_musicOn")
		file = OpenToRead("_musicOn")
		musicOn = ReadInteger(file)
		CloseFile(file)
	endif
endfunction

function saveSoundState()
	//open the file and save the value of soundOn variable
	file = OpenToWrite("_soundOn")
	WriteInteger(file, soundOn)
	CloseFile(file)
endfunction

function saveMusicState()
	//open the file and save the value of musicOn variable
	file = OpenToWrite("_musicOn")
	WriteInteger(file, musicOn)
	CloseFile(file)
endfunction
