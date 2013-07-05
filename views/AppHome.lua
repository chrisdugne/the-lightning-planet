-----------------------------------------------------------------------------------------
--
-- AppHome.lua
--
-----------------------------------------------------------------------------------------

local scene = storyboard.newScene()
local menu
local fires = {}

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
end

-----------------------------------------------------------------------------------------

function scene:refreshScene()
	utils.emptyGroup(menu)
	viewManager.setupView(self.view);
	
	titleButton = display.newText( "The Lightning Planet", 0, 0, "SelfDestructButtonBB-Italic", 45 )
	titleButton:setTextColor( 255 )	
	titleButton.x = display.contentWidth/2
	titleButton.y = 45
	titleButton:setReferencePoint( display.CenterReferencePoint )
	menu:insert(titleButton)
	
	self:buildButton("Combo", "blue", 25, display.contentWidth/5, display.contentHeight*0.6, combo)
	self:buildButton("Kamikaze", "red", 20, display.contentWidth/2, display.contentHeight*0.8, kamikaze, true)
	self:buildButton("Time attack", "yellow", 17, 4*display.contentWidth/5, display.contentHeight*0.45, timeAttack, true)

	for fire = 1, #fires do 
		fires[fire]:start("fire")
	end

	self.view:insert(menu)
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
	menu:insert(planet)
	
	local text = display.newText( title, 0, 0, "SelfDestructButtonBB", titleSize )
	text:setTextColor( 0 )	
	text.x = x
	text.y = y
	menu:insert(text)
	
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

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	self:refreshScene();
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	for fire = 1, #fires do 
		fires[fire]:stop("fire")
	end
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