-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

scene = {}

-----------------------------------------------------------------------------------------

RUNNING 		= 1
IDLE 			= 2

-----------------------------------------------------------------------------------------

COMBO 		= 1
KAMIKAZE 	= 2
TIMEATTACK 	= 3

-----------------------------------------------------------------------------------------

planet = {}
asteroids = {}
asteroidsCaught = {}

-----------------------------------------------------------------------------------------

points 	= 0
mode 		= 0
state 	= IDLE

kamikazePercent = 100

-----------------------------------------------------------------------------------------
--set up collision filters

local asteroidFilter = { categoryBits=1, maskBits=14 }
local planetFilter 	= { categoryBits=8, maskBits=1 }

-----------------------------------------------------------------------------------------

function init(view)
	scene = view
	
	setPlanetColor(BLUE)
	
	if(mode == COMBO) then
   	requestedAsteroid = 1
   else
	   for i = 1, #COLORS do
   	   asteroidsCaught[COLORS[i]] = 0
   	end
   end

	if(mode == KAMIKAZE) then
		kamikazePercent = 100
   end
   
end

function start(requireAsteroidBuilder)
	
	if(requireAsteroidBuilder == nil) then
		requireAsteroidBuilder = true
	end

	state	= RUNNING
	
	if(requireAsteroidBuilder) then
   	hud.centerText("Start !", display.contentHeight/4, 45)
		timer.performWithDelay(2000, asteroidBuilder)
	end
end

-----------------------------------------------------------------------------------------

function asteroidBuilder()
	timer.performWithDelay( math.random(1000,3000), function() --delay :  level params
		if(state == RUNNING) then
			createAsteroid()
			asteroidBuilder()
		end
	end)
end

function setPlanetColor(color)
	
	display.remove(planet)
	
	planet = display.newImage(scene, "assets/images/game/planet.".. color ..".png")
	planet:scale(0.17,0.17)
	planet.x = display.contentWidth/2
	planet.y = display.contentHeight/2
	planet.name = "planet"..color
	planet.alpha = 0.8
	planet.color = color
	physics.addBody( planet, "static", { bounce=0, radius=12, filter=planetFilter } )
end

------------------------------------------------------------------------------------------
--
function crashAsteroid( asteroid, event )
	local planet = event.other
	if(asteroid.beingDestroyed) then
		return
	end
	
	--------------------------

	local goodCatch = asteroid.color == planet.color
	
	--------------------------

	if(mode == COMBO) then
		
		if(COMBO_LEVELS[level].combo[requestedAsteroid] == asteroid.color) then
			hud.drawCombo(level, requestedAsteroid)
			requestedAsteroid = requestedAsteroid + 1
			
			if(requestedAsteroid > #COMBO_LEVELS[level].combo) then
				completeLevel()
   		end
		end
	
	--------------------------
	
	elseif(mode == KAMIKAZE or mode == TIMEATTACK) then
		
		local change 	= 0 
		local catch 	= 0 
		local total 	= points
		
		if(goodCatch) then
			catch = 1
			asteroidsCaught[planet.color] = asteroidsCaught[planet.color] + 1
			change = asteroidsCaught[planet.color]
		else 
			catch = -1
			asteroidsCaught[planet.color] = asteroidsCaught[planet.color] - 1
			change = -3
			
			if(mode == KAMIKAZE) then
				kamikazePercent = kamikazePercent - 3
			end
		end
		
		total = points + change

		if(asteroidsCaught[planet.color] < 0) then
			asteroidsCaught[planet.color] = 0
		end

		if(total < 0) then
			total = 0
		end
		
		hud.drawCatch(asteroid.x, asteroid.y, planet.color, catch)
		hud.drawBag()
		hud.drawPoints(change, total, asteroid)
		if(not goodCatch and mode == KAMIKAZE) then hud.drawProgressBar(kamikazePercent, 3) end
		
		points = total

	end

	--------------------------
	-- destroy
	
	asteroid.beingDestroyed = true
	
	if(goodCatch) then
		catchAsteroid(asteroid)
	else
		explodeAsteroid(asteroid)
   end
end

------------------------------------------------------------------------------------------

function squarePointsWithLighting(asteroid)
	
	if(mode == KAMIKAZE or mode == TIMEATTACK) then
		
		local change 		= asteroidsCaught[asteroid.color] * asteroidsCaught[asteroid.color]
		local changeText 	= asteroidsCaught[asteroid.color] .. " x "  ..  asteroidsCaught[asteroid.color]
		local total = points + change

		asteroidsCaught[asteroid.color] = math.floor(asteroidsCaught[asteroid.color]/2)
		kamikazePercent = kamikazePercent - 20

		hud.drawPoints(changeText, total, asteroid, true)
		hud.drawCatch(asteroid.x, asteroid.y, asteroid.color, "/2")
		hud.drawBag()
		
		if(mode == KAMIKAZE) then hud.drawProgressBar(kamikazePercent, 20) end
		
		points = total
	end
	
end

------------------------------------------------------------------------------------------

function destroyAsteroid(asteroid)
	local indexToRemove
	for i in pairs(asteroids) do
		if(asteroids[i] == asteroid) then
			indexToRemove = i
			break
		end
	end
	
	table.remove(asteroids, indexToRemove)

	--------------------------
	-- destroy
	
	transition.to( asteroid, { time=150, alpha=0, onComplete=function() display.remove(asteroid) end } )
end

------------------------------------------------------------------------------------------

function shootOnClosestAsteroid() 
	
	local asteroid = findClosestAsteroid()
	if(asteroid and not asteroid.beingDestroyed) then
	
		asteroid.beingDestroyed = true
		
		local asteroidPosition 	= vector2D:new(asteroid.x, asteroid.y)
   	local center 				= vector2D:new(display.contentWidth/2, display.contentHeight/2)
   	local direction 			= vector2D:Sub(asteroidPosition, center)

   	direction:normalize()
   	direction:mult(20)
   	
   	local planetPosition = vector2D:Add(center, direction)

   	lightPlanet(asteroid) 
   	
   	local thunderDone = function() 
   		squarePointsWithLighting(asteroid)
   		explodeAsteroid(asteroid) 
   	end

   	lightning.thunder(planetPosition, asteroidPosition, thunderDone)
   end
	
end

------------------------------------------------------------------------------------------

function findClosestAsteroid()
	local closestDistance = 10000
	local closestAsteroid
	
	for i in pairs(asteroids) do
		local asteroid = asteroids[i]
		local asteroidPosition 	= vector2D:new(asteroid.x, asteroid.y)
		local planetPosition 	= vector2D:new(display.contentWidth/2, display.contentHeight/2)
		
		local distance = vector2D:Dist(asteroidPosition, planetPosition)
		
		if(distance < closestDistance) then
			closestDistance = distance
			closestAsteroid = asteroid
		end
	end
	
	if(closestAsteroid == nil) then
		return nil
	else
   	return closestAsteroid
   end

end

------------------------------------------------------------------------------------------

function lightPlanet(asteroidDestoyed)

	local planetColors
	if(asteroidDestoyed.color == BLUE) then
		planetColors={{0, 111, 255}, {0, 70, 255}}
	elseif(asteroidDestoyed.color == GREEN) then
		planetColors={{181, 255, 111}, {120, 255, 70}}
	elseif(asteroidDestoyed.color == YELLOW) then
		planetColors={{255, 255, 111}, {255, 255, 70}}
	elseif(asteroidDestoyed.color == RED) then
		planetColors={{255, 111, 0}, {255, 70, 0}}
	else
		planetColors={{255, 111, 0}, {255, 70, 0}}
	end

	local light=CBE.VentGroup{
		{
   		title="explosionPlanet",
   		preset="wisps",
   		color=planetColors,
   		x = planet.x,
   		y = planet.y,
   		emissionNum = 3,
   		physics={
   			gravityX=0,
   			gravityY=4.5,
			}
		}
	}
	light:start("explosionPlanet")
end

function catchAsteroid(asteroid)
	local asteroidColors
	if(asteroid.color == "blue") then
		asteroidColors={{0, 111, 255}, {0, 70, 255}}
	elseif(asteroid.color == "green") then
		asteroidColors={{181, 255, 111}, {120, 255, 70}}
	elseif(asteroid.color == "yellow") then
		asteroidColors={{255, 255, 111}, {255, 255, 70}}
	elseif(asteroid.color == "red") then
		asteroidColors={{255, 111, 0}, {255, 70, 0}}
	else
		asteroidColors={{255, 111, 0}, {255, 70, 0}}
	end


	local light=CBE.VentGroup{
		{
   		title="explosion",
   		preset="wisps",
   		color=asteroidColors,
   		x = asteroid.x,
   		y = asteroid.y,
   		emissionNum = 3,
   		physics={
   			gravityX=-16.2,
   			gravityY=-11.2,
			}
		}
	}

	light:start("explosion")
   lightPlanet(asteroid)

	destroyAsteroid(asteroid)
end

------------------------------------------------------------------------------------------

function explodeAsteroid(asteroid)

	local colors
	if(asteroid.color == "blue") then
		colors={{0, 111, 255}, {0, 70, 255}}
	elseif(asteroid.color == "green") then
		colors={{181, 255, 111}, {120, 255, 70}}
	elseif(asteroid.color == "yellow") then
		colors={{255, 255, 111}, {255, 255, 70}}
	elseif(asteroid.color == "red") then
		colors={{255, 111, 0}, {255, 70, 0}}
	else
		colors={{255, 111, 0}, {255, 70, 0}}
	end

	local light=CBE.VentGroup{
		{
			title="explosion",
			preset="burn",
			color=colors,
			build=function()
				local size=math.random(30, 35)
				return display.newImageRect("CBEffects/textures/generic_particle.png", size, size)
			end,
			onCreation=function()end,
			perEmit=4,
			emissionNum=math.random(3,5),
			x=asteroid.x,
			y=asteroid.y,
			positionType="inRadius",
			posRadius=20,
			emitDelay=50,
			fadeInTime=50,
			lifeSpan=250,
			lifeStart=250,
			endAlpha=0,
			physics={
				relativeToSize=false,
				sizeX=-0.01,
				sizeY=-0.01,
				relativeToSize=false,
				velocity=1.5,
				xDamping=1,
				gravityY=0,
				gravityX=0
			}
		}
	}
	light:start("explosion")

	destroyAsteroid(asteroid)
end

------------------------------------------------------------------------------------------

function getAsteroid(name)
	for i in pairs(asteroids) do
		if(asteroids[i].name == name) then
			return asteroids[i]
		end
	end
end

------------------------------------------------------------------------------------------

function createAsteroid()
	local nbColors
	if(mode == COMBO) then
		nbColors = COMBO_LEVELS[level].colors
	elseif(mode == KAMIKAZE) then
		nbColors = KAMIKAZE_LEVELS[level].colors
	elseif(mode == TIMEATTACK) then
		nbColors = TIMEATTACK_LEVELS[level].colors
	end
	
	local num = math.random(1,nbColors)
	local color = COLORS[num]
	
	local asteroid = display.newImageRect( "assets/images/game/asteroid." .. color .. ".png", 24, 24 )
	asteroid.color = color
	physics.addBody( asteroid, { bounce=0, radius=12, filter=asteroidFilter } )
	
	local planetCenterPoint = vector2D:new(display.contentWidth/2, display.contentHeight/2)
	
	local alpha = math.rad(math.random(360))
	local distance = 300
	
	local asteroidPoint = vector2D:new(distance*math.cos(alpha), distance*math.sin(alpha))
	asteroidPoint = vector2D:Add(planetCenterPoint, asteroidPoint)
	asteroid.x = asteroidPoint.x
	asteroid.y = asteroidPoint.y

	asteroidDirection = vector2D:Sub(planetCenterPoint, asteroidPoint)
	asteroidDirection:mult(math.random(20,40)/100) --random range : level params
	asteroid:setLinearVelocity( asteroidDirection.x, asteroidDirection.y )
	
	asteroid.collision = crashAsteroid ; 
	asteroid:addEventListener( "collision", asteroid )
	asteroid.name = "asteroid"..math.random(1000)
	
	table.insert(asteroids, asteroid)
end


------------------------------------------------------------------------------------------

function stop()
	
	while (#asteroids > 0) do
		hud.explode(asteroids[1], 4, 4400, asteroids[1].color)
		table.remove(asteroids, 1)
	end
	
	state	= IDLE
end

function exit()
	stop()
	router.openAppHome()
	
	display.remove(hud.exitButton)
	display.remove(hud.topRightText)
end

-----------------------------------------------------------------------------------------

function endGame(message)
   stop()
	hud.explodeHUD()
	hud.explode(planet, 7, 3500, planet.color)	
	hud.centerText(message)	
   timer.performWithDelay(2000, exit)
end

-----------------------------------------------------------------------------------------

function completeLevel()	
	endGame("Level " .. level .. " Complete !")
	savedData.levels[level+1] = { available = true }
   utils.saveTable(savedData, "savedData.json")
end
