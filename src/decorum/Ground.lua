local Ground = Entity:extend('Ground')

function Ground:new()
	Ground.super.new(self, 0, 0)

	self.canvas = love.graphics.newCanvas(love.window.getWidth(), love.window.getHeight())
	love.graphics.setCanvas(self.canvas)

	local greyscale = love.graphics.newgradient {
		direction = 'horizontal',
		{20, 20, 20},
		{50, 50, 50},
		{70, 70, 70}
	}
	love.graphics.drawinrect(greyscale, 0, 0, love.window.getWidth(), love.window.getHeight())

	
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(50, 50, 50)
	--love.graphics.rectangle('fill', 0, 0, love.window.getWidth(), love.window.getHeight())
	love.graphics.setColor(r, g, b, a)

	local target = love.graphics.newImage('assets/target.png')
	love.graphics.draw(target, love.window.halfWidth - target:getWidth() / 2, love.window.halfHeight - target:getHeight() / 2)
	
	love.graphics.setCanvas()

	self.shadow = love.graphics.newCanvas(love.window.getWidth(), love.window.getHeight())
end

function Ground:update()
	love.graphics.setCanvas(self.shadow)
	self.shadow:clear()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(0, 0, 0, 100)
	local e = nil
	for i = 1, #self.world.entities do
		e = self.world.entities[i]
		if e.hasShadow then
			love.graphics.ellipse('fill', e.ox, e.oy + 20 + e.z, 2 * e.hitbox.w / 3, e.hitbox.h / 2)--, phi, points)
		end
	end
	love.graphics.setColor(r, g, b, a)
	love.graphics.setCanvas()
end

function Ground:draw()
	love.graphics.draw(self.canvas, 0, 0)
	love.graphics.draw(self.shadow, 0, 0)
end

return Ground