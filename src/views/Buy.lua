-----------------------------------------------------------------------------------------
--
-- KamikazeSelection
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()
local buyMenu

local statusText
local mainText
local lockImage

local planetButton, textButton

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )

   if ( store.availableStores.apple ) then
       store.init( "apple", storeTransaction )
   elseif ( store.availableStores.google ) then
       store.init( "google", storeTransaction )
   end
	
	buyMenu = display.newGroup()
	game.scene = buyMenu
end


-----------------------------------------------------------------------------------------
--- STORE

function storeTransaction( event )
   print( "storeTransaction" )
   utils.tprint(event)

	local transaction = event.transaction

	if ( transaction.state == "purchased" ) then
		savedData.fullGame = true
	   utils.saveTable(savedData, "savedData.json")
		refreshStatus("Thank you !")

	elseif ( transaction.state == "cancelled" ) then
		print( "cancelled")
		refreshStatus("Maybe next time...")

	elseif ( transaction.state == "failed" ) then
		print( "failed")
		refreshStatus("Transaction failed...")
	end

	--tell the store that the transaction is complete!
	--if you're providing downloadable content, do not call this until the download has completed
	store.finishTransaction( event.transaction )

end

-----------------------------------------------------------------------------------------

function scene:refreshScene()

	hud.setExit()

	-----------------------------------------------------------
	
	utils.emptyGroup(buyMenu)
	viewManager.initView(self.view);
   
   local top = display.newRect(buyMenu, 0, -display.contentHeight/5, display.contentWidth, display.contentHeight/5)
   top:setFillColor(0)
   
   local bottom = display.newRect(buyMenu, 0, display.contentHeight, display.contentWidth, display.contentHeight/5)
   bottom:setFillColor(0)

   local board = display.newRoundedRect(buyMenu, 0, 0, display.contentWidth/2, display.contentHeight/2, 20)
   board.x = display.contentWidth/2
   board.y = display.contentHeight/2
   board.alpha = 0
   board:setFillColor(0)
   buyMenu.board = board
   
	transition.to( top, { time=500, y = top.contentHeight/2 })
	transition.to( bottom, { time=500, y = display.contentHeight - top.contentHeight/2 })  
	transition.to( board, { time=800, alpha=0.9, onComplete= function() self:displayContent() end})  

	self.view:insert(buyMenu)
	
end

function scene:displayContent()

	-----------------------------------------------------------------------------------------------
	-- Texts

	display.remove(mainText)
	mainText = display.newText( buyMenu, T "The game is locked\n Buy me a coffee to get access to the full game !", 0, 0, 170, 100, FONT, 14 )
	mainText:setTextColor( 255 )	
	mainText.x = buyMenu.board.x + 35
	mainText.y = buyMenu.board.y/2 + 60

	display.remove(statusText)
	statusText = display.newText( buyMenu, "", 0, 0, FONT, 22 )
	statusText:setTextColor( 255 )	
	
	lockImage = display.newImage(buyMenu, "assets/images/hud/lock.png")
	lockImage:scale(0.50,0.50)
	lockImage.x = buyMenu.board.x - buyMenu.board.contentWidth/2 + 30
	lockImage.y = buyMenu.board.y/2 + 40
	
	planetButton, textButton = viewManager.buildButton(buyMenu, T "Buy",	COLORS[2], 26, buyMenu.board.x, 	display.contentHeight*0.58, function() buy() end)
	
	-----------------------------------------------------------------------------------------------

end

function buy()
	display.remove(lockImage)
	display.remove(mainText)
	display.remove(planetButton)
	display.remove(textButton)
	viewManager.cleanupFires()
	
	if ( store.availableStores.apple ) then
		store.purchase( { "com.uralys.thelightningplanet.1.0" } )
	elseif ( store.availableStores.google ) then
		store.purchase( { "com.uralys.thelightningplanet.v1" } )
	end
	
	refreshStatus("Waiting for store...")
end

function refreshStatus(message)
	if(statusText) then
   	statusText.text = message
   	statusText.x = buyMenu.board.x
   	statusText.y = buyMenu.board.y
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