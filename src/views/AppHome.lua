-----------------------------------------------------------------------------------------
--
-- AppHome.lua
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()
local menu
local screen
local introComplete = system.getInfo("environment") == "simulator"

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	
	menu = display.newGroup()
	screen = display.newGroup()

	-- true on dev only
	if(introComplete) then return end
	
   self:intro()
end

function scene:intro()

	utils.emptyGroup(screen)
	utils.emptyGroup(menu)

   local bottom = display.newRect(screen, 0, 0, display.contentWidth, display.contentHeight)
   bottom:setFillColor(0)
	
	viewManager.cleanupFires()

	local back = display.newImage( screen, "assets/images/stars.jpg")  
	back:scale(0.7,0.7)
	back.x = display.viewableContentWidth/2  
	back.y = display.viewableContentHeight/2  
	back.alpha = 0
	transition.to( back, { time=18000, alpha=1 })  
	screen.back = back

   light1()
   timer.performWithDelay(1500, function()
      displayIntroText("Uralys presents", display.contentWidth/2, display.contentHeight/2, true)
   
      timer.performWithDelay(7500, function()
      	light2()
         displayIntroText("The Lightning Planet", display.contentWidth/2, 45, false)

         timer.performWithDelay(7500, function()
         	utils.emptyGroup(screen)
         	self:refreshScene()
         end)
      end)
   end)
   
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()
	utils.emptyGroup(menu)
	viewManager.initView(self.view);
	
	title = display.newText( "The Lightning Planet", 0, 0, FONT, 35 )
	title:setTextColor( 255 )	
	title.x = display.contentWidth/2
	title.y = 45
	title:setReferencePoint( display.CenterReferencePoint )
	menu:insert(title)

	if(introComplete) then
   	title.alpha = 0
   	transition.to( title, { time=1800, alpha=1 })
   else  
   	title.alpha = 1
   	introComplete = true
   end	
	
	viewManager.buildButton(menu, "Combo", 		"blue", 		22, display.contentWidth/5, 	display.contentHeight*0.6, 	combo)
	viewManager.buildButton(menu, "Kamikaze", 	"red", 		20, display.contentWidth/2, 	display.contentHeight*0.73, 	kamikaze, 	true, (not savedData.levels[2]))
	viewManager.buildButton(menu, "Time Attack", "yellow", 	16, 4*display.contentWidth/5, display.contentHeight*0.39, 	timeAttack, true, (not savedData.levels[2]))


		viewManager.buildSmallButton(
			menu, 
			" ", 
			COLORS[2], 
			20,
			display.contentWidth - 30, 
			display.contentHeight - 30, 
			function() 
				self:reset() 
			end
		)

	self.view:insert(menu)
end

------------------------------------------

function combo()	
	game.mode = game.COMBO 
	router.openLevelSelection()
end

function kamikaze()
	game.mode = game.KAMIKAZE 
	router.openKamikazeSelection()
end

function timeAttack()
	game.mode = game.TIMEATTACK
	router.openTimeAttackSelection()
end

------------------------------------------
-- INTRO TOOLS
------------------------------------------

function light1()
	explode(	
   		display.contentWidth * 0.3,
   		display.contentHeight * 0.2,
   		12000
   	)

   explode(
   		display.contentWidth * 0.8,
   		display.contentHeight * 0.2,
   		12500
   	)

   explode(
   		display.contentWidth * 0.1,
   		display.contentHeight * 0.4,
   		10000
   	)

   explode(
   		display.contentWidth * 0.5,
   		display.contentHeight * 0.9,
   		9400
   	)
end

------------------------------------------

function light2()
	explode(	
   		display.contentWidth * 0.5,
   		display.contentHeight * 0.6,
   		7000
   	)

   explode(
   		display.contentWidth * 0.2,
   		display.contentHeight * 0.7,
   		6000
   	)

   explode(
   		display.contentWidth * 0.2,
   		display.contentHeight * 0.7,
   		6200
   	)

   explode(
   		display.contentWidth * 0.8,
   		display.contentHeight * 0.9,
   		5300
   	)
end

------------------------------------------

function explode(x, y, time)
   local fire=CBE.VentGroup{
   	{
   		title="fire",
   		preset="wisps",
   		color={{255,255,220},{255,255,120}},
   		x = x,
   		y = y,
   		emissionNum = 11,
   		fadeInTime = time,
   		physics={
   			gravityY=2.5,
   		}
   	}
   }
   fire:start("fire")
end

------------------------------------------

function displayIntroText(text, x, y, fade)

	if(not text) then
		return
	end

	local introText = display.newText( screen, text, 0, 0, FONT, 35 )
	introText:setTextColor( 255 )	
	introText.x = x
	introText.y = y
	introText.alpha = 0
	introText:setReferencePoint( display.CenterReferencePoint )
	
	transition.to( introText, { time=3000, alpha=1, onComplete=function()
		if(fade) then
      	timer.performWithDelay(1000, function()
      			transition.to( introText, { time=3000, alpha=0 })
			end)
		end
	end})
end

function scene:reset()
	savedData = {
		levels = { 
			{ available = true }, -- level 1 : tutorial combo 
		},
		kamikazeAvailable = false, 	-- require tutorial complete
		timeAttackAvailable = false, 	-- require tutorial complete
	}
   utils.saveTable(savedData, "savedData.json")
   
   introComplete = false
   self:intro()
end

------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	if(introComplete) then
		self:refreshScene()
	end
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