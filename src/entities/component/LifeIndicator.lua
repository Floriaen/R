local LifeIndicator = Class:extend()

function LifeIndicator:lifeIndicatorNew(life, radius)
	self.maxLife = life
	self.radius = radius
end

function LifeIndicator:lifeIndicatorUpdate(dt)
	--self.angle = 0
	local angle = self.life / self.maxLife * math.pi * 2
	self.toAngle = self.angle + angle
end

function LifeIndicator:lifeIndicatorDraw(dt)
	--self.angle = 0
	if self.life >= self.maxLife - 1 then
		love.graphics.setColor(255, 255, 255, 20)
		love.graphics.circle('fill', self.ox, self.oy, self.radius)

		love.graphics.setColor(255, 255, 255, 120)
		love.graphics.setLineWidth(1)
		love.graphics.circle('line', self.ox, self.oy, self.radius)
	else 
		love.graphics.setColor(255, 255, 255, 20)
		love.graphics.arc('fill', self.ox, self.oy, self.radius, self.angle, self.toAngle)

		love.graphics.setColor(255, 255, 255, 120)
		love.graphics.setLineWidth(1)
		love.graphics.arc('line', self.ox, self.oy, self.radius, self.angle, self.toAngle)
	end
end

return LifeIndicator