G = {}
Class = require('lib/classic')

-- Collider = require 'lib/hardoncollider'
-- Shapes = require "lib/hardoncollider.shapes"
-- Polygon = require 'lib/hardoncollider.polygon'

require('lib/graphics')
require('lib/math')

Vector = require('lib/hump/vector')

Animation = require('lib/spritesheet/Animation')
Spritesheet = require('lib/spritesheet/SpriteSheet')

Entity = require('entities/Entity')

Bullet = require('entities/Bullet')
Ball = require('entities/Ball')
Player = require('entities/Player')
Ship = require('entities/enemies/Ship')
Rocket = require('entities/enemies/Rocket')
Big = require('entities/enemies/Big')
Pill = require('entities/Pill')

Explosion = require('entities/Explosion')


Ground = require('decorum/Ground')
Map = require('engine/Map')
World = require('engine/World')
Home = require('engine/Home')

Monocle = require('lib/monocle')
Monocle.new(
	{
		isActive = true, 
		filesToWatch = {'main.lua'},
		debugToggle = '<',
		customColor = {255, 255, 255},
		customPrinter = true,
		printerPreffix = '[Monocle] '
	}
)

Monocle.watch('FPS:', function() 
	return love.timer.getFPS()
end)

Monocle.watch('Mem(kB):', function() 
	return math.floor(collectgarbage("count"))
end)

function onPreCollide(dt, shapeA, shapeB, dx, dy)
	G.world:onPreCollide(dt, shapeA, shapeB, dx, dy)
end

function onPostCollide(dt, shapeA, shapeB, dx, dy)
	G.world:onPostCollide(dt, shapeA, shapeB, dx, dy)
end

function love.load(arg)	
	love.graphics.setDefaultFilter("nearest", "nearest", 1)
	love.window.halfWidth = love.window.getWidth() * 0.5
	love.window.halfHeight = love.window.getHeight() * 0.5
	
	GAME_FONT = love.graphics.newFont('assets/font/editundo.ttf', 64)

	love.mouse.setVisible(false)

	G.world = Home()
	
	canvas = love.graphics.newCanvas()

	local str = love.filesystem.read('assets/shader/colorFilter.frag')
	colorFilter = love.graphics.newShader(str)
	colorFilter:send('amount', 0)
	time = 0
end

function love.update(dt)
	G.world:update(dt)
	Monocle.update()

	if G.world.enemyKilled then
		if love.mouse.isDown('l') then
			G.world.speed = 1.2
			time = time + dt
			if time > 0.8 then
				time = 0.8
			end
		else 
			G.world.speed = 0.4
			time = time - dt * 3
			if time < 0 then
				time = 0
			end
		end
		

		if not G.player.active then
			G.world = Home()
		end
	else
		time = 0
	end
	colorFilter:send('amount', time)
end
 
function love.draw()
	love.graphics.setCanvas(canvas)
	G.world:draw()
	love.graphics.setCanvas()
	love.graphics.setShader(colorFilter)
	love.graphics.draw(canvas)
	love.graphics.setShader()

	if G.world.enemyKilled then
		love.graphics.setFont(GAME_FONT)
		love.graphics.setColor(255, 255, 255)
		love.graphics.print(G.world.enemyKilled, 16, 8)
	end

	--Monocle.draw()
end

function love.textinput(value)
	
end

function love.keypressed(key)
	
end