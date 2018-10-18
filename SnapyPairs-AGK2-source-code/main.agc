
/*
PLEASE READ THE LICENSE.TXT BEFORE USING THIS TEMPLATE, IN CASE THE LICENSE IS MISSING PLEASE LET US KNOW AT THE EMAIL BELOW!
BY USING THIS TEMPLATE YOU AGREE TO THE LICENSE 

Project: snapy-pairs
Created: 2018-04-16
Author: Laszlo Koosz
Website: www.gametemplates.itch.io
Email: gametemplates.itch@gmail.com
*/

//default properties
global windowWidth as integer = 930
global windowHeight as integer = 480
global gameState as string //we load splash1 by default
global musicVolume as integer = 30
global soundVolume as integer = 50
global musicOn as integer = 1//music is on
global soundOn as integer = 1//sound is on

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "snapy-pairs" )
SetWindowSize( windowWidth, windowHeight, 0 )
SetWindowAllowResize( 0 ) // don't allow the user to resize the window

// set display properties
SetVirtualResolution( windowWidth, windowHeight ) // doesn't have to match the window
SetOrientationAllowed( 0, 0, 1, 0 ) // allow landscape orientation  only on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

Sync() //update everything before going any further, it helps to avoid problems with different resolutions and device orientation

#include "keycodes.agc"
#include "loadresources.agc"
#include "splash1.agc"
#include "splash2.agc"
#include "help.agc"
#include "mainmenu.agc"
#include "difficultyselect.agc"
#include "game.agc"
#include "score.agc"


//load resources
loadResources()
//load the game
loadSplash1()

//update the game
do
    
	
    //Print()
    //if the state is the game, update game, otherwise check what state we are in
    if gameState = "game" 
		updateGame()
	else
		if gameState = "score" then updateScore()
		if gameState = "mainmenu" then updateMainMenu()
		if gameState = "difficultyselect" then updateDifficultySelect()
		if gameState = "help" then updateHelp()
		if gameState = "splash1" then updateSplash1()
		if gameState = "splash2" then updateSplash2()
	endif
    Sync()
loop
