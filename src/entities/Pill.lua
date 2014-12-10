local Pill = Entity:extend()

Pill.lifeDuration = 10

function Pill:new(x, y)
	Pill.super.new(self, x, y)
	self.pixel = love.graphics.newImage('assets/pill.png')
	self.lifeTime = Pill.lifeDuration
end

function Pill:update(dt)
	Pill.super.update(self, dt)
	self.lifeTime = self.lifeTime - dt
	if self.lifeTime <= 0 then
		self.active = false
	end
	if self:collide(G.player) then
		self:hit()
		G.player.life = G.player.life + 2
	end
end

return Pill