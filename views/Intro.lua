-----------------------------------------------------------------------------------------
--
-- Intro.lua
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()
local screen

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	screen = display.newGroup()
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()
	utils.emptyGroup(screen)

	local back = display.newImage( screen, "images/stars.jpg")  
	back:scale(0.7,0.7)
	back.x = display.viewableContentWidth/2  
	back.y = display.viewableContentHeight/2  
	back.alpha = 0
	transition.to( back, { time=18000, alpha=1 })  

   light1()
   timer.performWithDelay(1500, function()
      introText("Uralys presents", display.contentWidth/2, display.contentHeight/2, true)
   
      timer.performWithDelay(7500, function()
      	light2()
         introText("The Lightning Planet", display.contentWidth/2, 45, false)

         timer.performWithDelay(7500, function()
         	utils.emptyGroup(screen)
         	router.openAppHome()
         end)
      end)
   end)
end

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
   		display.contentHeight * 0.4,
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

function introText(text, x, y, fade)
	print("text", text, "fade", fade)
	if(not text) then
		return
	end

	finalText = display.newText( screen, text, 0, 0, FONT, 35 )
	finalText:setTextColor( 255 )	
	finalText.x = x
	finalText.y = y
	finalText.alpha = 0
	finalText:setReferencePoint( display.CenterReferencePoint )
	
	transition.to( finalText, { time=3000, alpha=1, onComplete=function()
		if(fade) then
      	timer.performWithDelay(1000, function()
      			transition.to( finalText, { time=3000, alpha=0 })
			end)
		end
	end})
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