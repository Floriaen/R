local LifeIndicator = require 'entities/component/LifeIndicator'
local Player = Entity:extend()
Player:implement(LifeIndicator)

Player.fireDelay = 0.2
Player.maxLife = 40

function Player:new(x, y)
	Player.super.new(self, x, y)
	self.speed = 10
	self.fireDelay = 0
	self.weight = 0
	self.life = Player.maxLife
	self:lifeIndicatorNew(self.life, 20)
	self.pixel = love.graphics.newImage("assets/player.png")
	self.zDistance = 0
end

function Player:update(dt)
	Player.super.update(self, dt)
	if self.life > 40 then
		self.life = Player.maxLife
	end
	self:lifeIndicatorUpdate(dt)

	if self.x < 0 then
		self.x = 0
	elseif self.x + self.hitbox.w > love.window.getWidth() then
		self.x = love.window.getWidth() - self.hitbox.w
	end

	if self.y < 0 then
		self.y = 0
	elseif self.y + self.hitbox.h > love.window.getHeight() then
		self.y = love.window.getHeight() - self.hitbox.h
	end

	--self.velocity.x = 0
	--self.velocity.y = 0

	local mx, my = love.mouse.getPosition()
	self.x = math.lerp(self.x, mx, dt * self.speed)
	self.y = math.lerp(self.y, my, dt * self.speed)

	self.fireDelay = self.fireDelay - dt 
	if self.fireDelay <= 0 then 
		self.fireDelay = 0
		--if love.keyboard.isDown(' ') then
		if love.mouse.isDown('l') then
			--self.life = self.life - 0.1
			self.fireDelay = Player.fireDelay

			local bullet = self.world:addEntity(Bullet(self.x, self.y))

			local v = Vector(love.window.halfWidth - self.ox, love.window.halfHeight - self.oy);
			v:normalize_inplace()
			bullet.velocity.x = v.x * 10 * G.world.speed
			bullet.velocity.y = v.y * 10 * G.world.speed
		end
	end

	
end

function Player:draw()
	Player.super.draw(self)
	self:lifeIndicatorDraw()
end

return Player