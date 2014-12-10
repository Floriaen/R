local Explosion = Entity:extend()

function Explosion:new(x, y)
	Explosion.super.new(self, x, y)
	self.sprite = Spritesheet('assets/explosion.png', 48, 48)
	self.anim = self.sprite:createAnimation('explode')
	self.anim:addFrames({{1, 1}, {2, 1}, {3, 1}})
	self.anim.delay = 0.1
	self.anim.loop = false
	self.hasShadow = false
end

function Explosion:update(dt)
	Explosion.super.update(self, dt)
	self.anim:update(dt)
	if self.playing == false then
		self.active = false
	end
end

function Explosion:draw()
	self.anim:draw(self.x, self.y, 0, 1, 1, 4, 4)
end

return Explosion