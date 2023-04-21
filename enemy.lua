Enemy = Object:extend()

function Enemy:new(x, y, speed, bulletSpread)
	self.image = love.graphics.newImage("flowey.png")
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.x = x
	self.y = y
	self.mouthX = self.x + self.width / 2
	self.mouthY = self.y + self.height / 2 - 25

	self.speed = speed

	self.fWait = 1
	self.bulletsPerSecond = 3
	self.bulletSpeed = 2000
	-- bulletSpread exptected as a magnitude of radians per each side
	self.bulletSpread = bulletSpread

	self.health = 2000
end

function Enemy:update(dt)
	-- if self.x < 0 or self.x + self.width > curWindowWidth then
	-- 	self.speed = -self.speed
	-- end

	-- self.x = self.x + self.speed * dt
	-- self.mouthX = self.mouthX + self.speed * dt

	fireAngleRad = math.atan2(self.mouthY - player.y, player.x - self.mouthX)
	fireAngleDeg = fireAngleRad * 180 / math.pi
	fireAngleDegUnderH = -(fireAngleDeg - 360)

	if self.fWait < 0 then
		self.fWait = 1
		return table.insert(entities,
			Bullet(self.mouthX,
			self.mouthY,
			self.bulletSpeed,
			love.math.random(fireAngleDegUnderH - self.bulletSpread,
				fireAngleDegUnderH + self.bulletSpread),
			'normal',
			'enemy'))
	else
		self.fWait = self.fWait - dt * self.bulletsPerSecond
	end
end

function Enemy:draw()
	love.graphics.draw(self.image, self.x, self.y)
end
