-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local images = {}

-----------------------------------------------------------------------------------------

function drawImage( group, url, x, y, positionFrom, scale, smooth, next )

	local fileName = utils.imageName(url)
	local image = display.newImage( group, fileName, system.TemporaryDirectory)
	
	if not image then
		local imageReceived = function(event) return placeImage(event.target, fileName, group, x, y, positionFrom, scale, smooth, next)  end
		display.loadRemoteImage( url, "GET", imageReceived, fileName, system.TemporaryDirectory )
	else
		placeImage(image, fileName, group, x, y, positionFrom, scale, smooth, next)
	end
	
end	

-----------------------------------------------------------------------------------------

function placeImage(image, fileName, group, x, y, positionFrom, scale, smooth, next)
	group:insert(image)
	image:scale (scale, scale)

	if(positionFrom == IMAGE_TOP_LEFT) then
		image.x = x + image.width*scale/2 
		image.y = y + image.height*scale/2
	else 
		image.x = x
		image.y = y
	end

	if(smooth) then
		transition.to( image, { alpha = 1.0 } )
	else
		image.alpha = 1
	end
	
	images[fileName] = image
	next(image)
end

-----------------------------------------------------------------------------------------

function hideImage( image )
	transition.to( image, { alpha = 0, time = 400, transition = easing.outQuad } )
end