Entity = Object:extend()

function Entity:new(x,
	y,
	height,
	width)

	self.x = x
	self.y = y
	self.lastX = x 
	self.lastY = y
	
	self.height = height
	self.width = width
end

function Entity:update(dt)
end
