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
	
	self:buildButton("Combo", "blue", 25, display.contentWidth/5, display.contentHeight*0.6, missions)
	self:buildButton("Kamikaze", "red", 20, display.contentWidth/2, display.contentHeight*0.8, missions)
	self:buildButton("Time attack", "yellow", 17, 4*display.contentWidth/5, display.contentHeight*0.45, missions)

	fires[1]:start("fire")
	fires[2]:start("fire")
	fires[3]:start("fire")

	self.view:insert(menu)
end

function missions()
	router.openPlayground()
end

------------------------------------------

function scene:buildButton( title, color, titleSize, x, y, action )

	local colors
	if(color == "blue") then
		colors={{0, 111, 255}, {0, 70, 255}}
	elseif(color == "green") then
		colors={{181, 255, 111}, {120, 255, 70}}
	elseif(color == "yellow") then
		colors={{255, 255, 111}, {255, 255, 70}}
	elseif(color == "red") then
		colors={{255, 111, 0}, {255, 70, 0}}
	else
		colors={{255, 111, 0}, {255, 70, 0}}
	end


	local planet = display.newImage("images/game/planet.".. color ..".png")
	planet:scale(0.34,0.34)
	planet.x = x
	planet.y = y
	menu:insert(planet)
	
	local text = display.newText( title, 0, 0, "SelfDestructButtonBB", titleSize )
	text:setTextColor( 0 )	
	text.x = x
	text.y = y
	menu[title] = text
	menu:insert(text)
	
	local fire=CBE.VentGroup{
		{
			title="fire",
			preset="burn",
			color=colors,
			build=function()
				local size=math.random(30, 35) -- Particles are a bit bigger than ice comet particles
				return display.newImageRect("CBEffects/textures/generic_particle.png", size, size)
			end,
			onCreation=function(particle, vent)
				menu[title]:removeSelf()
         	menu[title] = display.newText( title, 0, 0, "SelfDestructButtonBB", titleSize )
         	menu[title]:setTextColor( 0 )	
         	menu[title].x = x
         	menu[title].y = y
         	menu[title]:addEventListener("touch", function(event) action() end)
				menu:insert(menu[title])
			end,
			perEmit=10,
			emissionNum=0,
			x=x,
			y=y,
			positionType="inRadius",
			posRadius=40,
			emitDelay=150,
			fadeInTime=500,
			lifeSpan=250, -- Particles are removed sooner than the ice comet
			lifeStart=250,
			endAlpha=0,
			physics={
				velocity=0.5,
				xDamping=1,
				gravityY=1.9,
				gravityX=0
			}
		}
	}
	
	table.insert(fires, fire)
end

------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	self:refreshScene();
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	fires[1]:stop("fire")
	fires[2]:stop("fire")
	fires[3]:stop("fire")
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