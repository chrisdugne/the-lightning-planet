-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

PLANET_PULL = 0.25

--------------------------------------------------------------------

local planet

-----------------------------------------------------------------------------------------
--set up collision filters

local asteroidFilter = { categoryBits=1, maskBits=14 }
local planetFilter 	= { categoryBits=8, maskBits=1 }

--local fieldFilter = { categoryBits=4, maskBits=1 }
--local screenFilter = { categoryBits=2, maskBits=1 }

-----------------------------------------------------------------------------------------

function prepare(view)

	planet = display.newImage( view, "images/hud/button.light.png")
	planet:scale(0.15,0.15)
	planet.x = display.contentWidth/2
	planet.y = display.contentHeight/2
	planet.name = "planet"
	physics.addBody( planet, "static", { bounce=0, radius=24, filter=planetFilter } )
	
	asteroidBuilder()
end

function asteroidBuilder()
	timer.performWithDelay( 500, function() --delay :  level params
		createAsteroid()
		asteroidBuilder()
	end)
end

------------------------------------------------------------------------------------------
--
function objectCollide( self, event )

	local otherName = event.other.name
	print(self.name .. " collides with " .. otherName)
	
	local function onDelay( event )
		local action = ""
		if ( event.source ) then action = event.source.action ; timer.cancel( event.source ) end
		
		if ( action == "makeJoint" ) then
			self.hasJoint = true
			self.touchJoint = physics.newJoint( "touch", self, self.x, self.y )
			self.touchJoint.frequency = magnetPull
			self.touchJoint.dampingRatio = 0.0
			self.touchJoint:setTarget( 512, 384 )
		elseif ( action == "leftField" ) then
			self.hasJoint = false ; self.touchJoint:removeSelf() ; self.touchJoint = nil
		else
			if ( self.hasJoint == true ) then self.hasJoint = false ; self.touchJoint:removeSelf() ; self.touchJoint = nil end
			newPositionVelocity( self )
		end
	end

	if ( event.phase == "ended" and otherName == "screenBounds" ) then
		local tr = timer.performWithDelay( 10, onDelay ) ; tr.action = "leftScreen"
	elseif ( event.phase == "began" and otherName == "magnet" ) then
		transition.to( self, { time=400, alpha=0, onComplete=onDelay } )
	elseif ( event.phase == "began" and otherName == "field" and self.hasJoint == false ) then
		local tr = timer.performWithDelay( 10, onDelay ) ; tr.action = "makeJoint"
	elseif ( event.phase == "ended" and otherName == "field" and self.hasJoint == true ) then
		local tr = timer.performWithDelay( 10, onDelay ) ; tr.action = "leftField"
	end

end

------------------------------------------------------------------------------------------

function createAsteroid()
	local asteroid = display.newImageRect( "images/game/asteroid.blue.png", 24, 24 )
	physics.addBody( asteroid, { bounce=0, radius=12, filter=asteroidFilter } )
	
	local planetCenterPoint = vector2D:new(display.contentWidth/2, display.contentHeight/2)
	local alpha = math.random(-180,180)
	local distance = 500
	
	local asteroidPoint = vector2D:new(distance*math.cos(alpha), distance*math.sin(alpha))
	asteroidPoint = vector2D:Add(planetCenterPoint, asteroidPoint)
	asteroid.x = asteroidPoint.x
	asteroid.y = asteroidPoint.y

	asteroidDirection = vector2D:Sub(planetCenterPoint, asteroidPoint)
	asteroidDirection:mult(math.random(20,40)/100) --random range : level params
	asteroid:setLinearVelocity( asteroidDirection.x, asteroidDirection.y )
	
	asteroid.hasJoint = false
	asteroid.collision = objectCollide ; 
	asteroid:addEventListener( "collision", asteroid )
	asteroid.name = "asteroid"
end
