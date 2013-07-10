-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local colorsEnabled = true
local lightningEnabled = true

topRightText = {}

-----------------------------------------------------------------------------------------

function setExit()
	exitButton = display.newImage( game.scene, "images/hud/exit.png")
	exitButton.x = display.contentWidth - 15
	exitButton.y = 45
	exitButton:scale(0.17,0.17)
	exitButton:addEventListener("touch", function(event) game.exit() end)
end

-----------------------------------------------------------------------------------------

function initTopRightText()
	topRightText = display.newText( game.scene, "0", 0, 0, "Papyrus", 21 )
	topRightText:setTextColor( 255 )	
	topRightText:setReferencePoint( display.CenterReferencePoint )
	topRightText.x = display.contentWidth - topRightText.contentWidth/2 - 10
	topRightText.y = 20
end

function refreshTopRightText(text)
	topRightText.text = text
	topRightText.x 	= display.contentWidth - topRightText.contentWidth/2 - 10
end

-----------------------------------------------------------------------------------------

function setupPad()
	setupButtons()
	setupLightningButton()
end

-----------------------------------------------------------------------------------------

function setupButtons()
	colorsEnabled = true

	blueButton = display.newImage( game.scene, "images/hud/button.blue.png")
	blueButton.x = display.contentWidth - 55
	blueButton.y = display.contentHeight - 30
	blueButton:scale(0.15,0.15)
	blueButton:addEventListener("touch", function(event) touch(event, blueButton) color(event, "blue") end)

	greenButton = display.newImage( game.scene, "images/hud/button.green.png")
	greenButton.x = display.contentWidth - 25
	greenButton.y = display.contentHeight - 70
	greenButton:scale(0.15,0.15)
	greenButton:addEventListener("touch", function(event) touch(event, greenButton) color(event, "green") end)

	if(game.mode ~= game.COMBO or LEVELS[game.level].colors > 2) then	
   	yellowButton = display.newImage( game.scene, "images/hud/button.yellow.png")
   	yellowButton.x = display.contentWidth - 85
   	yellowButton.y = display.contentHeight - 70
   	yellowButton:scale(0.15,0.15)
   	yellowButton:addEventListener("touch", function(event) touch(event, yellowButton) color(event, "yellow") end)
   end

	if(game.mode ~= game.COMBO or LEVELS[game.level].colors > 3) then	
   	redButton = display.newImage( game.scene, "images/hud/button.red.png")
   	redButton.x = display.contentWidth - 55
   	redButton.y = display.contentHeight - 110
   	redButton:scale(0.15,0.15)
   	redButton:addEventListener("touch", function(event) touch(event, redButton) color(event, "red") end)
   end

	Runtime:addEventListener("touch", function(event) screenTouch(event) end)
end

-----------------------------------------------------------------------------------------

function setupLightningButton()
	lightningEnabled = true

	lightButton = display.newImage( game.scene, "images/hud/button.light.png")
	lightButton.x = 40
	lightButton.y = display.contentHeight - 60
	lightButton:scale(0.15,0.15)
	lightButton:addEventListener("touch", function(event) touch(event, lightButton) light(event) end)
end

------------------------------------------------------------------------------------------

function screenTouch( event )
	if(event.phase == "ended") then
   	
   	if(lightButton) then
	   	lightButton.alpha = 1
	   end
   	
   	if(blueButton) then
	   	blueButton.alpha = 1
	   end
   	
   	if(greenButton) then
	   	greenButton.alpha = 1
	   end

   	if(yellowButton) then
	   	yellowButton.alpha = 1
	   end

   	if(redButton) then
	   	redButton.alpha = 1
	   end
   	
		transition.to( game.planet, { time=140, alpha=0.8 })
   end
end

function light( event )
	if(event.phase == "began" and lightningEnabled) then
		transition.to( game.planet, { time=40, alpha=1 })
		game.shootOnClosestAsteroid()
   end
end

function touch( event, button )
	if(event.phase == "began") then
   	button.alpha = 0.3
   end
end

function color( event, color )
	if(event.phase == "began" and colorsEnabled) then
   	game.setPlanetColor(color)
   end
end


-----------------------------------------------------------------------------------------

function drawCombo(level)
	
	for i in pairs(LEVELS[level].combo) do
		local color = LEVELS[level].combo[i]
   	local asteroid = display.newImage(game.scene, "images/game/asteroid." .. color .. ".png")
   	asteroid:scale(0.5,0.5)
   	asteroid.x = 10 + 20 * i
   	asteroid.y = 15
   	asteroid.alpha = 0.85
	end
end

-----------------------------------------------------------------------------------------

function disableColors()
 	colorsEnabled = false 
end

function enableColors()
 	colorsEnabled = true 
end

function disableLightning()
 	lightningEnabled = false 
end

function enableLightning()
 	lightningEnabled = true 
end