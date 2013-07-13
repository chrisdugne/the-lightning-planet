-----------------------------------------------------------------------------------------
--
-- AppHome.lua
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()
local menu
local screen
local fires = {}
local introComplete = true

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
	
	utils.emptyGroup(screen)

	local back = display.newImage( screen, "images/stars.jpg")  
	back:scale(0.7,0.7)
	back.x = display.viewableContentWidth/2  
	back.y = display.viewableContentHeight/2  
	back.alpha = 0
	transition.to( back, { time=18000, alpha=1 })  

   light1()
   timer.performWithDelay(1500, function()
      displayIntroText("Uralys presents", display.contentWidth/2, display.contentHeight/2, true)
   
      timer.performWithDelay(7500, function()
      	light2()
         displayIntroText("The Lightning Planet", display.contentWidth/2, 45, false)

         timer.performWithDelay(7500, function()
         	utils.emptyGroup(screen)
         	self:refreshScene()
         	introComplete = true
         end)
      end)
   end)
   
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()
	utils.emptyGroup(menu)
	cleanupFires()
	viewManager.initView(self.view);
	
	title = display.newText( "The Lightning Planet", 0, 0, FONT, 35 )
	title:setTextColor( 255 )	
	title.x = display.contentWidth/2
	title.y = 45
	title:setReferencePoint( display.CenterReferencePoint )
	menu:insert(title)
	
	self:buildButton("Combo", "blue", 22, display.contentWidth/5, display.contentHeight*0.6, combo)
	self:buildButton("Kamikaze", "red", 16, display.contentWidth/2, display.contentHeight*0.8, kamikaze, true)
	self:buildButton("Time Attack", "yellow", 13, 4*display.contentWidth/5, display.contentHeight*0.45, timeAttack, true)

	for fire = 1, #fires do 
		fires[fire]:start("fire")
	end

	self.view:insert(menu)
end

------------------------------------------

function cleanupFires()	
	for fire = 1, #fires do 
		fires[fire]:destroy("fire")
	end
	
	while #fires > 0 do
   	table.remove(fires, 1)
	end
end

------------------------------------------

function combo()	
	game.mode = game.COMBO 
	router.openLevelSelection()
end

function kamikaze()
	game.mode = game.KAMIKAZE 
	router.openPlayground()
end

function timeAttack()
	game.mode = game.TIMEATTACK
	router.openPlayground()
end

------------------------------------------

function scene:buildButton( title, color, titleSize, x, y, action, lockAtStartup )

	local colors
	if(color == "blue") then
		colors={{0, 111, 255}, {0, 70, 255}}
	elseif(color == "green") then
		colors={{181, 255, 111}, {120, 255, 70}}
	elseif(color == "yellow") then
		colors={{255, 131, 111}, {255, 211, 70}}
	elseif(color == "red") then
		colors={{255, 111, 0}, {255, 70, 0}}
	else
		colors={{255, 111, 0}, {255, 70, 0}}
	end

	local planet = display.newImage("images/game/planet.".. color ..".png")
	planet:scale(0.36,0.36)
	planet.x = x
	planet.y = y
	planet.alpha = 0
	menu:insert(planet)
	
	
	local text = display.newText( title, 0, 0, FONT, titleSize )
	text:setTextColor( 0 )	
	text.x = x
	text.y = y
	text.alpha = 0
	menu:insert(text)
	
	transition.to( planet, { time=2000, alpha=1 })
	transition.to( text, { time=2000, alpha=1 })
	
	if(lockAtStartup and not savedData.levels[2]) then
   	local lock = display.newImage("images/hud/lock.png")
   	lock:scale(0.50,0.50)
   	lock.x = x
   	lock.y = y
   	menu:insert(lock)
   else
		text:addEventListener	("touch", function(event) action() end)
		planet:addEventListener	("touch", function(event) action() end)

   	local fire=CBE.VentGroup{
   		{
   			title="fire",
   			preset="burn",
   			color=colors,
   			build=function()
   				local size=math.random(34, 38) -- Particles are a bit bigger than ice comet particles
   				return display.newImageRect("CBEffects/textures/generic_particle.png", size, size)
   			end,
   			onCreation=function()end,
   			perEmit=2,
   			emissionNum=0,
   			x=x,
   			y=y,
   			positionType="inRadius",
   			posRadius=40,
   			emitDelay=50,
   			fadeInTime=1500,
   			lifeSpan=250, -- Particles are removed sooner than the ice comet
   			lifeStart=250,
   			endAlpha=0,
   			physics={
   				velocity=0.5,
   				xDamping=1,
   				gravityY=0.6,
   				gravityX=0
   			}
   		}
   	}
   	
   	table.insert(fires, fire)
	end
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
	print("text", text, "fade", fade)
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

------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	if(introComplete) then
		self:refreshScene()
	end
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	cleanupFires()
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