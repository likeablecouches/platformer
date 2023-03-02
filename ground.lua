require "entity"
Ground = Entity:extend()

function Ground:new()
	Ground.super.new(self,
		-10^10,
		groundLevel,
		0,
		10^20)
end

function Ground:update(dt)
end

function Ground:draw()
	love.graphics.line(self.x, self.y, 10^10, self.y)
end
