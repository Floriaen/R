local Ball = Bullet:extend()

function Ball:new(x, y)
	Ball.super.new(self, x, y)
	self.type = "ENEMY"
	self.pixel = love.graphics.newImage('assets/ball.png')
end

function Ball:update(dt)
	--Entity.super.update(self, dt)
	Bullet.super.update(self, dt)
end

return Ball