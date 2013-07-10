-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function initView(view)
	reset(view)
end

------------------------------------------------------------------------------------------

function reset(view)
	local back = display.newImage( view, "images/stars.jpg")  
	back:scale(0.7,0.7)
	back.x = display.viewableContentWidth/2  
	back.y = display.viewableContentHeight/2  
end

------------------------------------------------------------------------------------------
