enemies = {}

function enemies.load()
	spawnpic = {}
	spawnpic.pic = love.graphics.newImage("Enemy Pics/portal.png")
	spawnpic.width,spawnpic.height = 100,100
	spawnpic.picwidth,spawnpic.picheight = spawnpic.pic:getWidth(), spawnpic.pic:getHeight()
	
	--pawn.spawn = {enemySpawnPoint(2600,0,"pawn",0,0,nil,10,45)}--{enemySpawnPoint(1792,-64,"pawn",0.5,50, nil,10, 45), enemySpawnPoint(1000,-64,"pawn",0.1,25),enemySpawnPoint(3500,-100,"pawn",4,nil

	--pawn.spawn = {enemySpawnPoint(2600,0,"pawn",0.3,100),enemySpawnPoint(3075,380,'foe',1,19,nil,10),enemySpawnPoint(-1650,120,"pawn",1,20)}

	enemy = {}
	local stuff = love.filesystem.getDirectoryItems('lib/Enemies')
	for i,v in pairs(stuff) do
		--love.filesystem.load('lib/Enemies/' .. v)()
	end
	
	love.filesystem.load('lib/Enemies/pawn.lua')()
	love.filesystem.load('lib/Enemies/soldier.lua')()
	
	enemy.pawn.load()
	enemy.soldier.load()

	enemydrop.load()
end

function enemies.draw()

	
	for i,v in pairs(level[editor.level].enemySpawnPoints) do
		v:draw()
		--v:drawEnemies()
	end

	for i,v in pairs(level[editor.level].allpawns) do
		v:draw()
		if v.destroy then
			level[editor.level].allpawns[i] = nil
		end
	end

	for i,v in pairs(enemydroplist) do
		v:draw()
	end
end

function enemies.update(dt)

	enemy.pawn.updatePawnCollisions()
	for i,v in pairs(level[editor.level].enemySpawnPoints) do
		v:update(dt)
		--v:updateEnemies(dt)
	end

	for i,v in pairs(level[editor.level].allpawns) do
		v:update(dt)
	end

	for i,v in pairs(enemydroplist) do
		v:update(dt)
	end

	
end


-------------------------------------------------------------------------------------------
enemySpawnPoint = {}
enemySpawnPoint.__index = enemySpawnPoint
function enemySpawnPoint.make(atts)
	local t = {}
	setmetatable(t,enemySpawnPoint)

	t.x = atts.x
	t.y = atts.y

	t.type = atts.type

	t.spawnrate = atts.spawnrate or 0
	t.xstep = atts.xstep or 0
	t.ystep = atts.ystep or 0
	if t.spawnrate ~= 0 then
		t.xspeed = t.xstep/t.spawnrate
		t.yspeed = t.ystep/t.spawnrate
	else
		t.xspeed,t.yspeed = 0,0
	end
	
	t.maxenemies = atts.maxenemies or false
	t.totalenemies = atts.totalenemies or false

	t.counter = atts.counter or 0

	t.display = atts.display or false

	t.enemyatts = atts.enemyatts or {}
	
	t.enemyatts.x = t.enemyatts.x or t.x
	t.enemyatts.y = t.enemyatts.y or t.y

	t.enemies = {}

	t.width = atts.width or spawnpic.width
	t.height = atts.height or spawnpic.height

	return t
end

function enemySpawnPoint:update(dt)
	if self.totalenemies <= 0 then
		if #self.enemies == 0 then
			self.destroy = true
		else
			self.display = false
		end
		return
	end

	self.counter = self.counter + dt
	if self.counter >= self.spawnrate then
		if not (self.maxenemies and #self.enemies > self.maxenemies) then
			self.counter = 0
			table.insert(self.enemies,enemy[self.type].make(self.enemyatts))
			self.totalenemies = self.totalenemies - 1
		end
	end
end

function enemySpawnPoint:draw()
	if self.display then
		if collision.rectangles(self.x-self.width/2,self.y-self.height/2,self.width,self.height, getWorldScreenRect()) then
			love.graphics.setColor(255,255,255)
			love.graphics.draw(spawnpic.pic, self.x-self.width/2, self.y-self.height/2,0, self.width/spawnpic.picwidth,self.height/spawnpic.picheight)
			local tb = _G[self.type .. 'pics']
			if tb then
				love.graphics.setColor(255,255,100)
				love.graphics.draw(tb.pic,self.x-self.width/2,self.y-self.height/2,0, self.width/tb.width,self.height/tb.height)
			end
		end
	else
		if collision.rectangles(self.x-self.width/2,self.y-self.height/2,self.width,self.height, getWorldScreenRect()) then
			love.graphics.setColor(255,255,255,50)
			love.graphics.draw(spawnpic.pic, self.x-self.width/2, self.y-self.height/2,0, self.width/spawnpic.picwidth,self.height/spawnpic.picheight)
		end
	end
end

function enemySpawnPoint:getLeft()
	return self.x-self.width/2
end

function enemySpawnPoint:getTop()
	return self.y-self.height/2
end

function enemySpawnPoint:updateEnemies(dt)
	for i,v in pairs(self.enemies) do
		v:update(dt)
		if v.destroy then
			self.enemies[i] = nil
			level["all" .. self.type .. "s"][v.allindex] = nil
		end

	end

end

function enemySpawnPoint:drawEnemies(dt)
	for i,v in pairs(self.enemies) do
		v:draw(dt)
	end
end

--[[
function updateEnemySpawnPoints(dt)
	for i,v in pairs(level.enemyspawns) do
		if v.destroy then
			table.remove(level.enemyspawns, i)
		end
		v.counter = v.counter + dt
		if v.counter >= v.spawnrate and not v.destroy then
			v.counter = 0
			table.insert(v.enemies,spawn[v.type](v.x, v.y,v.speed,v.size))
			if v.totalenemies then
				v.totalenemies = v.totalenemies - 1
				if v.totalenemies <= 0 then
					v.destroy = true
				end
			end
		end
	end
end

--]]
