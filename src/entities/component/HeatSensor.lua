local HeatSensor = Class:extend()

HeatSensor.force = 1.2

function HeatSensor:heatSensorNew(force)
	self.heatSensorActive = false
	self.heatSensorTarget = {x = 0, y = 0}
	self.heatSensorForce = force or HeatSensor.force
end

function HeatSensor:heatSensorSetNearTarget()
	local tx, ty = self.tile.x, self.tile.y
	local v = self.world.map:getHeatValue(tx, ty)
	--print('actual value', self.tile.x, self.tile.y, v)
	if v then
		local ntx, nty = tx, ty
		for j = 1, #Map.around do
			local t = Map.around[j]
			local nv = self.world.map:getHeatValue(tx + t[1], ty + t[2])
			if nv and nv >= 0 and nv <= v then
				v = nv
				ntx = tx + t[1]
				nty = ty + t[2]
			end
		end
		--print('goal value', v)
		local nx, ny = self.world.map:getTileCoords(ntx + math.random(), nty + math.random())
		self.heatSensorTarget.x = nx
		self.heatSensorTarget.y = ny
		self.heatSensorActive = true
	end
end

function HeatSensor:heatSensorUpdate(dt)
	if self.heatSensorActive then
		self:heatSensorGoTarget()
	else
		self:heatSensorSetNearTarget()	
	end
	
	if self:distance(self.heatSensorTarget) <= 50 then
		self:heatSensorSetNearTarget()
	end
end

function HeatSensor:heatSensorGoTarget()
--	print('go target', self.heatSensorTarget.x, self.heatSensorTarget.y)
	local v = Vector(self.heatSensorTarget.x - self.x, self.heatSensorTarget.y - self.y)
	local velocity = v:len()
	v:normalize_inplace()
	v = v * velocity * self.heatSensorForce * G.world.speed
	
	self.velocity.x = v.x
	self.velocity.y = v.y
end

return HeatSensor

