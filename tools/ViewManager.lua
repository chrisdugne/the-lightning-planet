-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function setupView(view)
	reset(view)
end

------------------------------------------------------------------------------------------

function reset(view)
	local back = display.newImage( view, "images/stars2.png")  
	back.x = display.viewableContentWidth/2  
	back.y = display.viewableContentHeight/2  
end

------------------------------------------------------------------------------------------
