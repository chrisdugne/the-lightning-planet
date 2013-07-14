-----------------------------------------------------------------------------------------
--
-- KamikazeSelection
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

	game.scene = self.view
	hud.initHUD()
	hud.initTopRightText()
	hud.refreshTopRightText("Kamikaze")
	hud.setExit(exitSelection)
	
	viewManager.buildButton(levels, "Tutorial", 	COLORS[1], 22, display.contentWidth/5, 	display.contentHeight*0.4, function() openLevel(1)	end	)
	viewManager.buildButton(levels, "Easy",	 	COLORS[2], 22, 2*display.contentWidth/5, 	display.contentHeight*0.6, function() openLevel(2)	end, 	true,	(not savedData.kamikazeAvailable))
	viewManager.buildButton(levels, "Hard", 		COLORS[3], 22, 3*display.contentWidth/5, 	display.contentHeight*0.4, function() openLevel(3)	end, 	true,	(not savedData.kamikazeAvailable))
	viewManager.buildButton(levels, "Extreme", 	COLORS[4], 22, 4*display.contentWidth/5, 	display.contentHeight*0.6, function() openLevel(4)	end, 	true,	(not savedData.kamikazeAvailable))

	self.view:insert(levels)
end

------------------------------------------

function exitSelection()
	for i = levels.numChildren,1,-1  do
		hud.explode(levels[i], 2, 2000, levels[i].color)
	end
	
	hud.explodeHUD()
	viewManager.cleanupFires()
end

------------------------------------------

function openLevel( level )
	game.level = level
	exitSelection()
	timer.performWithDelay(1500, router.openPlayground)
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