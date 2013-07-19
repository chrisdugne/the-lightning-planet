-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

APP_NAME 	= "TheLightningPlanet"
APP_VERSION = "1.0"

-----------------------------------------------------------------------------------------

IMAGE_CENTER		= "IMAGE_CENTER";
IMAGE_TOP_LEFT 	= "IMAGE_TOP_LEFT";

-----------------------------------------------------------------------------------------

BLUE		= "blue";
GREEN 	= "green";
YELLOW 	= "yellow";
RED		= "red";

COLORS = {BLUE, GREEN, YELLOW, RED}

-----------------------------------------------------------------------------------------

ASTEROID_CRASH_KAMIKAZE_PERCENT 	= 3
LIGHTNING_KAMIKAZE_PERCENT 		= 20

-----------------------------------------------------------------------------------------

if "Android" == system.getInfo( "platformName" ) then
   FONT = "Macondo-Regular"
else
	FONT = "Macondo"
end

-----------------------------------------------------------------------------------------
--- Corona's libraries
json 				= require "json"
storyboard 		= require "storyboard"
store	 			= require "store"

---- Additional libs
xml 				= require "src.libs.Xml"
utils 			= require "src.libs.Utils"
vector2D			= require "src.libs.Vector2D"

-----------------------------------------------------------------------------------------
-- Translations

local translations = require("assets.Translations")
local LANG =  userDefinedLanguage or system.getPreference("ui", "language")
LANG = "fr"

function T(enText)
	return translations[enText][LANG] or enText
end

-----------------------------------------------------------------------------------------
---- Server access Managers

---- App Tools
router 			= require "src.tools.Router"
viewManager		= require "src.tools.ViewManager"
musicManager	= require "src.tools.MusicManager"

---- Game libs
lightning		= require "src.game.Lightning"
hud				= require "src.game.HUD"
game				= require "src.game.Game"

--- tutorials
tutorialClassic		= require "src.game.tutorials.TutorialClassic"
tutorialCombo			= require "src.game.tutorials.TutorialCombo"
tutorialKamikaze		= require "src.game.tutorials.TutorialKamikaze"
tutorialTimeAttack	= require "src.game.tutorials.TutorialTimeAttack"

-----------------------------------------------------------------------------------------
---- App globals

GLOBALS = {
	savedData = utils.loadTable("savedData.json")
}

---- Combo

CLASSIC_LEVELS = {
	{--------------------- Classic
		colors 				= 4,
		minDelay 			= 2000,
		maxDelay 			= 3000,
		changeDelaySec	 	= 20,
		changeDelayAmount = 150,
		minSpeed 			= 15,
		maxSpeed 			= 18
	}
}

---- Combo

COMBO_LEVELS = {
	{--------------------- LEVEL 1 : Tutorial
		colors = 2,
		combo = {BLUE,GREEN},
		minDelay = 1500,
		maxDelay = 2500,
		minSpeed = 15,
		maxSpeed = 20,
	},
	{--------------------- LEVEL 2
		colors = 2,
		combo = {BLUE,GREEN},
		minDelay = 1500,
		maxDelay = 2500,
		changeDelaySec = 20,
		changeDelayAmount = 100,
		minSpeed = 15,
		maxSpeed = 20,
	},
	{--------------------- LEVEL 3
		colors = 2,
		combo = {BLUE,BLUE,GREEN},
		minDelay = 2000,
		maxDelay = 2500,
		changeDelaySec = 20,
		changeDelayAmount = 100,
		minSpeed = 15,
		maxSpeed = 20,
	},
	{--------------------- LEVEL 4
		colors = 2,
		combo = {BLUE,GREEN,BLUE,GREEN,BLUE},
		minDelay = 2000,
		maxDelay = 2500,
		changeDelaySec = 20,
		changeDelayAmount = 100,
		minSpeed = 15,
		maxSpeed = 20,
	},
	{--------------------- LEVEL 5
		colors = 2,
		combo = {BLUE,BLUE,BLUE,BLUE,BLUE,GREEN},
		minDelay = 2000,
		maxDelay = 2000,
		changeDelaySec = 20,
		changeDelayAmount = 100,
		minSpeed = 15,
		maxSpeed = 20,
	},
	{--------------------- LEVEL 6
		colors = 3,
		combo = {BLUE,GREEN,YELLOW,BLUE},
		minDelay = 2000,
		maxDelay = 2500,
		changeDelaySec = 20,
		changeDelayAmount = 150,
		minSpeed = 17,
		maxSpeed = 22,
	},
	{--------------------- LEVEL 7
		colors = 3,
		combo = {GREEN,GREEN,YELLOW,BLUE,YELLOW},
		minDelay = 2000,
		maxDelay = 2500,
		changeDelaySec = 20,
		changeDelayAmount = 150,
		minSpeed = 24,
		maxSpeed = 31,
	},
	{--------------------- LEVEL 8
		colors = 3,
		combo = {YELLOW,GREEN,YELLOW,BLUE,YELLOW, YELLOW, GREEN},
		minDelay = 1800,
		maxDelay = 2500,
		changeDelaySec = 20,
		changeDelayAmount = 150,
		minSpeed = 17,
		maxSpeed = 22,
	},
	{--------------------- LEVEL 9
		colors = 3,
		combo = {GREEN,GREEN,BLUE,YELLOW, YELLOW, GREEN, BLUE, BLUE, YELLOW},
		minDelay = 1800,
		maxDelay = 2500,
		changeDelaySec = 20,
		changeDelayAmount = 150,
		minSpeed = 17,
		maxSpeed = 22,
	},
	{--------------------- LEVEL 10
		colors = 3,
		combo = {BLUE,GREEN,BLUE,YELLOW, YELLOW, GREEN, GREEN, YELLOW, BLUE, GREEN, YELLOW},
		minDelay = 1800,
		maxDelay = 2500,
		changeDelaySec = 20,
		changeDelayAmount = 150,
		minSpeed = 19,
		maxSpeed = 23,
	},
	{--------------------- LEVEL 11
		colors = 3,
		combo = {GREEN,GREEN, BLUE, YELLOW, YELLOW, BLUE, GREEN, YELLOW, BLUE, GREEN, YELLOW, BLUE, YELLOW},
		minDelay = 1800,
		maxDelay = 2500,
		changeDelaySec = 20,
		changeDelayAmount = 150,
		minSpeed = 19,
		maxSpeed = 23,
	},
}

---- Kamikaze 

KAMIKAZE_LEVELS = {
	{--------------------- LEVEL 1 : Tutorial
		colors = 2,
		minDelay = 1500,
		maxDelay = 2500,
		changeDelaySec = 20,
		changeDelayAmount = 100,
		minSpeed = 20,
		maxSpeed = 25,
	},
	{--------------------- LEVEL 2 : Easy
		colors = 2,
		minDelay = 3000,
		maxDelay = 4000,
		changeDelaySec = 15,
		changeDelayAmount = 200,
		minSpeed = 15,
		maxSpeed = 18,
	},
	{--------------------- LEVEL 3 : Hard
		colors = 3,
		minDelay = 2500,
		maxDelay = 3500,
		changeDelaySec = 15,
		changeDelayAmount = 200,
		minSpeed = 18,
		maxSpeed = 22,
	},
	{--------------------- LEVEL 4 : Extreme
		colors = 4,
		minDelay = 2000,
		maxDelay = 2500,
		changeDelaySec = 15,
		changeDelayAmount = 200,
		minSpeed = 20,
		maxSpeed = 25,
	},
}

---- Time Attack 

TIMEATTACK_LEVELS = {
	{--------------------- LEVEL 1 : Tutorial
		colors = 2,
		minDelay = 1500,
		maxDelay = 2500,
		changeDelaySec = 20,
		changeDelayAmount = 100,
		minSpeed = 20,
		maxSpeed = 25,
	},
	{--------------------- LEVEL 2 : Easy
		colors = 2,
		minDelay = 3000,
		maxDelay = 4000,
		changeDelaySec = 15,
		changeDelayAmount = 200,
		minSpeed = 15,
		maxSpeed = 18,
	},
	{--------------------- LEVEL 3 : Hard
		colors = 3,
		minDelay = 2500,
		maxDelay = 3500,
		changeDelaySec = 15,
		changeDelayAmount = 200,
		minSpeed = 18,
		maxSpeed = 22,
	},
	{--------------------- LEVEL 4 : Extreme
		colors = 4,
		minDelay = 2000,
		maxDelay = 2500,
		changeDelaySec = 15,
		changeDelayAmount = 200,
		minSpeed = 20,
		maxSpeed = 25,
	},
}

-----------------------------------------------------------------------------------------

physics = require("physics") ; physics.start() ; physics.setGravity( 0,0 ) ; physics.setDrawMode( "normal" )
math.randomseed( os.time() )

------------------------------------------

CBE	=	require("CBEffects.Library")

------------------------------------------
	
if(not GLOBALS.savedData) then
	game.initGameData()
end

------------------------------------------

musicManager.playMusic()

------------------------------------------

router.openAppHome()

--game.mode = game.COMBO
--game.level = 40
--game.timeCombo = 12
--router.openScore()


-----------------------------------------------------------------------------------------

function getColorNum(color)
	for i = 1, #COLORS do
		if(color == COLORS[i]) then
			return i
   	end
	end
end

function getRGB(color)
	if(color == BLUE) then
		return {0, 111, 255}
	elseif(color == GREEN) then
		return {0, 255, 120}
	elseif(color == RED) then
		return {255, 125, 120}
	elseif(color == YELLOW) then
		return {255, 255, 120}
	end
end

------------------------------------------
--- iOS Status Bar

display.setStatusBar( display.HiddenStatusBar ) 

------------------------------------------
--- ANDROID BACK BUTTON

local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   print( event.phase, event.keyName )

   if ( "back" == keyName and phase == "up" ) then
      if ( storyboard.currentScene == "splash" ) then
         native.requestExit()
      else
--      	native.setKeyboardFocus( nil )
-- 		nothing
      end
   end

   return true  --SEE NOTE BELOW
end

--add the key callback
Runtime:addEventListener( "key", onKeyEvent )
