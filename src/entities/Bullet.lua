local Bullet = Entity:extend()

function Bullet:new(x, y)
	Bullet.super.new(self, x, y)
	self.hitbox.w = 6
	self.hitbox.h = 6
	self.weight = 10
	self.type = "BULLET"
	self.pixel = love.graphics.newImage("assets/bullet.png")

	self.life = 2
	self.weight = 6

	self.hasShadow = false
end

function Bullet:update(dt)
	Bullet.super.update(self, dt)
	
	if self.active then
		for i = 1, #self.world.entities do
			e = self.world.entities[i]
			if e and e.type == 'ENEMY' then
				if e:collide(self) then
					e:hit(self)
					self:hit(e)
				end
			end
		end
	end
end

return Bullet