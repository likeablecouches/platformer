function love.load()
	Object = require "classic"

	require "entity"
	require "player"
	require "block"
	require "ground" 
	require "scalingPassage"

	require "functions"

	groundLevel = love.graphics.getHeight() - 50

	windowWidth = love.graphics.getWidth() * 1.5
	windowHeight = love.graphics.getHeight() * 1.2

	canvasScaleX = 1
	canvasScaleY = 1

	cameraOffsetX = nil
	cameraOffsetY = nil

	isScaling = true
	scaleDirection = 1
	
	love.window.setMode(
		windowWidth,
		windowHeight)

	gravAcceleration = 1700

	entities = {}

	ground = Ground()

	player = Player(
		0, -- x0
		groundLevel - 100, -- y0
		'player.png', -- imagePath
		500, -- maxSpeedX
		2000, -- acceleration
		700 -- jumpSpeed
		)

	block = Block(300, 300)
--	block2 = Block(400, groundLevel - 50)
--	block3 = Block(400, groundLevel - 120)
--	block4 = Block(400, groundLevel - 180)

	table.insert(entities, block)
	table.insert(entities, ground)
	table.insert(entities, player)

	scalingPassages = {}

	table.insert(scalingPassages, scalingPassage(100, 200, 0.3, 1))
	table.insert(scalingPassages, scalingPassage(400, 200, 2, 0.3))

end

function love.keypressed(key)
	if key == "space" then
		if player.jumpCounter == 2 and not player.groundedOnObj then
			goto continue
		end

		player.speedY = -player.jumpSpeed
		player.jumpCounter = player.jumpCounter + 1

		::continue::
	end
end

function debugPrintCmd()
	print('--------------------------------')
	print('player.x:' .. tostring(player.x))
	print('player.y:' .. tostring(player.y))
	print('player.lastY:' .. tostring(player.lastY))
	print('player.lastFeet:' .. tostring(player.lastY + player.height))
	print('player.lastX:' .. tostring(player.lastX))
	print('player.lastRight:' .. tostring(player.lastX + player.width))
--	print('block2.x' .. tostring(block2.x))
--	print('block2.y' .. tostring(block2.y))
--	print('block2.feet' .. tostring(block2.y + block2.height))
--	print('block2.right' .. tostring(block2.x + block2.width))
	print('player.speedX:' .. tostring(player.speedX))
	print('player.speedY:' .. tostring(player.speedY))
	print('player bottom:' .. tostring(player.y + player.height))
	print('player right:' .. tostring(player.x + player.width))
	print('player.groundedOnObj:' .. tostring(player.groundedOnObj))
	print('canvasScaleY:' .. tostring(canvasScaleY))
	print('player.currentScalingPassage:' .. tostring(player.currentScalingPassage))
	print('scalingPassages[1].initialZoomRatio:' .. tostring(scalingPassages[1].initialZoomRatio))
end

function debugPrintInGame()
	love.graphics.print('player.x:' .. tostring(player.x), -cameraOffsetX, 0 - cameraOffsetY)
	love.graphics.print('player.y:' .. tostring(player.y), -cameraOffsetX, 20 - cameraOffsetY)
	love.graphics.print('player.speedX:' .. tostring(player.speedX), -cameraOffsetX, 30 - cameraOffsetY)
	love.graphics.print('player.speedY:' .. tostring(player.speedY), -cameraOffsetX, 40 - cameraOffsetY)
	love.graphics.print('player bottom:' .. tostring(player.y + player.height), -cameraOffsetX, 50 - cameraOffsetY)
	love.graphics.print('player right:' .. tostring(player.x + player.width), -cameraOffsetX, 60 - cameraOffsetY)
	love.graphics.print('player.groundedOnObj:' .. tostring(player.groundedOnObj), -cameraOffsetX, 70 - cameraOffsetY)
	love.graphics.print('canvasScaleX' .. tostring(canvasScaleX), -cameraOffsetX, 80 - cameraOffsetY)
end

function updateScales(passage)
	if not player:checkCollision(passage) then
		passage.entryDirection = nil

		if player.currentScalingPassage == passage then
			player.currentScalingPassage = nil
			passage.initialZoomRatio = nil
			passage.finalZoomRatio = nil
		end

		return
	end

	if not passage.entryDirection then
		if player.x + player.width/2 < passage.x + passage.width/2  then
			passage.entryDirection = 'left'
			passage.zoomIndex = 2
		else
			passage.entryDirection = 'right'
			passage.zoomIndex = 1
		end

	end

	if passage.entryDirection == 'left' then
		displacement = player.x + player.width - passage.x
	else
		displacement = player.x - passage.x
	end


	if not player.currentScalingPassage then
		player.currentScalingPassage = passage
		passage.initialZoomRatio = canvasScaleX
		passage.finalZoomRatio = passage.finalZoomRatios[passage.zoomIndex]
	end

	local scaleRate = (passage.finalZoomRatio - passage.initialZoomRatio) / passage.width

	if displacement > passage.width then
		totalScale = passage.finalZoomRatio

	else
		totalScale = passage.initialZoomRatio + displacement * scaleRate
	end

	canvasScaleX = totalScale
	canvasScaleY  = totalScale
end

function love.update(dt)
	for i, entity in ipairs(entities) do
		entity:update(dt)
	end

	for i, scalingPassage in ipairs(scalingPassages) do
		updateScales(scalingPassage)
	end

	cameraOffsetX = windowWidth / 2 - canvasScaleX * (player.x + player.width / 2)
    cameraOffsetY = windowHeight / 2 - canvasScaleY * (player.y + player.height / 2)

	debugPrintCmd()
end

function love.draw(dt)
	love.graphics.translate(cameraOffsetX, cameraOffsetY)
	love.graphics.scale(canvasScaleX, canvasScaleY)

	for i, entity in ipairs(entities) do
		entity:draw()
	end

	for i, scalingPassage in ipairs(scalingPassages) do
		scalingPassage:draw()
	end

	love.graphics.scale(1, 1)

	debugPrintInGame()
end
