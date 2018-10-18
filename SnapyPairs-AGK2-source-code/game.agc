/*
the actual game screen
*/

//globals to store reference to resources required in the game state
global game_card as cardObject[20]
global game_availableImg as integer[20]
global game_cardNumber as integer //number of cards on the screen, we start with 4 set at the difficulty screen
global game_flipCount as integer //to count how many cards we flipped
global game_flipCard1Spr as integer //to store the sprite id of the cards flipped 
global game_flipCard2Spr as integer //
global game_flipCard1Animation as integer //to store the animation of the cards being flipped
global game_flipCard2Animation as integer //
global game_totalFlips as integer //to count total flips so we know when we have all the cards flipped
global game_Time as float //to store elapsed time since the beginning of the game
global game_canStart as integer // to referene if the game can start now
global game_secondsToWait as integer //how long the card animations going to be displayed before we start the game, it is set at the difficulty screen
global game_targetTime as integer //the game must be completed in 5 minutes by default, it is set at the difficulty screen
global game_exitButtonSpr as integer //the buutton used to go back to main menu if want to
global game_musicButtonSpr as integer //store referene to music button sprite 
global game_soundButtonSpr as integer //store reference to the sound button sprite
global game_flipDelayTimer as float //a timer to flip cards back with a delay we also use this at the end when all the cards turned to delay the beginning of the next turn a little

function loadGame()

	//set background color
	SetClearColor(16, 150, 143)
	
	//clear previous state from memory
	clearState()
	
	//reset values
	game_totalFlips = 0
	game_canStart = 0
	game_flipDelayTimer = 0
	
	//create exit button in the to left corner
	game_exitButtonSpr = CreateSprite(global_exitImg)
	SetSpritePosition(game_exitButtonSpr, GetScreenBoundsLeft(), GetScreenBoundsTop())
	SetSpriteColor(game_exitButtonSpr, 255,204,0,255)
	
	//create music button
	game_musicButtonSpr = CreateSprite(global_musicButtonImg[0])
	SetSpritePosition(game_musicButtonSpr, GetScreenBoundsRight() - 50, GetScreenBoundsBottom() - 50)
	SetSpriteColor(game_musicButtonSpr, 255,204,0,255)
	if musicOn = 0 then SetSpriteImage(game_musicButtonSpr, global_musicButtonImg[1]) //set animation of music button to off if the music is off
	
	//create sound button
	game_soundButtonSpr = CreateSprite(global_soundButtonImg[0])
	SetSpritePosition(game_soundButtonSpr, GetScreenBoundsRight() - 50, GetScreenBoundsBottom() - 100)
	SetSpriteColor(game_soundButtonSpr, 255,204,0,255)
	if soundOn = 0 then SetSpriteImage(game_soundButtonSpr, global_soundButtonImg[1]) //set animation of sound button to off if the music is off
	
	//create a shadow below the cards, we set position and size when we create the cards
	shadow = CreateSprite(global_shadowImg)
	shadowTween = CreateTweenSprite(1.0)
	
	//mark all images in a second array as available (1) that we are going to use to mark with a (0) the images have been picked to make sure we can pick each image only once
	for i = 1 to 20
		game_availableImg[i] = 1
	next i
	
	//set starting x and y position based on number of cards we are playing with
	select game_cardNumber
		case 4
			x = 270
			y = 150
			endcase
		case 6
			x = 200
			y = 150
			endcase
		case 8
			x = 270
			y = 130
			endcase
		case 10
			x = 250
			y = 130
			endcase
		case 12
			x = 270
			y = 70
			endcase
		case 14
			x = 180
			y = 130
			endcase
		case 16
			x = 280
			y = 10
			endcase
		case 18
			x = 210
			y = 70
			endcase
		case 20
			x = 250
			y = 10
			endcase
	endselect

	//create cards on the screen
	count = game_cardNumber
	for i = 1 to game_cardNumber
		game_card[i].sprite = CreateSprite(global_cardImg[0])
		game_card[i].animation = 0
		SetSpriteScale(game_card[i].sprite, 0.6,0.6)
		
		//add tween to the cards so they move in to their position
		game_card[i].tween = CreateTweenSprite(1.0)
		SetTweenSpriteX(game_card[i].tween, 0,x, TweenEaseOut2() )
		SetTweenSpriteY(game_card[i].tween, 0,y, TweenEaseOut2() )
		SetTweenSpriteAngle( game_card[i].tween, 0,0, TweenEaseOut2() )
		PlayTweenSprite( game_card[i].tween, game_card[i].sprite, 0)
		
		//play a random slide sound
		if soundOn = 1 then PlaySound(global_cardSlideSound[random(4,5)], soundVolume) //pick a sound only in range 4,5 as it sounds better to me but you can choose from 8 sounds in range  0-7
		
		//update tween and the screen to make the cards move in to position one by one we also do this at the end of the loop
		UpdateAllTweens( getframetime() )
		Sync()
		
		//increase the x position of the next card with 1 pixel gap between each, this is to avoid a bug when you can flip two cards the same time
		x = x + GetSpriteWidth(game_card[i].sprite) + 1
		
		//update x and y position to create rows based on number of cards, also tween the size of the shadow so it appears as the cards move in to position
		select game_cardNumber
			case 4 //1 row
				SetSpritePosition(shadow, 270,150)
				SetTweenSpriteSizeX(shadowTween,0,GetSpriteWidth(game_card[i].sprite)*4 + 7, TweenEaseOut2())
				SetTweenSpriteSizeY(shadowTween,0,GetSpriteHeight(game_card[i].sprite) + 5, TweenEaseOut2() )
				SetTweenSpriteAlpha(shadowTween,0,255,TweenEaseOut2())
				PlayTweenSprite( shadowTween, shadow, 0.2)
			endcase
			case 6 // 1 row
				SetSpritePosition(shadow, 200,150)
				SetTweenSpriteSizeX(shadowTween,0,GetSpriteWidth(game_card[i].sprite)*6 + 9, TweenEaseOut2())
				SetTweenSpriteSizeY(shadowTween,0,GetSpriteHeight(game_card[i].sprite) + 5, TweenEaseOut2() )
				SetTweenSpriteAlpha(shadowTween,0,255,TweenEaseOut2())
				PlayTweenSprite( shadowTween, shadow, 0.3)
			endcase
			case 8 // 2 rows
				if i = 4
					x = 270
					y = y + GetSpriteHeight(game_card[i].sprite) + 1
				endif
				SetSpritePosition(shadow, 270,130)
				SetTweenSpriteSizeX(shadowTween,0,GetSpriteWidth(game_card[i].sprite)*4 + 7, TweenEaseOut2())
				SetTweenSpriteSizeY(shadowTween,0,GetSpriteHeight(game_card[i].sprite)*2 + 6, TweenEaseOut2() )
				SetTweenSpriteAlpha(shadowTween,0,255,TweenEaseOut2())
				PlayTweenSprite( shadowTween, shadow, 0.4)
			endcase
			case 10 // 2 rows
				if i = 5
					x = 250
					y = y + GetSpriteHeight(game_card[i].sprite) + 1
				endif
				SetSpritePosition(shadow, 250,130)
				SetTweenSpriteSizeX(shadowTween,0,GetSpriteWidth(game_card[i].sprite)*5 + 8, TweenEaseOut2())
				SetTweenSpriteSizeY(shadowTween,0,GetSpriteHeight(game_card[i].sprite)*2 + 6, TweenEaseOut2() )
				SetTweenSpriteAlpha(shadowTween,0,255,TweenEaseOut2())
				PlayTweenSprite( shadowTween, shadow, 0.6)
			endcase
			case 12 //3 rows
				if i = 4 or i = 8
					x = 270
					y = y + GetSpriteHeight(game_card[i].sprite) + 1
				endif
				SetSpritePosition(shadow, 270,70)
				SetTweenSpriteSizeX(shadowTween,0,GetSpriteWidth(game_card[i].sprite)*4 + 7, TweenEaseOut2())
				SetTweenSpriteSizeY(shadowTween,0,GetSpriteHeight(game_card[i].sprite)*3 + 6, TweenEaseOut2() )
				SetTweenSpriteAlpha(shadowTween,0,255,TweenEaseOut2())
				PlayTweenSprite( shadowTween, shadow, 0.7)
			endcase
			case 14 //2 rows
				if i = 7
					x = 180
					y = y + GetSpriteHeight(game_card[i].sprite) + 1
				endif
				SetSpritePosition(shadow, 180,130)
				SetTweenSpriteSizeX(shadowTween,0,GetSpriteWidth(game_card[i].sprite)*7 + 10, TweenEaseOut2())
				SetTweenSpriteSizeY(shadowTween,0,GetSpriteHeight(game_card[i].sprite)*2 + 6, TweenEaseOut2() )
				SetTweenSpriteAlpha(shadowTween,0,255,TweenEaseOut2())
				PlayTweenSprite( shadowTween, shadow, 0.8)
			endcase
			case 16 //4 rows
				if i = 4 or i = 8 or i = 12
					x = 280
					y = y + GetSpriteHeight(game_card[i].sprite) + 1
				endif
				SetSpritePosition(shadow, 280,10)
				SetTweenSpriteSizeX(shadowTween,0,GetSpriteWidth(game_card[i].sprite)*4 + 7, TweenEaseOut2())
				SetTweenSpriteSizeY(shadowTween,0,GetSpriteHeight(game_card[i].sprite)*4 + 8, TweenEaseOut2() )
				SetTweenSpriteAlpha(shadowTween,0,255,TweenEaseOut2())
				PlayTweenSprite( shadowTween, shadow, 0.9)
			endcase
			case 18 // 3 rows
				if i = 6 or i = 12
					x = 210
					y = y + GetSpriteHeight(game_card[i].sprite) + 1
				endif
				SetSpritePosition(shadow, 210,70)
				SetTweenSpriteSizeX(shadowTween,0,GetSpriteWidth(game_card[i].sprite)*6 + 9, TweenEaseOut2())
				SetTweenSpriteSizeY(shadowTween,0,GetSpriteHeight(game_card[i].sprite)*3 + 7, TweenEaseOut2() )
				SetTweenSpriteAlpha(shadowTween,0,255,TweenEaseOut2())
				PlayTweenSprite( shadowTween, shadow, 1)
			endcase
			case 20 // 4 rows
				if i = 5 or i = 10 or i = 15
					x = 250
					y = y + GetSpriteHeight(game_card[i].sprite) + 1
				endif
				SetSpritePosition(shadow, 250,10)
				SetTweenSpriteSizeX(shadowTween,0,GetSpriteWidth(game_card[i].sprite)*5 + 8, TweenEaseOut2())
				SetTweenSpriteSizeY(shadowTween,0,GetSpriteHeight(game_card[i].sprite)*4 + 8, TweenEaseOut2() )
				SetTweenSpriteAlpha(shadowTween,0,255,TweenEaseOut2())
				PlayTweenSprite( shadowTween, shadow, 1.2)
			endcase
		endselect
		
		//update tween and the screen again at the end of the loop to make the tween effect look even better
		UpdateAllTweens( getframetime() )
		Sync()
	next i
	
	//go through each card and set animation of each
	count = game_cardNumber
	while count > 0
		
		//pick a random image
		repeat 
			animation = random(1,20)
		until NOT game_availableImg[animation] = 0
		
		//pick two random cards and set this image as their animation
		repeatCount = 2
		while repeatCount > 0
			randomCard = random(1,game_cardNumber)
			if game_card[randomCard].animation = 0 
				game_card[randomCard].animation = animation
				repeatCount = repeatCount - 1
			endif 
		endwhile
		count = count - 2
		game_availableImg[animation] = 0		
	endwhile
	
	//go through each card and display their animation
	for i = 1 to game_cardNumber
		SetSpriteImage(game_card[i].sprite, global_cardImg[game_card[i].animation])
	next i
	
	
	gameState = "game"
endfunction

function updateGame()
	
	//update tweens
	UpdateAllTweens( getframetime() )
	
//TURN CARDS TO SHOW THEIR BACK AFTER TIME******
	//start a timer, if the timer is greater than X seconds, start the game and flip all the cards so they no longer showing their animations
	if game_canStart = 0 then game_flipDelayTimer = game_flipDelayTimer + 1 * GetFrameTime()
	if game_flipDelayTimer >= game_secondsToWait
		for i = 1 to game_cardNumber
			SetSpriteImage(game_card[i].sprite, global_cardImg[0])
		next i
		
		//play a random flip sound
		if soundOn = 1 then PlaySound(global_cardFlipSound[random(0,2)], soundVolume)
		
		//set game can start to 1 and set game flip delay timer to 0 to make sure it is no longer executed and we can start the game 
		game_canStart = 1
		game_flipDelayTimer = 0
	endif
	
//START GAME******	
if game_canStart = 1
		
	//update game time
	game_Time = Timer()
	
	//if a card is clicked, flip the card to display it animation
	if GetPointerPressed() and game_flipCount < 2
		for i = 1 to game_cardNumber
			if GetSpriteHitTest(game_card[i].sprite, GetPointerX(), GetPointerY())	 
				if GetSpriteImageID(game_card[i].sprite) = global_cardImg[0] //if the card is clicked displaying the back animation
					
					//play a random flip sound
					if soundOn = 1 then PlaySound(global_cardFlipSound[random(0,1)], soundVolume) //I pick one only from 0 and 1 because I think it sounds better, but you can pick from range 0,2
					
					//display animation 
					SetSpriteImage(game_card[i].sprite, global_cardImg[game_card[i].animation])
					
					//store the sprite id and animation of the cards being flipped
					if game_flipCard1Spr = 0
						game_flipCard1Spr = game_card[i].sprite
						game_flipCard1Animation = game_card[i].animation
					else
						game_flipCard2Spr = game_card[i].sprite
						game_flipCard2Animation = game_card[i].animation
					endif
					//count number of flipped cards (should be never more then 2 at the same time)
					game_flipCount = game_flipCount + 1
				endif	
			endif
		next i
	endif
	
	//if we have flipped two cards, check if they are identical, if they are not, wait half second and flip them back
	if game_flipCount = 2
		Sync() //update everything to avoid a bug with the second card not being flipped before this part being executed
		if NOT game_flipCard1Animation = game_flipCard2Animation
			game_flipDelayTimer = game_flipDelayTimer + 1 * GetFrameTime()
			if game_flipDelayTimer >= 0.3
				SetSpriteImage(game_flipCard1Spr, global_cardImg[0])
				SetSpriteImage(game_flipCard2Spr, global_cardImg[0])
				game_flipCard1Spr = 0
				game_flipCard2Spr = 0
				game_flipCount = 0
				if soundOn = 1 then PlaySound(global_cardFlipSound[random(0,2)], soundVolume)
				game_flipDelayTimer = 0
			endif
		else
			//if the cards are the same, add them to the total flip count to know if we have flipped all the cards..
			
			game_flipCard1Spr = 0
			game_flipCard2Spr = 0
			game_flipCount = 0
			game_totalFlips = game_totalFlips + 2
		endif
	endif
	
//END GAME*****	
	//if the total flips equals to the mumber of cards that means we have all the cards flipped, wait half seconds, increase the number of cards and load the game again with more cards.
	if game_totalFlips = game_cardNumber 
		game_flipDelayTimer = game_flipDelayTimer + 1 * GetFrameTime()
		if game_flipDelayTimer >= 0.5
			if game_cardNumber < 20 
				game_cardNumber = game_cardNumber + 2
				loadGame()
			elseif game_cardNumber = 20 //in case we have 20 xrads on the screen that measn we have completed the game, go to the score screen
				loadScore()
			endif
		endif
	endif
	
	//in case the game time is the same as the target time and we are still playing, that measn we have failed, go to the score screen where wa are going to display a failed message
	if game_Time >= game_targetTime then loadScore()
	
endif //end of statement to check if the game can start

//MUSIC******
	//if the music button is clicked, change it animation and toggle the music on andoff
	if GetPointerPressed()
		if GetSpriteHitTest(game_musicButtonSpr, GetpointerX(), GetPointerY())
			if GetSpriteImageID(game_musicButtonSpr) = global_musicButtonImg[0]
				SetSpriteImage(game_musicButtonSpr, global_musicButtonImg[1])
				StopMusicOGG(global_menuMusic)
				musicOn = 0
			else
				SetSpriteImage(game_musicButtonSpr, global_musicButtonImg[0])
				PlayMusicOGG(global_menuMusic,1)
				musicOn = 1
			endif
			saveMusicState() 
		endif
	endif
	
//SOUND*****
	//if the sound button is clicked, change it animation and toggle the sound on and off
	if GetPointerPressed()
		if GetSpriteHitTest(game_soundButtonSpr, GetpointerX(), GetPointerY())
			if GetSpriteImageID(game_soundButtonSpr) = global_soundButtonImg[0]
				SetSpriteImage(game_soundButtonSpr, global_soundButtonImg[1])
				soundOn = 0
			else
				SetSpriteImage(game_soundButtonSpr, global_soundButtonImg[0])
				soundOn = 1
			endif
			saveSoundState() 
		endif
	endif

//EXIT GAME******
	
	//if exit button pressed, go back t main menu
	if GetPointerPressed()
		if GetSpriteHitTest(game_exitButtonSpr, GetPointerX(), GetPointerY()) then loadMainMenu()
	endif
endfunction
