-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

function setupView(view)
	reset(view)
end

------------------------------------------------------------------------------------------

function reset(view)
	local bg = display.newRect( display.screenOriginX, display.screenOriginY, display.contentWidth, display.contentHeight )
	bg:setFillColor( 0 )
	view:insert( bg )
end

------------------------------------------------------------------------------------------
