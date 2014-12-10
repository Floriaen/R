local Animation = Class:extend()

function Animation:new(spritesheet, name, onAnimationComplete)
	self.parent = spritesheet
	self.name = name
	self.frames = {}
	self.currentFrame = 0
	self.delay = 0.1
	self.playing = true
	self.elapsed = 0
	self.onAnimationComplete = onAnimationComplete
	self.loop = true
end

function Animation:draw(...)
	local quad=self.frames[self.currentFrame]
	if quad then
		love.graphics.draw(self.parent.img, quad, ...)
	end
end

function Animation:update(dt)
	if #self.frames==0 or not self.playing then return end
	self.elapsed=self.elapsed+dt
	if self.elapsed>=self.delay then
		self.elapsed=self.elapsed-self.delay
		self.currentFrame=self.currentFrame+1
		if self.currentFrame>#self.frames then
			
			if self.onAnimationComplete then
				self.onAnimationComplete(self.name)
			end

			if self.loop then
				self.currentFrame=1
			else
				self.playing=false
			end
		end
	end
end

function Animation:addFrame(col, row)
	local parent=self.parent
	local w,h=parent.w, parent.h
	local quad=love.graphics.newQuad((col-1)*w, (row-1)*h, w, h, parent.imgw, parent.imgh)
	self.frames[#self.frames+1]=quad
	return self
end

function Animation:addFrames(frames)
	for i = 1, #frames do
		self:addFrame(frames[i][1], frames[i][2])
	end
end

function Animation:play()
	self.playing=true
end

function Animation:stop()
	self.playing=false
	self.currentFrame=1
	self.elapsed=0
end

function Animation:pause()
	self.playing=false
end

function Animation:setDelay(s)
	self.delay=s
	return self
end

function Animation:getDelay()
	return self.delay
end

function Animation:isPaused()
	return self.playing==false
end

return Animation