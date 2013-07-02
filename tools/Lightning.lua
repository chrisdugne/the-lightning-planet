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

function thunder() 
	
	
	local planetCenterPoint = vector2D:new(display.contentWidth/2, display.contentHeight/2)
	local planetTopPoint 	= vector2D:new(display.contentWidth/2, display.contentHeight/2 + 30)
	local planetLeftPoint 	= vector2D:new(display.contentWidth/2 - 30, display.contentHeight/2)
	local planetBottomPoint = vector2D:new(display.contentWidth/2, display.contentHeight/2 - 30)
	local planetRightPoint 	= vector2D:new(display.contentWidth/2 + 30, display.contentHeight/2)
	
	local segmentsB = buildBolt(planetTopPoint, planetLeftPoint,3)
	local segmentsC = buildBolt(planetLeftPoint, planetBottomPoint,3)
	local segmentsD = buildBolt(planetBottomPoint, planetRightPoint,3)
	local segmentsA = buildBolt(planetRightPoint, planetCenterPoint,3)
	
	local endPoint = vector2D:new(math.random(display.contentWidth/2-400, display.contentWidth/2+400), math.random(display.contentHeight/2-300, display.contentHeight/2+300))
	
	local midPoint = vector2D:Average(planetCenterPoint, endPoint)
	
	local segments1 = buildBolt(planetCenterPoint, midPoint,5)
	local segments2 = buildBolt(planetCenterPoint, endPoint,5)

	lightBolt(segmentsA)
	lightBolt(segmentsB)
	lightBolt(segmentsC)
	lightBolt(segmentsD)

	lightBolt(segments1)
	lightBolt(segments2)
	
end

function lightBolt(segments)
	for i in pairs(segments) do
		local brightness = segments[i].brightness
		
	   for k = 1, 4.5*brightness do
   		local line = display.newLine(segments[i].startPoint.x+k, segments[i].startPoint.y+k, segments[i].endPoint.x+k, segments[i].endPoint.y+k)
   	
   		line:setColor(255, 255 - 225*(1-brightness), 255 - 225*(1-brightness))
      	line.alpha = 0
      	line.width = 5.5*brightness
   
   		timer.performWithDelay( 120*brightness, function ()
   			lightning.light(line, brightness/k, function()  lightning.hide(line, brightness) end)
   		end)
	   end
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

   		local midPoint = vector2D:Average(startPoint, endPoint)
   		
   		local direction = vector2D:Sub(endPoint, startPoint)
   		local normalized = vector2D:Normalize(direction)
   		local offset = vector2D:Perpendicular(normalized)
   		
   		local param = segments[i].brightness*35
   		offset:mult(math.random(-param, param)/generation)

   		midPoint:add(offset)
   		
   		local direction2 = vector2D:Sub(midPoint, startPoint)
   		direction2:rotate(math.random(-1, 1) * segments[i].brightness)
   		direction2:mult(1.3)
   		
         local splitPoint =  vector2D:Add(midPoint, direction2) 
   		
   		newSegments[3*i - 2] = {startPoint = midPoint, 		endPoint = splitPoint, brightness = 3*brightness/4}
   		newSegments[3*i - 1] = {startPoint = startPoint, 	endPoint = midPoint, brightness = brightness}
   		newSegments[3*i] 		= {startPoint = midPoint, 		endPoint = endPoint, brightness = brightness}
		end
		
		segments = newSegments
   end 
   
   return segments
end 
