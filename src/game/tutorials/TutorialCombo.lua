-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

scene = {}
currentStep = 0

-----------------------------------------------------------------------------------------
--set up collision filters

local asteroidFilter = { categoryBits=1, maskBits=14 }
local planetFilter 	= { categoryBits=8, maskBits=1 }

-----------------------------------------------------------------------------------------

function start(view)
	scene = view
	
	hud.setExit(function()
		if(currentStep > 1 and texts[currentStep-1].item) then
   		hud.explode(texts[currentStep-1].item)
   	end
		
		if(currentStep > 1 and arrows[currentStep-1].item) then
			hud.explode(arrows[currentStep-1].item)
   	end
   	
		if(texts[currentStep].item) then
   		hud.explode(texts[currentStep].item)
   	end
		
		if(arrows[currentStep].item) then
			hud.explode(arrows[currentStep].item)
   	end
	end)
	
	stepContent[1]()

	-- level 2 immediately available for eager players leaving tuto
	savedData.levels[2] = { available = true }
   utils.saveTable(savedData, "savedData.json")

-- debug got to step
--	game.setPlanetColor(GREEN)
--	hud.setupButtons()
--	hud.setupLightningButton()
--	hud.drawCombo(1, 1)
--	currentStep = 10
--	step(11)
end

-----------------------------------------------------------------------------------------

function step(num)

	-------------------------------------------------
	-- Checking tutorial status
	
	if(currentStep < num-1) then
		-- Classic tutorial exit + come back
		return
	end

	if(currentStep == num) then
		-- Tutorial exit at step 1 and come back as quick as possible... return here and this will catch the previous stepper
		return
	end

	-------------------------------------------------

	local next
	currentStep = num
	next = stepContent[num]

	openStep(num, next)
end

-----------------------------------------------------------------------------------------

function openStep(step, next)

	if (game.state == game.IDLE) then
		return
	end

	if(conditionFilled(step-1)) then
		transition.to( texts[step-1].item, 		{ time=300, alpha=0, onComplete = function() display.remove(texts[step-1].item) end		})
		transition.to( arrows[step-1].item, 	{ time=300, alpha=0, onComplete = function() display.remove(arrows[step-1].item) end 	})
		next()
	else
		timer.performWithDelay( 40, function ()
			openStep(step, next)
		end) 
   end
end

-----------------------------------------------------------------------------------------

function conditionFilled(step)

	if(step == 3) then
		return game.planet.color == GREEN
	elseif(step == 10) then
		local asteroid = game.getAsteroid("asteroid_step7")
		return not asteroid
	elseif(step == 17) then
		return game.planet.color == BLUE
	elseif(step == 21) then
		local asteroid = game.getAsteroid("asteroid_step18")
		return not asteroid
	else
		return true
	end
	
end

-----------------------------------------------------------------------------------------

stepContent = {
	------ Step 1
   function()
   	currentStep = 1
   	game.setPlanetColor(BLUE)
   	displayArrow(1)
   end,
	------ Step 2
	function() 
		local asteroid = createAsteroid(GREEN, -math.pi/3, 180, 2)
		local vx, vy = asteroid:getLinearVelocity() 
		displayText(2)
	end,
	------ Step 3
	function() 
   	hud.setupButtons()
		local asteroid = game.getAsteroid("asteroid_step2")
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		asteroid:setLinearVelocity( 0, 0 )
		displayArrow(3)
	end,
	------ Step 4
	function() 
   	hud.disableColors()
   	local asteroid = game.getAsteroid("asteroid_step2")
		asteroid:setLinearVelocity( asteroid.vx, asteroid.vy )
		displayText(4)
	end,
	------ Step 5
	function() 
		displayText(5)
	end,
	------ Step 6
	function() 
		hud.drawCombo(1, 0)
		displayArrow(6)
	end,
	------ Step 7
	function() 
		local asteroid = createAsteroid(BLUE, -math.pi/4, 400, 7)
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		displayArrow(7)
	end,
	------ Step 8
	function() 
		local asteroid = game.getAsteroid("asteroid_step7")
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		asteroid:setLinearVelocity( 0, 0 )
		displayArrow(8)
		
   	square = display.newImage(game.scene, "assets/images/hud/square.png")
   	square:scale(0.35,0.35)
   	square.x = asteroid.x
   	square.y = asteroid.y
	end,
	------ Step 9
	function() 
		displayArrow(9)
	end,
	------ Step 10
	function() 
		hud.setupLightningButton()
		displayArrow(10)
	end,
	------ Step 11
	function() 
   	hud.disableLightning()
   	display.remove(square)
		displayText(11)
		
		local asteroid = createAsteroid(BLUE, -math.pi/4, 320, 11)
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
	end,
	------ Step 12
	function() 
		local asteroid = game.getAsteroid("asteroid_step11")
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		asteroid:setLinearVelocity( 0, 0 )
		displayArrow(12)
		
   	square = display.newImage(game.scene, "assets/images/hud/square.png")
   	square:scale(0.35,0.35)
   	square.x = asteroid.x
   	square.y = asteroid.y
	end,
	------ Step 13
	function() 
		displayArrow(13)
	end,
	------ Step 14
	function() 
		displayText(14)
	end,
	------ Step 15
	function() 
		displayText(15)
	end,
	------ Step 16
	function() 
		displayText(16)
	end,
	------ Step 17
	function() 
   	hud.enableColors()
		displayArrow(17)
	end,
	------ Step 18
	function() 
   	display.remove(square)
   	hud.disableColors()
   	local asteroid = game.getAsteroid("asteroid_step11")
		asteroid:setLinearVelocity( asteroid.vx, asteroid.vy )
		displayText(18)
		
		local asteroid = createAsteroid(GREEN, -math.pi/4, 400, 18)
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
	end,
	------ Step 19
	function() 
		local asteroid = game.getAsteroid("asteroid_step18")
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		asteroid:setLinearVelocity( 0, 0 )
		displayArrow(19)
		
   	square = display.newImage(game.scene, "assets/images/hud/square.png")
   	square:scale(0.35,0.35)
   	square.x = asteroid.x
   	square.y = asteroid.y
	end,
	------ Step 20
	function() 
		displayArrow(20)
	end,
	------ Step 21
	function() 
		hud.enableLightning()
		display.remove(square)
		displayArrow(21)
	end,
	------ Step 22
	function() 
		game.completeLevel()
		displayText(22)
	end,
	------ Exit
	function() 
		hud.explode(texts[currentStep].item)
		hud.explode(arrows[currentStep].item)
		game.endGame()
	end,
}

-----------------------------------------------------------------------------------------

function createAsteroid(color, alpha, distance, step)
	
	local asteroid = display.newImageRect( "assets/images/game/asteroid." .. color .. ".png", 24, 24 )
	asteroid.color = color
	physics.addBody( asteroid, { bounce=0, radius=12, filter=asteroidFilter } )
	
	local planetCenterPoint = vector2D:new(display.contentWidth/2, display.contentHeight/2)
	
	local asteroidPoint = vector2D:new(distance*math.cos(alpha), distance*math.sin(alpha))
	asteroidPoint = vector2D:Add(planetCenterPoint, asteroidPoint)
	asteroid.x = asteroidPoint.x
	asteroid.y = asteroidPoint.y

	asteroidDirection = vector2D:Sub(planetCenterPoint, asteroidPoint)
	asteroidDirection:mult(20/100) --random range : level params
	asteroid:setLinearVelocity( asteroidDirection.x, asteroidDirection.y )
	
	asteroid.collision = game.crashAsteroid  
	asteroid:addEventListener( "collision", asteroid )
	asteroid.name = "asteroid_step".. step
	
	table.insert(game.asteroids, asteroid)
	
	return asteroid
end

-----------------------------------------------------------------------------------------

function displayArrow(num, velocityX, velocityY)

	local arrow = display.newImage("assets/images/tutorial/arrow.".. arrows[num].way ..".png")
	arrow:scale(0.21,0.21)
	arrow.x = arrows[num].xFrom
	arrow.y = arrows[num].yFrom
	scene:insert(arrow)
	
	if(velocityX) then
		physics.addBody( arrow, { bounce=0, radius=12, filter=asteroidFilter } )
		arrow:setLinearVelocity( velocityX, velocityY )
	end
	
	transition.to( arrow, { time=200, x = arrows[num].xTo, y = arrows[num].yTo , onComplete=function() displayText(num) end } )
	
	arrows[num].item = arrow
end

-----------------------------------------------------------------------------------------

function displayText(num)

	local text = display.newText( texts[num].text, 0, 0, FONT, 15 )
	text:setTextColor( 255 )	
	text.alpha = 0
	text.x = texts[num].x
	text.y = texts[num].y
	scene:insert(text)
	texts[num].item = text

	transition.to( text, { 
		time=300, 
		alpha=1, 
		onComplete = function()
			timer.performWithDelay( texts[num].delay, function ()
				step(num+1)
			end) 
		end
	})
end

-----------------------------------------------------------------------------------------

texts = {
	{ --------------------------- STEP 1
		text 	= T "This is your Planet",
		x 		= display.contentWidth/5,
		y 		= display.contentHeight/2,
		delay = 1700,
	},
	{ --------------------------- STEP 2 
		text 	= T "And this is an asteroid",
		x 		= display.contentWidth/2,
		y 		= 100,
		delay = 1700,
	},
	{ --------------------------- STEP 3
		text 	= T "Use these buttons to change the planet's color",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight - 75,
		delay = 100,
	},
	{ --------------------------- STEP 4
		text 	= T "You catch an asteroid when it's the same color",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 2000,
	},
	{ --------------------------- STEP 5
		text 	= T "To achieve a Combo, you have to destroy asteroids",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 2000,
	},
	{ --------------------------- STEP 6
		text 	= T "Here is the color to destroy",
		x 		= 170,
		y 		= 20,
		delay = 2000,
	},
	{ --------------------------- STEP 7
		text 	= T "Here are the next ones",
		x 		= 150,
		y 		= 70,
		delay = 2000,
	},
	{ --------------------------- STEP 8
		text 	= T "A blue asteroid is coming",
		x 		= display.contentWidth/2 - 50,
		y 		= 40,
		delay = 2000,
	},
	{ --------------------------- STEP 9
		text 	= T "It's the same color, you have to destroy this asteroid",
		x 		= 230,
		y 		= 15,
		delay = 2000,
	},
	{ --------------------------- STEP 10
		text 	= T "Call Lightning  !",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight - 35,
		delay = 100,
	},
	{ --------------------------- STEP 11
		text 	= T "Lightning destroys the closest asteroid",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 2000,
	},
	{ --------------------------- STEP 12
		text 	= T "A blue asteroid is coming",
		x 		= display.contentWidth/2 - 50,
		y 		= 40,
		delay = 2000,
	},
	{ --------------------------- STEP 13
		text 	= T "It's not green, you need to wait",
		x 		= 230,
		y 		= 15,
		delay = 2000,
	},
	{ --------------------------- STEP 14
		text 	= T "But remember : you must have the same planet color",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 2000,
	},
	{ --------------------------- STEP 15
		text 	= T "when the asteroid crashes",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 2000,
	},
	{ --------------------------- STEP 16
		text 	= T "otherwise you start the combo from scratch again",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 1500,
	},
	{ --------------------------- STEP 17
		text 	= T "Turn your planet blue",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight - 35,
		delay = 100,
	},
	{ --------------------------- STEP 18
		text 	= T "Nice !",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 2500,
	},
	{ --------------------------- STEP 19
		text 	= T "A green asteroid is coming",
		x 		= display.contentWidth/2 - 50,
		y 		= 40,
		delay = 2000,
	},
	{ --------------------------- STEP 20
		text 	= T "It's the same color, you have to destroy this asteroid",
		x 		= 230,
		y 		= 15,
		delay = 2000,
	},
	{ --------------------------- STEP 21
		text 	= T "Call Lightning  !",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight - 35,
		delay = 100,
	},
	{ --------------------------- STEP 22
		text 	= T "Well done ! Now you're ready to play !",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 800,
	},
}

-----------------------------------------------------------------------------------------

arrows = {
	{ --------------------------- STEP 1
		way 			= "right",
		xFrom 		= 110,
		yFrom 		= display.contentHeight/2,
		xTo 			= display.contentWidth/2 - 60,
		yTo 			= display.contentHeight/2
	},
	{ --------------------------- STEP 2
	},
	{ --------------------------- STEP 3
		way 			= "right",
		xFrom 		= display.contentWidth /2,
		yFrom 		= display.contentHeight - 70,
		xTo 			= display.contentWidth - 70,
		yTo 			= display.contentHeight - 70
	},
	{ --------------------------- STEP 4
	},
	{ --------------------------- STEP 5
		way 			= "left",
		xFrom 		= display.contentWidth/2,
		yFrom 		= display.contentHeight - 60,
		xTo 			= 110,
		yTo 			= display.contentHeight - 60
	},
	{ --------------------------- STEP 6
		way 			= "left",
		xFrom 		= display.contentWidth/2,
		yFrom 		= 20,
		xTo 			= 50,
		yTo 			= 20
	},
	{ --------------------------- STEP 7
		way 			= "left",
		xFrom 		= display.contentWidth/2,
		yFrom 		= 70,
		xTo 			= 40,
		yTo 			= 70
	},
	{ --------------------------- STEP 8
		way 			= "right",
		xFrom 		= display.contentWidth/2,
		yFrom 		= 40,
		xTo 			= display.contentWidth/2 + 80,
		yTo 			= 40
	},
	{ --------------------------- STEP 9
		way 			= "left",
		xFrom 		= display.contentWidth/2,
		yFrom 		= 20,
		xTo 			= 50,
		yTo 			= 20
	},
	{ --------------------------- STEP 10
		way 			= "left",
		xFrom 		= display.contentWidth/2,
		yFrom 		= display.contentHeight - 60,
		xTo 			= 110,
		yTo 			= display.contentHeight - 60
	},
	{ --------------------------- STEP 11
	},
	{ --------------------------- STEP 12
		way 			= "right",
		xFrom 		= display.contentWidth/2,
		yFrom 		= 60,
		xTo 			= display.contentWidth/2 + 80,
		yTo 			= 60
	},
	{ --------------------------- STEP 13
		way 			= "left",
		xFrom 		= display.contentWidth/2,
		yFrom 		= 20,
		xTo 			= 50,
		yTo 			= 20
	},
	{ --------------------------- STEP 14
	},
	{ --------------------------- STEP 15
	},
	{ --------------------------- STEP 16
	},
	{ --------------------------- STEP 17
		way 			= "right",
		xFrom 		= display.contentWidth /2,
		yFrom 		= display.contentHeight - 30,
		xTo 			= display.contentWidth - 100,
		yTo 			= display.contentHeight - 30
	},
	{ --------------------------- STEP 18
	},
	{ --------------------------- STEP 19
		way 			= "right",
		xFrom 		= display.contentWidth/2,
		yFrom 		= 60,
		xTo 			= display.contentWidth/2 + 80,
		yTo 			= 60
	},
	{ --------------------------- STEP 20
		way 			= "left",
		xFrom 		= display.contentWidth/2,
		yFrom 		= 20,
		xTo 			= 50,
		yTo 			= 20
	},
	{ --------------------------- STEP 21
		way 			= "left",
		xFrom 		= display.contentWidth/2,
		yFrom 		= display.contentHeight - 60,
		xTo 			= 110,
		yTo 			= display.contentHeight - 60
	},
	{ --------------------------- STEP 22
	},
}

-----------------------------------------------------------------------------------------
