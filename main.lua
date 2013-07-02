-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

APP_NAME 	= "Asteroids"
APP_VERSION = "0.1"

-----------------------------------------------------------------------------------------

IMAGE_CENTER		= "IMAGE_CENTER";
IMAGE_TOP_LEFT 	= "IMAGE_TOP_LEFT";

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

---- App globals

GLOBALS = {

}

-----------------------------------------------------------------------------------------

--localData = utils.loadTable("localData.json")
--	
--if(not localData) then
--	localData = {user = {}, linkedin = {}}
--   utils.saveTable(localData, "localData.json")
--end
--
--if(not localData.user.pictureUrl) then
--	localData.user.pictureUrl = "http://static.licdn.com/scds/common/u/img/icon/icon_no_photo_60x60.png"
--end
	
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar ) 

------------------------------------------

router.openAppHome()

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
      	native.setKeyboardFocus( nil )
         router.lastBack()
      end
   end

   return true  --SEE NOTE BELOW
end

--add the key callback
Runtime:addEventListener( "key", onKeyEvent )