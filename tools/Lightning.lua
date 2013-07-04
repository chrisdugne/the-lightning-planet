-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function light(part, alphaTo, oncomplete)
	transition.to( part, { time=4/alphaTo, alpha=alphaTo, transition=easing.inQuad, onComplete=oncomplete } )
end

function hide(part, brightness, oncomplete)
	transition.to( part, { time=400*brightness, alpha=0, transition=easing.inQuad, onComplete=oncomplete } )
end

------------------------------------------------------------------------------------------

function thunder(planetPosition, asteroidPosition, onComplete) 
	lightBolt(buildBolt(planetPosition, asteroidPosition, 4), onComplete)
end

function lightBolt(segments, onComplete)
     
	for i in pairs(segments) do
		local brightness = segments[i].brightness
		
		local line = display.newLine(segments[i].startPoint.x, segments[i].startPoint.y, segments[i].endPoint.x, segments[i].endPoint.y)
		line:setColor(255, 255 - 225*(1-brightness), 255 - 225*(1-brightness))
       
   	line.alpha = 0
   	line.width = 1.7*brightness
	
		local next
		if(i == #segments) then
			next = function() lightning.hide(line, brightness) onComplete() end
		else
			next = function() lightning.hide(line, brightness) end
		end
		
		timer.performWithDelay( 90/brightness, function ()
			lightning.light(line, brightness, next)
		end)
   end
end

function buildBolt(startPoint, endPoint, generations)

	local segments = {}
	segments[1] = {startPoint = startPoint, endPoint = endPoint, brightness = 1}
	
   for generation = 1, generations do
   	local newSegments = {}

		for i in pairs(segments) do
		
			local startPoint	= segments[i].startPoint
			local endPoint 	= segments[i].endPoint
			local brightness 	= segments[i].brightness

   		local midPoint 	= vector2D:Average(startPoint, endPoint)
   		
   		local direction 	= vector2D:Sub(endPoint, startPoint)
   		local normalized 	= vector2D:Normalize(direction)
   		local offset 		= vector2D:Perpendicular(normalized)
   		
   		local param = segments[i].brightness*35
   		offset:mult(math.random(-param, param)/generation)

   		midPoint:add(offset)
   		
   		local direction2 = vector2D:Sub(midPoint, startPoint)
   		direction2:rotate(math.random(-0.8, 0.8) * segments[i].brightness)
   		direction2:mult(0.6)
   		
         local splitPoint =  vector2D:Add(midPoint, direction2) 
   		
   		newSegments[3*i - 2] = {startPoint = midPoint, 		endPoint = splitPoint, brightness = 3*brightness/4}
   		newSegments[3*i - 1] = {startPoint = startPoint, 	endPoint = midPoint, brightness = brightness}
   		newSegments[3*i] 		= {startPoint = midPoint, 		endPoint = endPoint, brightness = brightness}
		end
		
		segments = newSegments
   end 
   
   return segments
end 
