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
	
--	step1()

-- debug got to step
	game.setPlanetColor(BLUE)
	hud.setupPad()
	hud.drawBag()
	hud.disableColors()
	currentStep = 3
	step(4)
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

	if(step == 8) then
		local asteroid = game.getAsteroid("asteroid_step7")
		return not asteroid
	else
		return true
	end
	
end

-----------------------------------------------------------------------------------------

function step1()
	currentStep = 1
	game.setPlanetColor(BLUE)
	hud.drawBag()
	hud.setupButtons()
	hud.disableColors()
	
	createAsteroid(BLUE, -math.pi/3, 200, 1)
	timer.performWithDelay(700, function()
		createAsteroid(BLUE, -math.pi/3, 200, 1)
   	timer.performWithDelay(700, function()
	   	createAsteroid(BLUE, -math.pi/3, 200, 1)
      	timer.performWithDelay(700, function()
	   		createAsteroid(BLUE, -math.pi/3, 200, 1)
         	timer.performWithDelay(700, function()
      	   	createAsteroid(BLUE, -math.pi/3, 200, 1)
            	timer.performWithDelay(700, function()
	      	   	createAsteroid(BLUE, -math.pi/3, 200, 1)
               	timer.performWithDelay(700, function()
   	      	   	createAsteroid(BLUE, -math.pi/3, 200, 1)
               	end)
            	end)
         	end)
      	end)
   	end)
	end)

	displayArrow(1)
end

-----------------------------------------------------------------------------------------

function step2Content()
	return function() 
		displayText(2)
	end
end

-----------------------------------------------------------------------------------------

function step3Content()
	return function() 
		displayText(3)
	end
end

-----------------------------------------------------------------------------------------

function step4Content()
	return function() 
		hud.drawProgressBar(100) 
		createAsteroid(GREEN, -math.pi/3, 200, 1)
		displayArrow(4)
	end
end

function step5Content()
	return function() 
		displayArrow(5)
	end
end

-----------------------------------------------------------------------------------------

function step6Content()
	return function() 
		displayArrow(6)
	end
end

function step7Content()
	return function() 
		local asteroid = createAsteroid(BLUE, -math.pi/3, 220, 7)
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		displayArrow(7)
	end
end

-----------------------------------------------------------------------------------------

function step8Content()
	return function() 
		hud.setupLightningButton()
		local asteroid = game.getAsteroid("asteroid_step7")
		asteroid.vx, asteroid.vy = asteroid:getLinearVelocity()
		asteroid:setLinearVelocity( 0, 0 )
		displayArrow(8)
	end
end

-----------------------------------------------------------------------------------------


function step9Content()
	return function() 
		displayArrow(9)
	end
end

function step10Content()
	return function() 
		displayArrow(10)
	end
end

function step11Content()
	return function() 
		displayArrow(11)
	end
end

function step12Content()
	return function() 
		displayText(12)
	end
end

-----------------------------------------------------------------------------------------

function step13Content()
	return function() 
		hud.explode(texts[12].item)
		game.endGame(T "Tutorial Complete !")
	
		savedData.kamikazeAvailable = true 
   	utils.saveTable(savedData, "savedData.json")
	end
end

-----------------------------------------------------------------------------------------

function createAsteroid(color, alpha, distance, step)
	
	if(game.state == game.IDLE) then return end
	
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
	text.x = texts[num].x + text.contentWidth/2
	text.y = texts[num].y + text.contentHeight/2
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
		text 	= T "Here are counted caught asteroids",
		x 		= 40,
		y 		= 80,
		delay = 3000,
	},
	{ --------------------------- STEP 2 
		text 	= T "The more asteroids you gather...",
		x 		= 50,
		y 		= 40,
		delay = 3000,
	},
	{ --------------------------- STEP 3
		text 	= T "...the more points the next one will give",
		x 		= 150,
		y 		= 40,
		delay = 3500,
	},
	{ --------------------------- STEP 4
		text 	= T "This is the planet's Energy",
		x 		= 150,
		y 		= 60,
		delay = 1500,
	},
	{ --------------------------- STEP 5
		text 	= T "Catching a wrong color decrease the count",
		x 		= 80,
		y 		= 40,
		delay = 1400,
	},
	{ --------------------------- STEP 6
		text 	= T "Cost Energy",
		x 		= 210,
		y 		= 40,
		delay = 1400,
	},
	{ --------------------------- STEP 7
		text 	= T "And decrease points",
		x 		= display.contentWidth - 300,
		y 		= 40,
		delay = 1000,
	},
	{ --------------------------- STEP 8
		text 	= T "Touch here to call Lightning  !",
		x 		= 150,
		y 		= display.contentHeight - 75,
		delay = 100,
	},
	{ --------------------------- STEP 9
		text 	= T "Lightning squares the color count as points !",
		x 		= display.contentWidth - 400,
		y 		= 40,
		delay = 1800,
	},
	{ --------------------------- STEP 10
		text 	= T "Cost Energy",
		x 		= 210,
		y 		= 40,
		delay = 1400,
	},
	{ --------------------------- STEP 11
		text 	= T "And reduces the count",
		x 		= 80,
		y 		= 40,
		delay = 1500,
	},
	{ --------------------------- STEP 12
		text 	= T "Get the more points before the end of Energy !",
		x 		= 80,
		y 		= 40,
		delay = 1500,
	},
}

-----------------------------------------------------------------------------------------

arrows = {
	{ --------------------------- STEP 1
		way 			= "top",
		xFrom 		= 20,
		yFrom 		= display.contentHeight/2,
		xTo 			= 20,
		yTo 			= 70
	},
	{ --------------------------- STEP 2
	},
	{ --------------------------- STEP 3
	},
	{ --------------------------- STEP 4
		way 			= "top",
		xFrom 		= display.contentWidth/2,
		yFrom 		= display.contentHeight/2,
		xTo			= display.contentWidth/2,
		yTo 			= 50
	},
	{ --------------------------- STEP 5
		way 			= "left",
		xFrom 		= display.contentWidth/2,
		yFrom 		= 15,
		xTo 			= 50,
		yTo 			= 15
	},
	{ --------------------------- STEP 6
		way 			= "top",
		xFrom 		= 350,
		yFrom 		= display.contentHeight/2,
		xTo			= 350,
		yTo 			= 50
	},
	{ --------------------------- STEP 7
		way 			= "right",
		xFrom 		= display.contentWidth/2,
		yFrom 		= 22,
		xTo 			= display.contentWidth - 100,
		yTo 			= 22
	},
	{ --------------------------- STEP 8
		way 			= "left",
		xFrom 		= display.contentWidth/2,
		yFrom 		= display.contentHeight - 60,
		xTo 			= 110,
		yTo 			= display.contentHeight - 60
	},
	{ --------------------------- STEP 9
		way 			= "right",
		xFrom 		= display.contentWidth/2,
		yFrom 		= 22,
		xTo 			= display.contentWidth - 100,
		yTo 			= 22
	},
	{ --------------------------- STEP 10
		way 			= "top",
		xFrom 		= 350,
		yFrom 		= display.contentHeight/2,
		xTo			= 350,
		yTo 			= 50
	},
	{ --------------------------- STEP 11
		way 			= "left",
		xFrom 		= display.contentWidth/2,
		yFrom 		= 15,
		xTo 			= 50,
		yTo 			= 15
	},
	{ --------------------------- STEP 12
	},
}

-----------------------------------------------------------------------------------------
