local Entity = Class:extend('Entity')

Entity.zDistance = 20

function Entity:new(x, y)
	self.x = x
	self.y = y

	self.ox = 0
	self.oy = 0

	self.tile = {}
	self.tile.x = 0
	self.tile.y = 0

	self.velocity = {}
	self.velocity.x = 0
	self.velocity.y = 0

	self.speed = 0

	self.angle = 0

	self.onCamera = true

	self.hitbox = {w = 10, h = 10}

	self.weight = 2

	self.type = 'ENTITY'

	self.active = true
	self.life = 1
	self.z = 0
	self.zIncrement = 1
	self.zDistance = Entity.zDistance

	self.pixel = nil
	self.hasShadow = true
end

function Entity:added(world)
	self.world = world
	self.tile.x, self.tile.y = self.world.map:getTile(self.x, self.y)
	self.ox = self.x + self.hitbox.w * 0.5
	self.oy = self.y + self.hitbox.h * 0.5
end

function Entity:hit()
	self.life = self.life - 1
	if self.life < 0 then
		self.active = false
		self:onRemoved()
	end
end

function Entity:onRemoved()
	self.world:addEntity(Explosion(self.x, self.y))
end

function Entity:update(dt)
	self.z = self.z + self.zIncrement * self.zDistance * dt
	if self.zIncrement == 1 and self.z > self.zDistance then
		self.zIncrement = -1
	elseif self.zIncrement == -1 and self.z < 0 then
		self.zIncrement = 1
	end

	self.x = self.x + self.velocity.x
	self.y = self.y + self.velocity.y
	self.tile.x, self.tile.y = self.world.map:getTile(self.x, self.y)
	self.ox = self.x + self.hitbox.w * 0.5
	self.oy = self.y + self.hitbox.h * 0.5
end

function Entity:draw()
	local r, g, b, a = love.graphics.getColor()
	if self.pixel then
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(self.pixel, self.x, self.y, self.angle)
	else
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle('fill', self.x, self.y, self.hitbox.w, self.hitbox.h)
	end
	love.graphics.setColor(r, g, b, a)
end

function Entity:distance(e)
	return math.sqrt((self.x - e.x) * (self.x - e.x) + (self.y - e.y) * (self.y - e.y))
end

function Entity:collide(e)
	local maxDist = self.hitbox.w + e.hitbox.w;
	local distSqr = (e.x-self.x)*(e.x-self.x) + (e.y-self.y)*(e.y-self.y);
	if distSqr <= maxDist*maxDist then
		return math.sqrt(distSqr) <= maxDist;
	end
	return false;
end

return Entity