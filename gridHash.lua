require "block"
GridHash = Object:extend()

function stringToList(inString)
	processedList = {}
	for char in inString:gmatch('.') do
		if char == '0' then
			table.insert(processedList, 0)
		else
			table.insert(processedList, 1)
		end
	end

	return processedList
end


function GridHash:new(matrix)
	self.rawMatrix = matrix

	self.twoDArray = {}

	for i, line in ipairs(self.rawMatrix) do
		table.insert(self.twoDArray, stringToList(line))
	end

	self.width = sideLength * #self.twoDArray[1]
	self.height = sideLength * #self.twoDArray
end

function GridHash:createBlock(entityList, gridPosX, gridPosY)
	if self.twoDArray[gridPosY][gridPosX] == 0 then return end

	blockXCoord = (gridPosX - 1) * 50
	blockYCoord = (gridPosY - 1) * 50

	newBlock = Block(blockXCoord, blockYCoord, j, i)
	print('x: ', newBlock.x, 'y: ', newBlock.y, 'gridPosX: ', gridPosX, 'gridPosY: ', gridPosY)

	table.insert(entityList, newBlock)
end


function GridHash:createBlocks(entityList)
	for i, row in ipairs(self.twoDArray) do
		for j, column in ipairs(row) do
			self:createBlock(entityList, j, i)
		end
	end

end

function GridHash:draw()
	love.graphics.setColor({1, 0, 0})
	love.graphics.rectangle('line', 0, 0, self.width, self.height)
	love.graphics.setColor({1, 1, 1})
end
