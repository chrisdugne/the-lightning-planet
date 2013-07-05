-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

APP_NAME 	= "TheLightningPlanet"
APP_VERSION = "0.1"

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
--- Corona's libraries
json 				= require "json"
widget 			= require "widget"
storyboard 		= require "storyboard"

---- Additional libs
xml 				= require "libs.Xml"
utils 			= require "libs.Utils"
vector2D			= require "libs.Vector2D"

---- Server access Managers

---- App Tools
router 			= require "tools.Router"
imagesManager 	= require "tools.ImagesManager"
viewManager		= require "tools.ViewManager"

lightning		= require "tools.Lightning"
hud				= require "tools.HUD"
game				= require "tools.Game"
tutorial			= require "tools.Tutorial"

---- App globals

GLOBALS = {

}

---- Levels

LEVELS = {
	{
		colors = 2,
		combo = {GREEN,BLUE,GREEN}
	},
}

-----------------------------------------------------------------------------------------

physics = require("physics") ; physics.start() ; physics.setGravity( 0,0 ) ; physics.setDrawMode( "normal" )
math.randomseed( os.time() )
display.setStatusBar( display.HiddenStatusBar ) 

------------------------------------------

CBE	=	require("CBEffects.Library")

------------------------------------------

savedData = utils.loadTable("savedData.json")
	
if(not savedData) then
	savedData = {
		levels = { 
			{ available = true }, -- level 1 : tutorial combo 
		}
	}
   utils.saveTable(savedData, "savedData.json")
end

------------------------------------------

router.openAppHome()
--router.openLevelSelection()

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