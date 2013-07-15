-----------------------------------------------------------------------------------------
--
-- AppHome.lua
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
end

-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:refreshScene()
	viewManager.initView(self.view);
	game.init(self.view)
	hud.initHUD()
	hud.initTopRightText()
	
	local tutorial = false
	
	-- Tutorial Combo
	if(game.mode == game.COMBO and game.level == 1) then
		tutorial = true
		hud.refreshTopRightText(T "Tutorial")
		game.start(false)
		tutorialCombo.start(self.view)
	end

	-- Tutorial Kamikaze
	if(game.mode == game.KAMIKAZE and game.level == 1) then
		tutorial = true
		hud.refreshTopRightText(T "Tutorial")
		game.start(false)
		tutorialKamikaze.start(self.view)
	end

	-- Tutorial Time Attack
	if(game.mode == game.TIMEATTACK and game.level == 1) then
		tutorial = true
		hud.refreshTopRightText(T "Tutorial")
		game.start(false)
		tutorialTimeAttack.start(self.view)
		hud.drawTimer(50)
	end
	
	
	if(not tutorial) then
		
		if(game.mode == game.COMBO) then 
			hud.drawCombo(game.level, 0)
      	hud.refreshTopRightText("Level " .. game.level)
      	hud.startComboTimer()
		
		elseif(game.mode == game.KAMIKAZE) then 
   		hud.drawProgressBar(100)
      	hud.refreshTopRightText("0 pts")
      	hud.drawBag()
		
		elseif(game.mode == game.TIMEATTACK) then 
      	hud.refreshTopRightText("0 pts")
      	hud.drawBag()
      	if(game.level == 2) then
				hud.drawTimer(120)
      	elseif(game.level == 3) then
				hud.drawTimer(300)
      	elseif(game.level == 4) then
				hud.drawTimer(480)
         end
      
      end
   	
   	hud.setExit()
   	hud.setupPad()
   	game.start()
   end

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