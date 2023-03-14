require "entity"
Bullet = Entity:extend()

function Bullet:new(x, y, speed, angleDegUnderH, bulletType, shooter)
	self.x0 = x
	self.y0 = y

	self.speed = speed
	self.image = love.graphics.newImage("bullet.png")

	width = self.image:getWidth()
	height = self.image:getHeight()

	Bullet.super.new(self, x, y, height, width)

	self.angleRad = math.pi * (angleDegUnderH + 360) / 180 

	self.sin = math.sin(self.angleRad)
	self.cos = math.cos(self.angleRad)

	self.dead = false
	self.bulletType = bulletType

	if self.bulletType == 'normal' then
		self.damage = 20
	elseif self.bulletType == 'piercing' then
		self.damage = 5
	end

	self.shooter = shooter
end

function Bullet:checkCollision(object)
    return  self.x + self.width > object.x
        and self.x < object.x + object.width
        and self.y + self.height > object.y
		and self.y < object.y + object.height
end

function Bullet:update(dt)
	self.x = self.x + self.speed * self.cos * dt
	self.y = self.y + self.speed * self.sin * dt

	self.lastX = self.x
	self.lastY = self.y

	-- if self:checkCollision(player) and self.shooter == "enemy" then
	-- 	player.health = player.health - self.damage

	-- 	if self.bulletType == "normal" then
	-- 		self.dead = true
	-- 	end
	-- end

	-- if self:checkCollision(enemy) and self.shooter == "player" then
	-- 	enemy.health = enemy.health - self.damage

	-- 	if self.bulletType == "normal" then
	-- 		self.dead = true
	-- 	end
	-- end

	if self.y > love.graphics.getHeight()
		or self.x < 0
		or self.x > love.graphics.getWidth() then

		self.dead = true
	end
end

function Bullet:draw()
	love.graphics.draw(self.image, self.x, self.y)
end
