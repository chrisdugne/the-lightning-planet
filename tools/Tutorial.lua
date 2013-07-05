-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

planet = {}
asteroids = {}

texts = {
	{ 
		text 	= "This is your Planet",
		x 		= 110,
		y 		= display.contentHeight/2
	}
}

arrows = {
	{ 
		way 	= "right",
		xFrom 		= 110,
		yFrom 		= display.contentHeight/2,
		xTo 			= display.contentWidth/2 - 60,
		yTo 			= display.contentHeight/2
	}
}

scene = {}

-----------------------------------------------------------------------------------------
--set up collision filters

local asteroidFilter = { categoryBits=1, maskBits=14 }
local planetFilter 	= { categoryBits=8, maskBits=1 }

-----------------------------------------------------------------------------------------

function displayText(num)

	local text = display.newText( texts[num].text, 0, 0, "SelfDestructButtonBB", 23 )
	text:setTextColor( 255 )	
	text.alpha = 0
	text.x = texts[num].x
	text.y = texts[num].y
	scene:insert(text)

	transition.to( text, { time=300, alpha=1, onComplete=function() step2() end} )
end

-----------------------------------------------------------------------------------------

function displayArrow(num)

	local arrow = display.newImage("images/tutorial/arrow.".. arrows[num].way ..".png")
	arrow:scale(0.36,0.36)
	arrow.x = arrows[num].xFrom
	arrow.y = arrows[num].yFrom
	scene:insert(arrow)
	
	transition.to( arrow, { time=200, x = arrows[num].xTo, y = arrows[num].yTo , onComplete=function() displayText(num) end } )
	
end

-----------------------------------------------------------------------------------------

function step1(view)
	scene = view
	
	hud.topRightText.text = "Level 1 : Tutorial"
	hud.topRightText.x = display.contentWidth - hud.topRightText.contentWidth/2 - 10
	
	setPlanetColor(BLUE)
	displayArrow(1)
	
end

-----------------------------------------------------------------------------------------

function step2()
	createAsteroid()
end

-----------------------------------------------------------------------------------------

function setPlanetColor(color)
	
	if(planet.name) then
		planet:removeSelf()
	end
	
	planet = display.newImage("images/game/planet.".. color ..".png")
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
function crashAsteroid( self, event )
	local planet = event.other
	
	if(self.beingDestroyed) then
		return
	end
	
	--------------------------
	-- destroy
	
	self.beingDestroyed = true
	destroyAsteroid(self)
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
	
	transition.to( asteroid, { time=150, alpha=0, onComplete=function() asteroid:removeSelf() asteroid=nil end } )
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
   	
   	local thunderDone = function() explodeAsteroid(asteroid) end
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
				local size=math.random(30, 35) -- Particles are a bit bigger than ice comet particles
				return display.newImageRect("CBEffects/textures/generic_particle.png", size, size)
			end,
			onCreation=function()end, -- See the note for the ice comet
			perEmit=4,
			emissionNum=math.random(3,5),
			x=asteroid.x,
			y=asteroid.y,
			positionType="inRadius",
			posRadius=20,
			emitDelay=50,
			fadeInTime=50,
			lifeSpan=250, -- Particles are removed sooner than the ice comet
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

function createAsteroid()
	local nbColors
	if(game.mode == game.COMBO) then
		nbColors = LEVELS[game.level].colors
	else
		nbColors = 4
	end
	
	local num = math.random(1,nbColors)
	local color = COLORS[num]
	
	local asteroid = display.newImageRect( "images/game/asteroid." .. color .. ".png", 24, 24 )
	asteroid.color = color
	physics.addBody( asteroid, { bounce=0, radius=12, filter=asteroidFilter } )
	
	local planetCenterPoint = vector2D:new(display.contentWidth/2, display.contentHeight/2)
	local alpha = math.random(-180,180)
	local distance = 250
	
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
