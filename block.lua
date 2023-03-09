require "entity"
Block = Entity:extend()

sideLength = 50

function Block:new(x, y, row, column)
	Block.super.new(self,
		x,
		y,
		sideLength,
		sideLength)

	self.gridPosX = column
	self.gridPosY = row
end

function Block:update()
end

function Block:draw()
	love.graphics.rectangle(
		'fill',
		self.x,
		self.y,
		self.width,
		self.height)
end
