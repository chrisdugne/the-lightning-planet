-----------------------------------------------------------------------------------------

module(..., package.seeall)

-----------------------------------------------------------------------------------------

local colorsEnabled = true
local lightningEnabled = true

-----------------------------------------------------------------------------------------

elements = display.newGroup()
powerBarFire 	= nil

-----------------------------------------------------------------------------------------

function initHUD()
	utils.emptyGroup(elements)
	lockElements = display.newGroup()
end

-----------------------------------------------------------------------------------------

function setExit(toApply)
	exitButton = display.newImage( game.scene, "assets/images/hud/exit.png")
	exitButton.x = display.contentWidth - 20
	exitButton.y = 45
	exitButton.alpha = 0.5
	exitButton:scale(0.75,0.75)
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
	display.remove(topRightText)
	topRightText = display.newText( game.scene, "0", 0, 0, FONT, 21 )
	topRightText:setTextColor( 255 )	
	topRightText:setReferencePoint( display.CenterReferencePoint )
	topRightText.x = display.contentWidth - topRightText.contentWidth/2 - 10
	topRightText.y = 20
	elements:insert(topRightText)
end

function refreshTopRightText(text)
	if(topRightText) then
		topRightText.text = text
		topRightText.x 	= display.contentWidth - topRightText.contentWidth/2 - 10
	end
end

-----------------------------------------------------------------------------------------
--- The bottom part asking to unlock the game

function initLockElements()
	display.remove(lockElements)
	
	local text = display.newText( lockElements, "", 0, 0, FONT, 10 )
	text:setTextColor( 255 )	
	text:addEventListener	("touch", goToBuy)

	lockElements.text = text

	local lockImage = display.newImage(lockElements, "assets/images/hud/lock.png")
	lockImage.x = 40
	lockImage.y = display.contentHeight-12
	lockImage:scale(0.15,0.15)
	lockImage:addEventListener	("touch", goToBuy)

	local arrowImage = display.newImage(lockElements, "assets/images/tutorial/arrow.left.png")
	arrowImage.x = 55
	arrowImage.y = display.contentHeight-10
	arrowImage:scale(0.07,0.07)
	arrowImage:addEventListener	("touch", goToBuy)

	elements:insert(lockElements)
	lockElements.alpha = 0
end

function refreshLockElements(time)
	lockElements.alpha = 1
	local min,sec = utils.getMinSec(time)
	local text = "Get the full version to remove time limit   "
	if(lockElements) then
		lockElements.text.text =  text .. min .. ":" .. sec 
  		lockElements.text:setReferencePoint(display.TopLeftReferencePoint)
		lockElements.text.x = 65
		lockElements.text.y = display.contentHeight-18
	end
end

function goToBuy() 
	game.endGame("", router.openBuy)
end

-----------------------------------------------------------------------------------------

function setupPad()
	setupButtons()
	
	if(game.mode ~= game.CLASSIC) then
		setupLightningButton()
   end
end

-----------------------------------------------------------------------------------------

function setupButtons()
	colorsEnabled = true

	blueButton = display.newImage( game.scene, "assets/images/hud/button.blue.png")
	blueButton.x = display.contentWidth - 55
	blueButton.y = display.contentHeight - 30
	blueButton:scale(0.15,0.15)
	blueButton:addEventListener("touch", function(event) touch(event, blueButton) color(event, "blue") end)
	elements:insert(blueButton)

	greenButton = display.newImage( game.scene, "assets/images/hud/button.green.png")
	greenButton.x = display.contentWidth - 25
	greenButton.y = display.contentHeight - 70
	greenButton:scale(0.15,0.15)
	greenButton:addEventListener("touch", function(event) touch(event, greenButton) color(event, "green") end)
	elements:insert(greenButton)

	if((game.mode == game.COMBO 		and COMBO_LEVELS[game.level].colors > 2)
	or (game.mode == game.CLASSIC)
	or (game.mode == game.KAMIKAZE 	and KAMIKAZE_LEVELS[game.level].colors > 2)
	or (game.mode == game.TIMEATTACK and TIMEATTACK_LEVELS[game.level].colors > 2)) 
	then	
   	yellowButton = display.newImage( game.scene, "assets/images/hud/button.yellow.png")
   	yellowButton.x = display.contentWidth - 85
   	yellowButton.y = display.contentHeight - 70
   	yellowButton:scale(0.15,0.15)
   	yellowButton:addEventListener("touch", function(event) touch(event, yellowButton) color(event, "yellow") end)
   	elements:insert(yellowButton)
   end

	if((game.mode == game.COMBO 		and COMBO_LEVELS[game.level].colors > 3)
	or (game.mode == game.CLASSIC)
	or (game.mode == game.KAMIKAZE 	and KAMIKAZE_LEVELS[game.level].colors > 3)
	or (game.mode == game.TIMEATTACK and TIMEATTACK_LEVELS[game.level].colors > 3)) 
	then
   	redButton = display.newImage( game.scene, "assets/images/hud/button.red.png")
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

	lightButton = display.newImage( game.scene, "assets/images/hud/button.light.png")
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

function lightCombo(element)
	local light=CBE.VentGroup{
   	{
   		title="fire",
   		preset="burn",
   		color={getRGB(element.color)},
   		build=function()
   			local size=math.random(8, 12) -- Particles are a bit bigger than ice comet particles
   			return display.newImageRect("CBEffects/textures/generic_particle.png", size, size)
			end,
			onCreation=function()end,
			perEmit=1,
			emissionNum=1,
			point1={element.x-2, element.y},
			point2={element.x+2, element.y},
			positionType="alongLine",
			emitDelay=10,
   		fadeInTime=100,
   		lifeSpan=150, -- Particles are removed sooner than the ice comet
   		lifeStart=50,
   		endAlpha=0,
   		physics={
   			velocity=0.2,
   			gravityX=0.1,
   			gravityY=0.6,
   		}
   	}
	}
   	
	light:start("fire")
end

-----------------------------------------------------------------------------------------


function drawCombo(level, numCompleted)
	
   for i=elements.numChildren,1,-1 do
		if(elements[i].isComboElement) then
   		
   		if(numCompleted == 0 and not elements[i].dontLight) then
				lightCombo(elements[i])
			end
			
			display.remove(elements[i])
   	end
	end
	
	local square = display.newImage(game.scene, "assets/images/hud/square.png")
	square:scale(0.5,0.5)
	square.x = 35
	square.y = 35
	square.isComboElement = true
	square.dontLight = true
	
	elements:insert(square)
	
	local combo = COMBO_LEVELS[level].combo[numCompleted+1]
	
	if(combo) then
		drawCurrentCombo(combo, numCompleted+1)
	end

	for c = numCompleted+2, #COMBO_LEVELS[level].combo do
		local color = COMBO_LEVELS[level].combo[c]
   	drawComboTodo(color, c, numCompleted)
	end
	
	for c = 1, numCompleted do
		local color = COMBO_LEVELS[level].combo[c]
   	drawComboDone(color, c)
	end
	
	
	
end

function drawCurrentCombo(color, num)

	local asteroid = display.newImage(game.scene, "assets/images/game/asteroid." .. color .. ".png")
	asteroid.color 			= color
	asteroid.isComboElement = true
	asteroid.comboNum 		= num
	asteroid.dontLight 		= true

	asteroid.x = 35
	asteroid.y = 35
	asteroid:scale(0.8,0.8)
	asteroid.alpha = 0
	
	transition.to(asteroid, {alpha = 1, time=300})
	elements:insert(asteroid)
end

function drawComboTodo(color, num, numCompleted)

	local asteroid = display.newImage(game.scene, "assets/images/game/asteroid." .. color .. ".png")
	asteroid.color 	= color
	asteroid.comboNum = num

	local i = math.floor((num-2-numCompleted)/10) + 1
	local j = (num-2-numCompleted)%10

	asteroid.x = 5 + 13 * i
	asteroid.y = 90 + 15 * (j-1)
	asteroid:scale(0.24,0.24)

	lightCombo(asteroid)

	asteroid.isComboElement = true
	elements:insert(asteroid)
end

function drawComboDone(color, num)

	local asteroid = display.newImage(game.scene, "assets/images/game/asteroid." .. color .. ".png")
	asteroid.color 	= color
	asteroid.comboNum = num

	local i = (num-1)%16
	local j = math.floor((num-1)/16) + 1

	asteroid.x = 70 + 13 * i
	asteroid.y = 5 + 13 * j
	asteroid:scale(0.24,0.24)

	lightCombo(asteroid)

	asteroid.isComboElement = true
	elements:insert(asteroid)
end

-----------------------------------------------------------------------------------------

function drawBag()
   for i=elements.numChildren,1,-1 do
		if(elements[i].isBagElement) then
			display.remove(elements[i])
   	end
	end
	
	local LEVELS
	if(game.mode == KAMIKAZE) then
		LEVELS = KAMIKAZE_LEVELS
	else
		LEVELS = TIMEATTACK_LEVELS
	end
	
	for c = 1, LEVELS[game.level].colors do
		local color = COLORS[c]
   	local asteroid = display.newImage(game.scene, "assets/images/game/asteroid." .. color .. ".png")
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

function drawProgressBar(percent, loss)         
	if(powerBarFire) then powerBarFire:stop("fire") end
	
	powerBarFire=CBE.VentGroup{
   	{
   		title="fire",
   		preset="burn",
   		color={{160-percent,155*percent/100,15 + percent/40}},
   		build=function()
   			local size=math.random(34, 58) -- Particles are a bit bigger than ice comet particles
   			return display.newImageRect("CBEffects/textures/generic_particle.png", size, size)
			end,
			onCreation=function()end,
			perEmit=3,
			emissionNum=0,
			point1={display.contentWidth/4, 20},
			point2={display.contentWidth/4 + display.contentWidth/2 * percent/100, 20},
			positionType="alongLine",
			emitDelay=10,
   		fadeInTime=1200,
   		lifeSpan=1250, -- Particles are removed sooner than the ice comet
   		lifeStart=50,
   		endAlpha=0,
   		physics={
   			velocity=0.2,
   			gravityY=0.1,
   		}
   	}
	}
   	
	powerBarFire:start("fire")

	if(loss) then	
   	local lossFire=CBE.VentGroup{
      	{
      		title="fire",
      		preset="burn",
      		color={{140-percent,155*percent/100,15 + percent/40}},
      		build=function()
      			local size=math.random(34, 38) -- Particles are a bit bigger than ice comet particles
      			return display.newImageRect("CBEffects/textures/generic_particle.png", size, size)
   			end,
   			onCreation=function()end,
   			perEmit=6,
   			emissionNum=loss,
   			point1={display.contentWidth/4 + display.contentWidth/2 * percent/100, 20},
   			point2={display.contentWidth/4 + display.contentWidth/2 * (percent+loss)/100, 20},
   			positionType="alongLine",
   			emitDelay=10,
      		fadeInTime=1600,
      		lifeSpan=450, -- Particles are removed sooner than the ice comet
      		lifeStart=50,
      		endAlpha=0,
      		physics={
      			velocity=0.2,
      			gravityX=2.1,
      			gravityY=1.1,
      		}
      	}
   	}
      	
   	lossFire:start("fire")
   end
end

-----------------------------------------------------------------------------------------

function drawCatch(x, y, color, value, huge)

	if(type(value) == "number" and value > 0) then
		value = "+ " .. value
	end

	local scale = 2.5
	if(huge) then scale = 4 end	

	local time = 1600
	if(huge) then time = 3000 end	
	
	local rgb = getRGB(color) 
	local colorText = display.newText( value, 0, 0, FONT, 16 )
	colorText:setTextColor( rgb[1], rgb[2], rgb[3] )	
	colorText.x = x
	colorText.y = y
	colorText.alpha = 1
	colorText:setReferencePoint( display.CenterReferencePoint )
	
	transition.to( colorText, { 
		time=time, 
		alpha=0, 
		x= 40, 
		y= 25 * getColorNum(color) - 10, 
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
	
	if(powerBarFire) then powerBarFire:stop("fire") end
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
		colors={{65,65,62},{55,55,20}}
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

function drawTimer(seconds)
	
	local min,sec = utils.getMinSec(seconds)
	
	display.remove(timeLeftText)
	timeLeftText = display.newText( game.scene, "0", 0, 0, FONT, 34 )
	timeLeftText:setTextColor( 255 )	
	timeLeftText.text = min .. ":" .. sec
	timeLeftText:setReferencePoint( display.CenterReferencePoint )
	timeLeftText.x = display.contentWidth/2
	timeLeftText.y = 20
	elements:insert(timeLeftText)

	timer.performWithDelay(1000, function() time(seconds) end)
end


function time(seconds)
	if(game.state == game.IDLE) then	return end
	
	seconds = seconds-1
	local min,sec = utils.getMinSec(seconds)
	timeLeftText.text = min .. ":" .. sec
	
	if(seconds == 0) then
		game.timerDone()
	else	
		timer.performWithDelay(1000, function() time(seconds) end)
	end
	
end
			
-----------------------------------------------------------------------------------------

function startComboTimer()
	display.remove(timeLeftText)
	timeLeftText = display.newText( game.scene, "0", 0, 0, FONT, 24 )
	timeLeftText:setTextColor( 255 )	
	timeLeftText.text = "0:00"
	timeLeftText:setReferencePoint( display.CenterReferencePoint )
	
	if(game.mode == game.COMBO) then
		timeLeftText.x = display.contentWidth * 0.7
	else
		timeLeftText.x = display.contentWidth * 0.1
	end
	
	timeLeftText.y = 20
	elements:insert(timeLeftText)

	game.timeCombo = 0
	timer.performWithDelay(1000, nextSecondCombo)
end


function nextSecondCombo()
	if(game.state == game.IDLE) then	return end
	
	game.timeCombo = game.timeCombo+1
	local min,sec = utils.getMinSec(game.timeCombo)
	timeLeftText.text = min .. ":" .. sec
	
	timer.performWithDelay(1000, nextSecondCombo)
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
		fontSize = 45
	end

	finalText = display.newText( text, 0, 0, FONT, fontSize )
	finalText:setTextColor( 255 )	
	finalText.x = display.contentWidth/2
	finalText.y = y
	finalText.alpha = 0
	finalText:scale(0.5,0.5) 
	finalText:setReferencePoint( display.CenterReferencePoint )
	elements:insert(finalText)
	
	transition.to( finalText, { 
		time=1140, 
		alpha=1, 
		xScale=1,
		yScale=1,
		onComplete=function()
			transition.to( finalText, { time=1200, alpha=0 })
		end
	})
end