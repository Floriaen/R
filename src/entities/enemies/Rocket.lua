local Rocket = Ship:extend()

function Rocket:new(x, y)
	Rocket.super.new(self, x, y)
	self:heatSensorNew(0.1)
	self.pixel = love.graphics.newImage("assets/rocket.png")
end

function Rocket:hit()
	Entity.hit(self)
end

return Rocket