-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

planet = {}
colors = {}
colors[1] = "blue"
colors[2] = "green"
colors[3] = "yellow"
colors[4] = "red"

points = 0

asteroids = {}

-----------------------------------------------------------------------------------------
--set up collision filters

local asteroidFilter = { categoryBits=1, maskBits=14 }
local planetFilter 	= { categoryBits=8, maskBits=1 }

-----------------------------------------------------------------------------------------

function prepare(view)
	asteroidBuilder()
	setPlanetColor("blue")
end

function asteroidBuilder()
	timer.performWithDelay( 450, function() --delay :  level params
		createAsteroid()
		asteroidBuilder()
	end)
end

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
	-- calculating points
	
	if(planet.color == self.color) then
		points = points + 5
	else
		points = points - 2
	end
	
	if(points < 0) then
		points = 0
	end
	
	hud.score.text = points
	hud.score.x = display.contentWidth - hud.score.contentWidth/2 - 10

	--------------------------
	--
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

	asteroid.beingDestroyed = true
	
	transition.to( asteroid, { time=150, alpha=0, onComplete=function() asteroid:removeSelf() asteroid=nil end } )

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
   	destroyAsteroid(closestAsteroid)	
   	return vector2D:new(closestAsteroid.x, closestAsteroid.y)
   end

end

------------------------------------------------------------------------------------------

function createAsteroid()
	local num = math.random(1,4)
	local color = colors[num]
	
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
