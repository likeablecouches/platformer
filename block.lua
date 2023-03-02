require "entity"
Block = Entity:extend()

function Block:new(x, y)
	Block.super.new(self,
		x,
		y,
		50,
		50)
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
