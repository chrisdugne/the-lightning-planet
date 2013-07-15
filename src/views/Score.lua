-----------------------------------------------------------------------------------------
--
-- KamikazeSelection
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()
local scoreMenu

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	scoreMenu = display.newGroup()
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()
	utils.emptyGroup(scoreMenu)
	viewManager.initView(self.view);
   
   local top = display.newRect(scoreMenu, 0, -display.contentHeight/5, display.contentWidth, display.contentHeight/5)
   top:setFillColor(0)
   
   local bottom = display.newRect(scoreMenu, 0, display.contentHeight, display.contentWidth, display.contentHeight/5)
   bottom:setFillColor(0)

   local board = display.newRoundedRect(scoreMenu, 0, 0, display.contentWidth/2, display.contentHeight/2, 20)
   board.x = display.contentWidth/2
   board.y = display.contentHeight/2
   board.alpha = 0
   board:setFillColor(0)
   scoreMenu.board = board
   
	transition.to( top, { time=500, y = top.contentHeight/2 })
	transition.to( bottom, { time=500, y = display.contentHeight - top.contentHeight/2 })  
	transition.to( board, { time=800, alpha=0.9, onComplete= function() self:displayContent() end})  

	self.view:insert(scoreMenu)
end

function scene:displayContent()

	local type = self:getGameType()
	local level = self.getLevel()
	local value = self.getValue()

	-----------------------------------------------------------------------------------------------
	-- Texts

	local title = display.newText( scoreMenu, type, 0, 0, FONT, 25 )
	title:setTextColor( 255 )	
	title.x = scoreMenu.board.x + 10 - scoreMenu.board.contentWidth/2 + title.contentWidth/2
	title.y = scoreMenu.board.y - scoreMenu.board.contentHeight/2 + title.contentHeight/2

	local level = display.newText( scoreMenu, level, 0, 0, FONT, 21 )
	level:setTextColor( 255 )	
	level.x = scoreMenu.board.x - 10 + scoreMenu.board.contentWidth/2 - level.contentWidth/2
	level.y = scoreMenu.board.y + 5 - scoreMenu.board.contentHeight/2 + level.contentHeight/2

	local time = display.newText( scoreMenu, value, 0, 0, FONT, 21 )
	time:setTextColor( 255 )	
	time.x = scoreMenu.board.x
	time.y = scoreMenu.board.y - scoreMenu.board.contentHeight/3 + time.contentHeight/2
	
	-----------------------------------------------------------------------------------------------
	-- Planets
	
	viewManager.buildButton(scoreMenu, "",	 	COLORS[2], 22, scoreMenu.board.x - scoreMenu.board.contentWidth/3 + 30, 	display.contentHeight*0.58, function() router.openPlayground() end)
	viewManager.buildButton(scoreMenu, "", 	COLORS[3], 22, scoreMenu.board.x + scoreMenu.board.contentWidth/3 - 30, 	display.contentHeight*0.58, function() router.openSelection() end)
	
	-----------------------------------------------------------------------------------------------
	-- Icons

	local again = display.newImage("assets/images/hud/again.png")
	again:scale(0.50,0.50)
	again.x = scoreMenu.board.x - scoreMenu.board.contentWidth/3 + 30
	again.y = display.contentHeight*0.58
	again.alpha = 0
	scoreMenu:insert(again)
	
	transition.to( again, { time=1200, alpha=1 })  

	local levels = display.newImage("assets/images/hud/squares.png")
	levels:scale(0.50,0.50)
	levels.x = scoreMenu.board.x + scoreMenu.board.contentWidth/3 - 30
	levels.y = display.contentHeight*0.58
	levels.alpha = 0
	scoreMenu:insert(levels)
	
	transition.to( levels, { time=1200, alpha=1 })  
	
end

------------------------------------------

function scene:getGameType()

	if(game.mode == game.COMBO) then 
		return "Combo"
	
	elseif(game.mode == game.KAMIKAZE) then 
		return "Kamikaze"
	
	elseif(game.mode == game.TIMEATTACK) then 
		return "Time Attack"

   end
end

function scene:getLevel()

	if(game.mode == game.COMBO) then 
		if(game.level == 1) then
			return T "Tutorial" 
		else
			return "Level " .. game.level
		end
	
	elseif(game.mode == game.KAMIKAZE) then 
		if(game.level == 1) then
			return T "Tutorial" 
		elseif(game.level == 2) then
			return T "Easy" 
		elseif(game.level == 3) then
			return T "Hard" 
		elseif(game.level == 4) then
			return T "Extreme" 
      end
	
	elseif(game.mode == game.TIMEATTACK) then 
		if(game.level == 1) then
			return T "Tutorial" 
		elseif(game.level == 2) then
			return "2 min" 
		elseif(game.level == 3) then
			return "5 min" 
		elseif(game.level == 4) then
			return "8 min" 
      end
	
   end

end

function scene:getValue()

	if(game.mode == game.COMBO) then 
		if(game.level == 1) then
			return "" 
		else
			local min,sec = utils.getMinSec(game.timeCombo)
   		return min .. ":" .. sec
		end
	
	elseif(game.mode == game.KAMIKAZE) then 
		return game.points .." pts"
	
	elseif(game.mode == game.TIMEATTACK) then 
		return game.points .." pts"

   end
end

------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	self:refreshScene();
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	viewManager.cleanupFires()
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