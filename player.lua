require "entity"
Player = Entity:extend()

function Player:new(
	x0,
	y0,
	imagePath,
	maxSpeed,
	acceleration,
	jumpSpeed)

	self.image = love.graphics.newImage(imagePath)

	Player.super.new(self,
		x0,
		y0,
		0.05 * self.image:getHeight(),
		0.05 * self.image:getWidth())

	self.speedX = 0
	self.speedY = 0

	self.maxSpeedX = maxSpeed
	self.maxFallSpeed = 1000
	self.currentNetYAcceleration = 0
	self.accelerationX = acceleration
	self.jumpSpeed = jumpSpeed
	self.jumpCounter = 0

	self.groundedOnObj = false
	self.currentScalingPassage = nil
	-- self.lastCollisionObject = nil

end

function Player:wasVerticallyAligned(obj)
	if self.lastY < obj.lastY + obj.height and self.lastY + self.height > obj.lastY then
    	return true
	end
end

function Player:wasHorizontallyAligned(obj)
    return self.lastX < obj.lastX + obj.width and self.lastX + self.width > obj.lastX
end

function Player:checkCollision(obj)
    return self.x + self.width > obj.x
    and self.x < obj.x + obj.width
    and self.y + self.height > obj.y
    and self.y < obj.y + obj.height
end

function Player:resolveCollision(obj)
	if not self:checkCollision(obj) then
	--	if self.lastCollisionObject == obj then
	--		self.lastCollisionObject = nil
	--	end

		if self.groundedOnObj == obj then
			self.groundedOnObj = nil
		end

		return
	end

	-- self.lastCollisionObject = obj

	if self:wasVerticallyAligned(obj) then
		self.speedX = 0

    	if self.x + self.width/2 < obj.x + obj.width/2  then
			-- player comes from left
			local pushback = self.x + self.width - obj.x
			self.x = self.x - pushback
		else
			-- player comes from right
			local pushback = obj.x + obj.width - self.x
			self.x = self.x + pushback
		end

	elseif self:wasHorizontallyAligned(obj) then
		
		self.speedY = 0

		if self.y + self.height/2 < obj.y + obj.height/2 then
			-- player comes from above
			local pushback = self.y + self.height - obj.y
			self.y = self.y - pushback

			self.groundedOnObj = obj
			self.jumpCounter = 0

		else
			-- player comes from below
			local pushback = obj.y + obj.height - self.y
			self.y = self.y + pushback

			-- self.currentNetYAcceleration = self.currentNetYAcceleration - 100
		end
	end

	if self.groundedOnObj then
		self.speedY = 0
	end
end

function Player:receiveKeypress(dt)
	-- this function only updates the player's speed based on keypress, and
	-- does nothing with the player's position

	if love.keyboard.isDown("d") then
		print('D')
		if self.speedX < self.maxSpeedX then
			self.speedX = self.speedX + self.accelerationX * dt
		end

	elseif love.keyboard.isDown("a") then
		print('A')
		if self.speedX > -self.maxSpeedX then
			self.speedX = self.speedX - self.accelerationX * dt
		end

	else
		if math.abs(self.speedX) > 0 then
			local deltaSpeedX = (self.speedX/math.abs(self.speedX)) * self.accelerationX * dt

			if deltaSpeedX > math.abs(self.speedX) then
				self.speedX = 0
			else
				self.speedX = self.speedX - deltaSpeedX
			end
		end
	end

end

function Player:updateFreefallSpeed(dt)
	if not self.groundedOnObj then
		self.currentNetYAcceleration = gravAcceleration

		if self.speedY < self.maxFallSpeed then
			self.speedY = self.speedY + self.currentNetYAcceleration * dt
		end
	end
end

function Player:update(dt)
	self:receiveKeypress(dt)

	self.x = self.x + self.speedX * dt
	self.y = self.y + self.speedY * dt

	for i, entity in ipairs(entities) do
		if entity == self then
			goto continue
		end

		self:resolveCollision(entity)
		::continue::
	end

	self:updateFreefallSpeed(dt)

  	self.lastX = self.x
	self.lastY = self.y
end

function Player:draw()
	love.graphics.draw(
		self.image,
		self.x,
		self.y,
		0,
		0.05,
		0.05)
end
