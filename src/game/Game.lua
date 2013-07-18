-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

scene = {}

-----------------------------------------------------------------------------------------

RUNNING 		= 1
IDLE 			= 2

-----------------------------------------------------------------------------------------

CLASSIC 		= 0
COMBO 		= 1
KAMIKAZE 	= 2
TIMEATTACK 	= 3

-----------------------------------------------------------------------------------------

planet 				= {}
asteroids 			= {}
asteroidsCaught 	= {}

-----------------------------------------------------------------------------------------

points 	= 0
mode 		= 0
state 	= IDLE

kamikazePercent = 100
timePlayed 		 = 0
timeCombo 		 = 0

-----------------------------------------------------------------------------------------
--set up collision filters

local asteroidFilter = { categoryBits=1, maskBits=14 }
local planetFilter 	= { categoryBits=8, maskBits=1 }

-----------------------------------------------------------------------------------------

function init(view)

	---------------------------------------

	if(view) then
		scene = view
	end
	
	----------------------------------------

   points 				= 0
   state 				= IDLE
   
   kamikazePercent 	= 100
   timePlayed 		 	= 0
   timeCombo 		 	= 0
   	
	---------------------------------------

	setPlanetColor(BLUE)
	
	if(mode == COMBO) then
   	requestedAsteroid = 1
   else
	   for i = 1, #COLORS do
   	   asteroidsCaught[COLORS[i]] = 0
   	end
   end

	----------------------------------------

	hud.initHUD()
	hud.initTopRightText()

	----------------------------------------
	
	local tutorial = false
	
	-- Tutorial Classic
	if(mode == CLASSIC and savedData.requireTutorial) then
		tutorial = true
		hud.refreshTopRightText(T "Tutorial")
		start(false)
		tutorialClassic.start(view)
	end
	
	-- Tutorial Combo
	if(mode == COMBO and level == 1) then
		tutorial = true
		hud.refreshTopRightText(T "Tutorial")
		start(false)
		tutorialCombo.start(view)
	end

	-- Tutorial Kamikaze
	if(mode == KAMIKAZE and level == 1) then
		tutorial = true
		hud.refreshTopRightText(T "Tutorial")
		start(false)
		tutorialKamikaze.start(view)
	end

	-- Tutorial Time Attack
	if(mode == TIMEATTACK and level == 1) then
		tutorial = true
		hud.refreshTopRightText(T "Tutorial")
		start(false)
		tutorialTimeAttack.start(view)
		hud.drawTimer(90)
	end
	
	
	if(not tutorial) then
		
		if(mode == CLASSIC) then
			level = 1 
   		hud.refreshTopRightText(T "Classic")
			if(not savedData.levels[1]) then
				timer.performWithDelay(1500, function() displayInfo(T "Reach 2 min to unlock Combo mode") end)
			end
      	
      	hud.startComboTimer()
      	
		elseif(mode == COMBO) then 
			hud.drawCombo(level, 0)
      	hud.refreshTopRightText("Level " .. level)
      	hud.startComboTimer()
		
		elseif(mode == KAMIKAZE) then 
   		hud.drawProgressBar(100)
      	hud.refreshTopRightText("0 pts")
      	hud.drawBag()
		
		elseif(mode == TIMEATTACK) then 
      	hud.refreshTopRightText("0 pts")
      	hud.drawBag()
      	if(level == 2) then
				hud.drawTimer(120)
      	elseif(level == 3) then
				hud.drawTimer(300)
      	elseif(level == 4) then
				hud.drawTimer(480)
         end
      
      end
   	
   	hud.setExit()
   	hud.setupPad()
   	start()
   end   
end

-----------------------------------------------------------------------------------------

function start(requireAsteroidBuilder)
	
	if(requireAsteroidBuilder == nil) then
		requireAsteroidBuilder = true
	end

	state	= RUNNING
	
	if(requireAsteroidBuilder) then
   	hud.centerText("Start !", display.contentHeight/4, 45)
		asteroidBuilder()

   	timer.performWithDelay(1000, nextPlayedSecond)
	end
end


function nextPlayedSecond()
	if(game.state == game.IDLE) then	
		timePlayed = 0 
		return
	end
	
	timePlayed = timePlayed+1
	timer.performWithDelay(1000, nextPlayedSecond)
end

-----------------------------------------------------------------------------------------

function asteroidBuilder()
	
	local LEVELS = getCurrentLEVELS()
	local timeDelay = math.floor(timePlayed/LEVELS[level].changeDelaySec) * LEVELS[level].changeDelayAmount
	
	timer.performWithDelay( math.random(LEVELS[level].minDelay - timeDelay, LEVELS[level].maxDelay - timeDelay), function()
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

	if(mode == CLASSIC) then
		
		if(not goodCatch) then
			classicOver()
		end
	
	--------------------------

	elseif(mode == COMBO) then
		
		if(not goodCatch) then
			comboOver()
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
				kamikazePercent = kamikazePercent - ASTEROID_CRASH_KAMIKAZE_PERCENT
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
		
		if(not goodCatch and mode == KAMIKAZE) then
			if(kamikazePercent > 0) then 
				hud.drawProgressBar(kamikazePercent, ASTEROID_CRASH_KAMIKAZE_PERCENT)
			else 
      		hud.drawProgressBar(1, ASTEROID_CRASH_KAMIKAZE_PERCENT)
				kamikazeOver()
   		end
		end
		
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

function actionOnLightning(asteroid)

	if(mode == COMBO) then
		
		local goodCatch = COMBO_LEVELS[level].combo[requestedAsteroid] == asteroid.color
		
		if(goodCatch) then
			hud.drawCombo(level, requestedAsteroid)
			requestedAsteroid = requestedAsteroid + 1
			
			if(requestedAsteroid > #COMBO_LEVELS[level].combo) then
				completeLevel()
   		end
   	else
   		requestedAsteroid = 1
			hud.drawCombo(level, 0)
   	end
   	
	elseif(mode == KAMIKAZE or mode == TIMEATTACK) then
		
		local change 		= asteroidsCaught[asteroid.color] * asteroidsCaught[asteroid.color]
		local changeText 	= asteroidsCaught[asteroid.color] .. " x "  ..  asteroidsCaught[asteroid.color]
		local total = points + change

		asteroidsCaught[asteroid.color] = math.floor(asteroidsCaught[asteroid.color]/2)
		kamikazePercent = kamikazePercent - LIGHTNING_KAMIKAZE_PERCENT

		hud.drawPoints(changeText, total, asteroid, true)
		hud.drawCatch(asteroid.x, asteroid.y, asteroid.color, "/2")
		hud.drawBag()
		
		if(mode == KAMIKAZE) then
   		if(kamikazePercent > 0) then 
      		hud.drawProgressBar(kamikazePercent, LIGHTNING_KAMIKAZE_PERCENT)
			else 
      		hud.drawProgressBar(1, LIGHTNING_KAMIKAZE_PERCENT)
				kamikazeOver()
   		end 
		end 
		
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
   		actionOnLightning(asteroid)
   		explodeAsteroid(asteroid) 
   	end

   	lightning.thunder(planetPosition, asteroidPosition, thunderDone)
   	musicManager.playLight()
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
   musicManager.playPlanet()

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
   musicManager.playAsteroid()
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

	local LEVELS = getCurrentLEVELS()
	local nbColors = LEVELS[level].colors
	
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

	local speed = math.random(LEVELS[level].minSpeed, LEVELS[level].maxSpeed)/100
	local speedOffset = math.floor(timePlayed/LEVELS[level].changeDelaySec)/100
	
	asteroidDirection = vector2D:Sub(planetCenterPoint, asteroidPoint)
	asteroidDirection:mult(speed + speedOffset) 
	asteroid:setLinearVelocity( asteroidDirection.x, asteroidDirection.y )
	
	asteroid.collision = crashAsteroid ; 
	asteroid:addEventListener( "collision", asteroid )
	asteroid.name = "asteroid"..math.random(1000)
	
	table.insert(asteroids, asteroid)
end


------------------------------------------------------------------------------------------

-- Combo Game Over
function comboOver()
	endGame("Game Over !")
	timeCombo = T "Fail !"
end

------------------------------------------------------------------------------------------

-- end of Time Attack Level
function timerDone()
	endGame("Game Over !")
end

------------------------------------------------------------------------------------------

-- end of Kamikaze Level
function kamikazeOver()
	endGame("Game Over !")
end

------------------------------------------------------------------------------------------

-- end of Classic mode
function classicOver()
	local min,sec = utils.getMinSec(game.timeCombo)
	endGame(min .. ":" .. sec)
	
	if(not savedData.levels[1] and timeCombo > 119) then
		displayInfo("Combo mode unlocked !")
   	savedData.levels[1] = { available = true }
      utils.saveTable(savedData, "savedData.json")
	end
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
	router.openScore()
end

-----------------------------------------------------------------------------------------

function endGame(message, next)
   stop()
	hud.explodeHUD()
	hud.explode(planet, 7, 3500, planet.color)	

	if(message) then		
		hud.centerText(message)

   	if(next) then		
      	timer.performWithDelay(2000, next)
      else
      	timer.performWithDelay(2000, exit)
      end
   else
   	-- button exit
		router.openAppHome()
   end
end

-----------------------------------------------------------------------------------------

function completeLevel()	
	endGame("Level " .. level .. " Complete !")
	savedData.levels[level+1] = { available = true }
   utils.saveTable(savedData, "savedData.json")
end

-----------------------------------------------------------------------------------------

function displayInfo(message)

	local text = display.newText( message, 0, 0, FONT, 15 )
	text:setTextColor( 255 )	
	text.alpha = 0
	text.x = display.contentWidth/2
	text.y = display.contentHeight/3
	scene:insert(text)

	transition.to( text, { 
		time=300, 
		alpha=1, 
		onComplete = function()
			timer.performWithDelay( 2000, function ()
				transition.to( text, { time=300, alpha=0}) 
			end) 
		end
	})
end


-----------------------------------------------------------------------------------------

function getCurrentLEVELS()

	if(mode == COMBO) then
		return COMBO_LEVELS
	elseif(mode == CLASSIC) then
		return CLASSIC_LEVELS
	elseif(mode == KAMIKAZE) then
		return KAMIKAZE_LEVELS
	elseif(mode == TIMEATTACK) then
		return TIMEATTACK_LEVELS
	end
	
end