function love.load()
	Object = require "classic"

	require "entity"
	require "player"
	require "block"
	require "ground" 
	require "scalingPassage"
	require "gridHash"

	require "functions"

	groundLevel = 300

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
		100, -- x0
		groundLevel - 100, -- y0
		'player.png', -- imagePath
		500, -- maxSpeedX
		2000, -- acceleration
		700 -- jumpSpeed
		)

--	block = Block(400, 300)
--	block2 = Block(400, groundLevel - 50)
--	block3 = Block(400, groundLevel - 120)
--	block4 = Block(400, groundLevel - 180)

	table.insert(entities, block)
	table.insert(entities, ground)
	table.insert(entities, player)

	scalingPassages = {}

	table.insert(scalingPassages, scalingPassage(100, 200, 1, 0.3))
	table.insert(scalingPassages, scalingPassage(600, 200, 0.3, 2))


	rawHash = {

	'1000000000000000000000000000',
	'1000000000000000000000000000',
	'1000000000000000000000000000',
	'1000000000000000000000000000',
	'1000000000000000000000000000',
	'1000000000000000000000000000'

	}

	grid = GridHash(rawHash)
	grid:createBlocks(entities)

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
	print('scalingPassages[1].initialZoomRatio:' .. tostring(scalingPassages[1].initialZoomRatio))
end

function debugPrintInGame()
	love.graphics.print('player.x:' .. tostring(player.x), 0, 0)
	love.graphics.print('player.y:' .. tostring(player.y), 0,20)
	love.graphics.print('player.speedX:' .. tostring(player.speedX), 0, 30)
	love.graphics.print('player.speedY:' .. tostring(player.speedY), 0, 40)
	love.graphics.print('player bottom:' .. tostring(player.y + player.height), 0, 50)
	love.graphics.print('player right:' .. tostring(player.x + player.width), 0, 60)
	love.graphics.print('player.groundedOnObj:' .. tostring(player.groundedOnObj), 0, 70)
	love.graphics.print('canvasScaleX' .. tostring(canvasScaleX), 0, 80)
end

function updateScales(passage)
	if not player:checkCollision(passage) then
		passage.entrySide = nil

		if player.currentScalingPassage == passage then
			player.currentScalingPassage = nil
			passage.initialZoomRatio = nil
			passage.finalZoomRatio = nil
		end

		return
	end

	if not player.currentScalingPassage then
 		-- if the player has just entered the scaling region
		player.currentScalingPassage = passage
		passage.initialZoomRatio = canvasScaleX

		passage:detectEntrySide(player)

		if passage.entrySide == "left" then
			passage.finalZoomIndex = 2
		else
			passage.finalZoomIndex = 1
		end

		passage.finalZoomRatio = passage.finalZoomRatios[passage.finalZoomIndex]
		scaleRate = (passage.finalZoomRatio - passage.initialZoomRatio) / passage.width
	end

	if passage.entrySide == 'left' then
		distFromEntry = player.x + player.width - passage.x
	else
		distFromEntry = passage.x + passage.width - player.x
	end

	if distFromEntry > passage.width then
		totalScale = passage.finalZoomRatio
	else
		totalScale = passage.initialZoomRatio + distFromEntry * scaleRate
	end

	canvasScaleX = totalScale
	canvasScaleY = totalScale
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

	-- debugPrintInGame()
end
