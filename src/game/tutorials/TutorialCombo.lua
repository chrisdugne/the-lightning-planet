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
	
	step1()

-- debug got to step
--	game.setPlanetColor(GREEN)
--	hud.setupPad()
--	currentStep = 14
--	step(15)
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

	if(num == 2) then
		next = step2Content()
	elseif(num == 3) then
		next = step3Content()
	elseif(num == 4) then
		next = step4Content()
	elseif(num == 5) then
		next = step5Content()
	elseif(num == 6) then
		next = step6Content()
	elseif(num == 7) then
		next = step7Content()
	elseif(num == 8) then
		next = step8Content()
	elseif(num == 9) then
		next = step9Content()
	elseif(num == 10) then
		next = step10Content()
	elseif(num == 11) then
		next = step11Content()
	elseif(num == 12) then
		next = step12Content()
	elseif(num == 13) then
		next = step13Content()
	elseif(num == 14) then
		next = step14Content()
	elseif(num == 15) then
		next = step15Content()
	elseif(num == 16) then
		next = step16Content()
	elseif(num == 17) then
		next = step17Content()
	elseif(num == 18) then
		next = step18Content()
	elseif(num == 19) then
		next = step19Content()
	elseif(num == 20) then
		next = step20Content()
	elseif(num == 21) then
		next = step21Content()
	elseif(num == 22) then
		next = step22Content()
	elseif(num == 23) then
		next = step23Content()
	elseif(num == 24) then
		next = step24Content()
	elseif(num == 25) then
		next = step25Content()
	elseif(num == 26) then
		next = step26Content()
	elseif(num == 27) then
		next = step27Content()
	end
	
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
		return game.planet.color == BLUE
	elseif(step == 13) then
		return game.planet.color == GREEN
	elseif(step == 21) then
		local asteroid = game.getAsteroid("asteroid_step15")
		return not asteroid
	elseif(step == 24) then
		return game.planet.color == BLUE
	else
		return true
	end
	
end

-----------------------------------------------------------------------------------------

function step1()
	currentStep = 1
	game.setPlanetColor(BLUE)
	displayArrow(1)
end

-----------------------------------------------------------------------------------------

function step2Content()
	return function() 
		local asteroid = createAsteroid(GREEN, -math.pi/3, 180, 2)
		local vx, vy = asteroid:getLinearVelocity() 
		displayText(2)
	end
end

-----------------------------------------------------------------------------------------

function step3Content()
	return function() 
   	hud.setupButtons()
		local asteroid = game.getAsteroid("asteroid_step2")
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		asteroid:setLinearVelocity( 0, 0 )
		displayArrow(3)
	end
end

-----------------------------------------------------------------------------------------

function step4Content()
	return function() 
   	hud.disableColors()
   	local asteroid = game.getAsteroid("asteroid_step2")
		asteroid:setLinearVelocity( asteroid.vx, asteroid.vy )
		displayText(4)
	end
end

-----------------------------------------------------------------------------------------

function step5Content()
	return function() 
		currentStep = 6
		step(7)
	end
end

-----------------------------------------------------------------------------------------

function step7Content()
	return function() 
		displayText(7)
	end
end

-----------------------------------------------------------------------------------------

function step8Content()
	return function() 
   	hud.enableColors()
   	hud.drawCombo(1, 0)
		displayArrow(8)
	end
end

-----------------------------------------------------------------------------------------

function step9Content()
	return function() 
		local asteroid = createAsteroid(BLUE, -math.pi/4, 400, 9)
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		displayArrow(9)
	end
end

-----------------------------------------------------------------------------------------

function step10Content()
	return function() 
		local asteroid = game.getAsteroid("asteroid_step9")
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		asteroid:setLinearVelocity( 0, 0 )
		displayArrow(10)
	end
end

-----------------------------------------------------------------------------------------

function step11Content()
	return function() 
   	hud.disableColors()
   	local asteroid = game.getAsteroid("asteroid_step9")
		asteroid:setLinearVelocity( asteroid.vx, asteroid.vy )
		displayText(11)
	end
end

-----------------------------------------------------------------------------------------

function step12Content()
	return function() 
		local asteroid = createAsteroid(GREEN, -math.pi/3, 180, 12)
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		displayArrow(12)
	end
end

-----------------------------------------------------------------------------------------

function step13Content()
	return function() 
   	hud.enableColors()
		local asteroid = game.getAsteroid("asteroid_step12")
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		asteroid:setLinearVelocity( 0, 0 )
		displayArrow(13)
	end
end

-----------------------------------------------------------------------------------------

function step14Content()
	return function() 
   	hud.disableColors()
   	local asteroid = game.getAsteroid("asteroid_step12")
		asteroid:setLinearVelocity( asteroid.vx, asteroid.vy )
		displayText(14)
	end
end

-----------------------------------------------------------------------------------------

function step15Content()
	return function() 
		local asteroid = createAsteroid(GREEN, -2*math.pi/3, 180, 15)
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		displayArrow(15)
	end
end

-----------------------------------------------------------------------------------------

function step16Content()
	return function() 
   	hud.enableColors()
		local asteroid = game.getAsteroid("asteroid_step15")
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		asteroid:setLinearVelocity( 0, 0 )
		displayText(16)
	end
end

-----------------------------------------------------------------------------------------

function step17Content()
	return function() 
		currentStep = 19
		step(20)
	end
end

function step18Content()
	return function() 
		displayText(18)
	end
end

function step19Content()
	return function() 
		displayText(19)
	end
end

function step20Content()
	return function() 
		displayText(20)
	end
end

-----------------------------------------------------------------------------------------

function step21Content()
	return function()
   	hud.setupLightningButton()
   	displayArrow(21)
	end
end

-----------------------------------------------------------------------------------------

function step22Content()
	return function() 
   	displayText(22)
	end
end

-----------------------------------------------------------------------------------------

function step23Content()
	return function() 
		local asteroid = createAsteroid(BLUE, -math.pi/3, 180, 23)
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
   	displayText(23)
	end
end

function step24Content()
	return function() 
		local asteroid = game.getAsteroid("asteroid_step23")
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		asteroid:setLinearVelocity( 0, 0 )
   	displayArrow(24)
	end
end

-----------------------------------------------------------------------------------------

function step25Content()
	return function() 
   	hud.disableColors()
   	local asteroid = game.getAsteroid("asteroid_step23")
		asteroid:setLinearVelocity( asteroid.vx, asteroid.vy )
   	displayText(25)
	end
end

-----------------------------------------------------------------------------------------

function step26Content()
	return function() 
		game.completeLevel(1)
   	displayText(26)
	end
end

-----------------------------------------------------------------------------------------

function step27Content()
	return function() 
		hud.explode(texts[currentStep].item)
		hud.explode(arrows[currentStep].item)
		game.endGame()
	end
end

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
	{ --------------------------- STEP 5 -- DEPRECATED
	},
	{ --------------------------- STEP 6 -- DEPRECATED
	},
	{ --------------------------- STEP 7
		text 	= T "To achieve a Combo, you have to gather asteroids",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 2000,
	},
	{ --------------------------- STEP 8
		text 	= T "This is the order requested, from left to right",
		x 		= display.contentWidth/4,
		y 		= display.contentHeight/5 ,
		delay = 2000,
	},
	{ --------------------------- STEP 9
		text 	= T "First, you have to catch a blue asteroid",
		x 		= display.contentWidth/4 + 5,
		y 		= display.contentHeight/5 ,
		delay = 2000,
	},
	{ --------------------------- STEP 10
		text 	= T "Turn your planet blue",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight - 35,
		delay = 100,
	},
	{ --------------------------- STEP 11
		text 	= T "Planet and asteroid have the same color : Well done !",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 2000,
	},
	{ --------------------------- STEP 12
		text 	= T "Now you have to catch a green asteroid",
		x 		= display.contentWidth/4,
		y 		= display.contentHeight/5 ,
		delay = 1800,
	},
	{ --------------------------- STEP 13
		text 	= T "Turn your planet green",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight - 75,
		delay = 100,
	},
	{ --------------------------- STEP 14
		text 	= T "Great !",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 3000,
	},
	{ --------------------------- STEP 15
		text 	= T "Finally you need a blue asteroid",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 1800,
	},
	{ --------------------------- STEP 16
		text 	= T "Wait ! This one is green !",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 1300,
	},
	{}, -- 17 - deprecated
	{}, -- 18 - deprecated
	{}, -- 19 - deprecated
	{ --------------------------- STEP 20
		text 	= T "You need the Lightning !",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 1400,
	},
	{ --------------------------- STEP 21
		text 	= T "Call Lightning  !",
		x 		= display.contentWidth * 0.6,
		y 		= display.contentHeight - 63,
		delay = 100,
	},
	{ --------------------------- STEP 22
		text 	= T "Now this green asteroid is no more",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 1500,
	},
	{ --------------------------- STEP 23
		text 	= T "Here is the final blue asteroid !",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 1500,
	},
	{ --------------------------- STEP 24
		text 	= T "Turn your planet blue",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight - 35,
		delay = 100,
	},
	{ --------------------------- STEP 25
		text 	= T "Nice !",
		x 		= display.contentWidth/2,
		y 		= display.contentHeight/2 + 40,
		delay = 2500,
	},
	{ --------------------------- STEP 26
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
	},
	{ --------------------------- STEP 7
	},
	{ --------------------------- STEP 8
		way 			= "top",
		xFrom 		= 30,
		yFrom 		= display.contentHeight/2,
		xTo 			= 30,
		yTo 			= 50
	},
	{ --------------------------- STEP 9
		way 			= "top",
		xFrom 		= 10,
		yFrom 		= display.contentHeight/2,
		xTo 			= 10,
		yTo 			= 40
	},
	{ --------------------------- STEP 10
		way 			= "right",
		xFrom 		= display.contentWidth /2,
		yFrom 		= display.contentHeight - 30,
		xTo 			= display.contentWidth - 100,
		yTo 			= display.contentHeight - 30
	},
	{ --------------------------- STEP 11
	},
	{ --------------------------- STEP 12
		way 			= "top",
		xFrom 		= 30,
		yFrom 		= display.contentHeight/2,
		xTo 			= 30,
		yTo 			= 40
	},
	{ --------------------------- STEP 13
		way 			= "right",
		xFrom 		= display.contentWidth /2,
		yFrom 		= display.contentHeight - 70,
		xTo 			= display.contentWidth - 70,
		yTo 			= display.contentHeight - 70
	},
	{ --------------------------- STEP 14
	},
	{ --------------------------- STEP 15
		way 			= "top",
		xFrom 		= 50,
		yFrom 		= display.contentHeight/2,
		xTo 			= 50,
		yTo 			= 40
	},
	{ --------------------------- STEP 16
	},
	{ --------------------------- STEP 17
		way 			= "top",
		xFrom 		= 50,
		yFrom 		= display.contentHeight/2,
		xTo 			= 50,
		yTo 			= 40
	},
	{ --------------------------- STEP 18
	},
	{ --------------------------- STEP 19
	},
	{ --------------------------- STEP 20
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
	{ --------------------------- STEP 23
	},
	{ --------------------------- STEP 24
		way 			= "right",
		xFrom 		= display.contentWidth /2,
		yFrom 		= display.contentHeight - 30,
		xTo 			= display.contentWidth - 100,
		yTo 			= display.contentHeight - 30
	},
	{ --------------------------- STEP 25
	},
	{ --------------------------- STEP 26
	},
}

-----------------------------------------------------------------------------------------
