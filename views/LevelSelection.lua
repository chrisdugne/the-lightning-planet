-----------------------------------------------------------------------------------------
--
-- LevelSelection
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()
local levels

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	levels = display.newGroup()
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()
	utils.emptyGroup(levels)
	viewManager.initView(self.view);
	
	local margin = display.contentWidth/2 -5*38 

   for level = 1, 40 do
   
   	local i = (level-1)%10 
   	local j = math.floor((level-1)/10) + 1
		local levelAvailable = savedData.levels[level]
   	
   	local levelButton = display.newImage("images/hud/level.".. COLORS[j] .. ".png")
   	levelButton:scale(0.25,0.25)
   	levelButton.x = margin + 42 * i
   	levelButton.y = 65 * j
   	levels:insert(levelButton)
	
		if(not levelAvailable) then
      	local lock = display.newImage("images/hud/lock.png")
      	lock:scale(0.20,0.20)
      	lock.x = levelButton.x
      	lock.y = levelButton.y
      	levels:insert(lock)

	   	levelButton.alpha = 0.6
	   else
   		levelButton:addEventListener("touch", function(event) openLevel(level) end)
      end
      
   	local text = display.newText( level, 0, 0, "SelfDestructButtonBB", 26 )
   	text:setTextColor( 255 )	
   	if(levelAvailable) then
      	text.alpha = 1
      else 
      	text.alpha = 0.4
      end
   	text.x = levelButton.x
   	text.y = levelButton.y
   	levels:insert(text)
	
   	self.view:insert(levels)
   end
end

------------------------------------------

function openLevel( level )
	game.level = level
	router.openPlayground()
end

------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	self:refreshScene();
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene