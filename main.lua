-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

APP_NAME 	= "TheLightningPlanet"
APP_VERSION = "1.2"

-----------------------------------------------------------------------------------------

IOS 		= system.getInfo( "platformName" )  == "iPhone OS"
ANDROID 	= system.getInfo( "platformName" )  == "Android"

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

if ANDROID then
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
gameCenter		= require "src.libs.GameCenter"

-----------------------------------------------------------------------------------------
-- Translations

local translations = require("assets.Translations")
local LANG =  userDefinedLanguage or system.getPreference("ui", "language")

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

---- Levels
COMBO_LEVELS		= require "src.game.levels.ComboLevels"
CLASSIC_LEVELS		= require "src.game.levels.ClassicLevels"
KAMIKAZE_LEVELS	= require "src.game.levels.KamikazeLevels"
TIMEATTACK_LEVELS	= require "src.game.levels.TimeAttackLevels"

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
--router.openNewRecord()

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
