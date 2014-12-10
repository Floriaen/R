local LifeIndicator = require 'entities/component/LifeIndicator'
local Big = Ship:extend()

Big:implement(LifeIndicator)

Big.fireDelay = 1
Big.distanceForFire = 400

function Big:new(x, y)
	Big.super.new(self, x, y)
	self:heatSensorNew(0.02)
	self.pixel = love.graphics.newImage("assets/big.png")

	self.life = 4
	self:lifeIndicatorNew(self.life, 20)
	self.weight = 6
end

function Big:update(dt)
	Big.super.update(self, dt)
	self.angle = self.angle + dt * 3
	self:lifeIndicatorUpdate(dt)
	if self:distance(G.player) < Big.distanceForFire then
		self.fireDelay = self.fireDelay - dt
		if self.fireDelay <= 0 then 
			self.fireDelay = Big.fireDelay

			local bullet = self.world:addEntity(Ball(self.x, self.y))

			local v = Vector(G.player.ox - self.ox, G.player.oy - self.oy);
			v:normalize_inplace()
			bullet.velocity.x = v.x * 10 * G.world.speed
			bullet.velocity.y = v.y * 10 * G.world.speed
		end
	end
end

function Big:hit()
	Entity.hit(self)
end

function Big:draw()
	print('draw')
	--Ship.super.draw(self)
	self:lifeIndicatorDraw()
end

return Big