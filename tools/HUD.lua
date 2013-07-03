-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local lightButton
local yellowButton
local redButton
local blueButton
local greenButton

-----------------------------------------------------------------------------------------

function setupButtons(view)

	lightButton = display.newImage( view, "images/hud/button.light.png")
	lightButton.x = 40
	lightButton.y = display.contentHeight - 60
	lightButton:scale(0.15,0.15)
	lightButton:addEventListener("touch", function(event) touch(event, lightButton) light(event) end)
	

	yellowButton = display.newImage( view, "images/hud/button.yellow.png")
	yellowButton.x = display.contentWidth - 55
	yellowButton.y = display.contentHeight - 110
	yellowButton:scale(0.15,0.15)
	yellowButton:addEventListener("touch", function(event) touch(event, yellowButton) end)

	redButton = display.newImage( view, "images/hud/button.red.png")
	redButton.x = display.contentWidth - 25
	redButton.y = display.contentHeight - 70
	redButton:scale(0.15,0.15)
	redButton:addEventListener("touch", function(event) touch(event, redButton) end)

	greenButton = display.newImage( view, "images/hud/button.green.png")
	greenButton.x = display.contentWidth - 85
	greenButton.y = display.contentHeight - 70
	greenButton:scale(0.15,0.15)
	greenButton:addEventListener("touch", function(event) touch(event, greenButton) end)

	blueButton = display.newImage( view, "images/hud/button.blue.png")
	blueButton.x = display.contentWidth - 55
	blueButton.y = display.contentHeight - 30
	blueButton:scale(0.15,0.15)
	blueButton:addEventListener("touch", function(event) touch(event, blueButton) end)

	Runtime:addEventListener("touch", function(event) screenTouch(event) end)
	
end

------------------------------------------------------------------------------------------

function screenTouch( event )
	if(event.phase == "ended") then
   	yellowButton.alpha 	= 1
   	redButton.alpha 		= 1
   	greenButton.alpha	 	= 1
   	blueButton.alpha 		= 1
   	lightButton.alpha 	= 1
   end
end

function light( event )
	if(event.phase == "began") then
   	lightning.thunder()
   end
end

function touch( event, button )
	if(event.phase == "began") then
   	button.alpha = 0.3
	elseif(event.phase == "ended") then
   	button.alpha = 1
   end
end
