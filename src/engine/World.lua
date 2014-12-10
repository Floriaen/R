local World = Class:extend()

World.enemyCount = 100
World.spawnEnemyDelay = 1
World.maxSpawnEnemies = 10
World.shakeIntensity = 60
World.maxBigCount = 4

function World:new()
	self.entities = {}
	self.map = Map(love.window.getWidth(), love.window.getHeight())

	self.ground = Ground()
	self:addEntity(self.ground)

	self.enemyCount = 0
	self.enemyKilled = 0
	self.bigCount = 0
	self.spawnEnemyDelay = 0
	self.shaketimer = 0

	G.player = Player(love.window.halfWidth, love.window.halfHeight)
	self:addEntity(G.player)
	self.map:setTarget(G.player)
end

function World:addEntity(e)
	e:added(self)
	table.insert(self.entities, e)
	if e.type == 'ENEMY' then
		self.enemyCount = self.enemyCount + 1
	end
	return e
end

function World:update(dt)
	self.map:cleanEntities()

	self.shaketimer = self.shaketimer - dt
	if self.shaketimer < 0 then self.shaketimer = 0 end

	-- new enemies:
	self.spawnEnemyDelay = self.spawnEnemyDelay - dt
	if self.spawnEnemyDelay <= 0 then
		self.spawnEnemyDelay = 0
		local newEnemies = World.enemyCount - self.enemyCount
		if newEnemies > 0 then

			-- right or left
			local spawnX = 20
			if math.random() > 0.5 then
				spawnX = love.graphics.getWidth() - 100
			end

			if newEnemies > World.maxSpawnEnemies then
				newEnemies = World.maxSpawnEnemies
			end
			self.spawnEnemyDelay = World.spawnEnemyDelay
			for i = 1, newEnemies do
				if math.random() > 0.9 then
					G.world:addEntity(Rocket(spawnX + math.random() * 50 , 20 + math.random() * 50))
				else
					if self.bigCount > World.maxBigCount or math.random() > 0.2 then
						G.world:addEntity(Ship(spawnX + math.random() * 50 , 20 + math.random() * 50))
					else
						G.world:addEntity(Big(spawnX + math.random() * 50 , 20 + math.random() * 50))
						self.bigCount = self.bigCount + 1
					end
				end
			end
		end
	end
	

	local e = nil
	for i = 1, #self.entities do
		e = self.entities[i]
		e.onCamera = true
		if e.x < 0 or e.x > love.window.getWidth() or e.y < 0 or e.y > love.window.getHeight() then
			e.onCamera = false
		end

		e:update(dt)

		if e.active and e.type == 'ENEMY' and e:collide(G.player) then
			e:hit()
			G.player:hit()
			self.shaketimer = 0.2
		end

		if self.map.entities[e.tile.y] then
			if self.map.entities[e.tile.y][e.tile.x] then
				self.map.entities[e.tile.y][e.tile.x] = self.map.entities[e.tile.y][e.tile.x] + e.weight
				if e.weight > 1 then
					for k = 1, #Map.around do
						if self.map.entities[e.tile.y + Map.around[k][2]] then
							if self.map.entities[e.tile.y + Map.around[k][2]][e.tile.x + Map.around[k][1]] then
								local v = self.map.entities[e.tile.y + Map.around[k][2]][e.tile.x + Map.around[k][1]]
								self.map.entities[e.tile.y + Map.around[k][2]][e.tile.x + Map.around[k][1]] = v + (e.weight - 1)
							end
						end
					end
				end
			end
		end

		--if e:collide()
	end

	-- clean entities:
	for i = 1, #self.entities do
		e = self.entities[i]
		if e then
			if e.onCamera == false or e.active == false then
				table.remove(self.entities, i)
				if e.type == 'ENEMY' then
					self.enemyKilled = self.enemyKilled + 1
					self.enemyCount = self.enemyCount - 1
					if e:is(Big) then
						self.bigCount = self.bigCount - 1
					end
				end
			end
		end
	end

	self.map:update(dt)
end

function World:draw()

	if self.shaketimer > 0 then
		local shake = World.shakeIntensity * self.shaketimer
		love.graphics.translate(math.random(-shake, shake), math.random(-shake, shake))
	end

	local e = nil
	for i = 1, #self.entities do
		e = self.entities[i]
		if e.onCamera then
			e:draw()
		end
	end
end

function World:onPreCollide()
	local e1 = shapeA.userData
		local e2 = shapeB.userData
		if e1 and e2 and e1.active and e2.active then
			e1:collide(e2)
			e2:collide(e1)
		end
end

return World