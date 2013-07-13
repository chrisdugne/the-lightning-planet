-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local colorsEnabled = true
local lightningEnabled = true

-----------------------------------------------------------------------------------------

elements = display.newGroup()

-----------------------------------------------------------------------------------------

function initHUD()
	utils.emptyGroup(elements)
end

-----------------------------------------------------------------------------------------

function setExit(toApply)
	exitButton = display.newImage( game.scene, "images/hud/exit.png")
	exitButton.x = display.contentWidth - 15
	exitButton.y = 45
	exitButton:scale(0.17,0.17)
	exitButton:addEventListener("touch", function(event)
		if(toApply) then 
			toApply()
		end 
		game.endGame() 
	end)
	elements:insert(exitButton)
end

-----------------------------------------------------------------------------------------

function initTopRightText()
	topRightText = display.newText( game.scene, "0", 0, 0, FONT, 21 )
	topRightText:setTextColor( 255 )	
	topRightText:setReferencePoint( display.CenterReferencePoint )
	topRightText.x = display.contentWidth - topRightText.contentWidth/2 - 10
	topRightText.y = 20
	elements:insert(topRightText)
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
	elements:insert(blueButton)

	greenButton = display.newImage( game.scene, "images/hud/button.green.png")
	greenButton.x = display.contentWidth - 25
	greenButton.y = display.contentHeight - 70
	greenButton:scale(0.15,0.15)
	greenButton:addEventListener("touch", function(event) touch(event, greenButton) color(event, "green") end)
	elements:insert(greenButton)

	if(game.mode ~= game.COMBO or LEVELS[game.level].colors > 2) then	
   	yellowButton = display.newImage( game.scene, "images/hud/button.yellow.png")
   	yellowButton.x = display.contentWidth - 85
   	yellowButton.y = display.contentHeight - 70
   	yellowButton:scale(0.15,0.15)
   	yellowButton:addEventListener("touch", function(event) touch(event, yellowButton) color(event, "yellow") end)
   	elements:insert(yellowButton)
   end

	if(game.mode ~= game.COMBO or LEVELS[game.level].colors > 3) then	
   	redButton = display.newImage( game.scene, "images/hud/button.red.png")
   	redButton.x = display.contentWidth - 55
   	redButton.y = display.contentHeight - 110
   	redButton:scale(0.15,0.15)
   	redButton:addEventListener("touch", function(event) touch(event, redButton) color(event, "red") end)
   	elements:insert(redButton)
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
	elements:insert(lightButton)
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

function drawCombo(level, numCompleted)
	
   for i=elements.numChildren,1,-1 do
		if(elements[i].isComboElement) then
			display.remove(elements[i])
   	end
	end
	
	for c in pairs(LEVELS[level].combo) do
		local color = LEVELS[level].combo[c]
   	local asteroid = display.newImage(game.scene, "images/game/asteroid." .. color .. ".png")
   	asteroid.color = color
   	
   	local i = (c-1)%20
   	local j = math.floor((c-1)/20) + 1
   	
   	asteroid.x = 10 + 20 * i
   	asteroid.y = 15 * j

		if(c <= numCompleted) then
   		asteroid:scale(0.58,0.58)
   		asteroid.alpha = 1
   	else
   		asteroid:scale(0.48,0.48)
   		asteroid.alpha = 0.75
   	end
   	
		asteroid.isComboElement = true
   	elements:insert(asteroid)
	end
	
end

-----------------------------------------------------------------------------------------

function drawBag()
   for i=elements.numChildren,1,-1 do
		if(elements[i].isBagElement) then
			display.remove(elements[i])
   	end
	end
	
	for c in pairs(COLORS) do
		local color = COLORS[c]
   	local asteroid = display.newImage(game.scene, "images/game/asteroid." .. color .. ".png")
   	asteroid.color = color
   	
   	local i = 20
   	
   	asteroid.x = 13
   	asteroid.y = 25 * c - 10 
		asteroid:scale(0.48,0.48)
		asteroid.alpha = 0.75

   	colorText = display.newText( game.asteroidsCaught[color], 0, 0, FONT, 13 )
   	colorText:setTextColor( 255 )	
   	colorText.x = 30
   	colorText.y = asteroid.y - 3
   	colorText:setReferencePoint( display.CenterReferencePoint )
		colorText.isBagElement = true
   	elements:insert(colorText)

		asteroid.isBagElement = true
   	elements:insert(asteroid)
	end
end

-----------------------------------------------------------------------------------------

function drawCatch(asteroid, value, huge)

	if(value > 0) then
		value = "+ " .. value
	end

	local scale = 2.5
	if(huge) then scale = 4 end	

	local time = 1600
	if(huge) then time = 3000 end	
	
	local rgb = getRGB(asteroid.color) 
	local colorText = display.newText( value, 0, 0, FONT, 16 )
	colorText:setTextColor( rgb[1], rgb[2], rgb[3] )	
	colorText.x = asteroid.x
	colorText.y = asteroid.y
	colorText.alpha = 1
	colorText:setReferencePoint( display.CenterReferencePoint )
	
	transition.to( colorText, { 
		time=time, 
		alpha=0, 
		x= 40, 
		y= 25 * getColorNum(asteroid.color) - 10, 
		xScale=scale,
		yScale=scale,
		onComplete=function()
			display.remove(colorText)
		end
	})
	
end

-----------------------------------------------------------------------------------------

function drawPoints(change, total, asteroid, huge)

	if(type(change) == "number" and change > 0) then
		change = "+ " .. change
	end
	
	refreshTopRightText(total .. " pts")
	
	local scale = 2.5
	local time = 2000
	
	local x = asteroid.x
	local y = asteroid.y

	if(huge) then 
		scale = 4 
   	time = 4000
   	x = 40
		y= 25 * getColorNum(asteroid.color) - 10 
	end	
	
	local rgb = getRGB(asteroid.color) 
	local changeText = display.newText( change, 0, 0, FONT, 16 )
	changeText:setTextColor( rgb[1], rgb[2], rgb[3] )	
	changeText.x = x
	changeText.y = y
	changeText.alpha = 1
	changeText:setReferencePoint( display.CenterReferencePoint )
	
	transition.to( changeText, { 
		time=2000,
		alpha=0, 
		x= topRightText.x -20,
		y= 5, 
		xScale=2.5,
		yScale=2.5,
		onComplete=function()
			display.remove(changeText)
		end
	})
	
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

-----------------------------------------------------------------------------------------

function explodeHUD()
   for i=elements.numChildren,1,-1 do
		explode(elements[i], 4, 2400, elements[i].color)
	end
end
			
-----------------------------------------------------------------------------------------

function explode(element, emissionNum, fadeInTime, color)

	local colors
	if(color == BLUE) then
		colors={{0, 111, 255}, {0, 70, 255}}
	elseif(color == GREEN) then
		colors={{181, 255, 111}, {120, 255, 70}}
	elseif(color == YELLOW) then
		colors={{255, 255, 111}, {255, 255, 70}}
	elseif(color == RED) then
		colors={{255, 111, 0}, {255, 70, 0}}
	else
		colors={{255,255,220},{255,255,120}}
	end
	
	if(not emissionNum) then
		emissionNum = 3
	end

	if(not fadeInTime) then
		fadeInTime = 3500
	end
	
   local explosion=CBE.VentGroup{
   	{
   		title="fire",
   		preset="wisps",
   		color=colors,
   		x = element.x,
   		y = element.y,
   		emissionNum = emissionNum,
   		fadeInTime = fadeInTime,
   		physics={
   			gravityX=1.2,
   			gravityY=13.2,
   		}
   	}
   }
   explosion:start("fire")
   display.remove(element)
end
			
-----------------------------------------------------------------------------------------

function centerText(text, y, fontSize)

	if(not text) then
		return
	end

	if(not y) then
		y = display.contentHeight/2
	end

	if(not fontSize) then
		fontSize = 25
	end

	finalText = display.newText( text, 0, 0, FONT, fontSize )
	finalText:setTextColor( 255 )	
	finalText.x = display.contentWidth/2
	finalText.y = y
	finalText.alpha = 0
	finalText:setReferencePoint( display.CenterReferencePoint )
	elements:insert(finalText)
	
	transition.to( finalText, { time=1140, alpha=1, onComplete=function()
   	timer.performWithDelay(2000, function()
   		transition.to( finalText, { time=340, alpha=0 })
   	end)
	end})
end