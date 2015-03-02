enemies = {}

function enemies.load()	
	spawnpic = {}
	spawnpic.pic = love.graphics.newImage("Art/Enemy Pics/portal.png")
	spawnpic.width,spawnpic.height = 100,100
	spawnpic.picwidth,spawnpic.picheight = spawnpic.pic:getWidth(), spawnpic.pic:getHeight()
	
	--pawn.spawn = {enemySpawnPoint(2600,0,"pawn",0,0,nil,10,45)}--{enemySpawnPoint(1792,-64,"pawn",0.5,50, nil,10, 45), enemySpawnPoint(1000,-64,"pawn",0.1,25),enemySpawnPoint(3500,-100,"pawn",4,nil

	--pawn.spawn = {enemySpawnPoint(2600,0,"pawn",0.3,100),enemySpawnPoint(3075,380,'foe',1,19,nil,10),enemySpawnPoint(-1650,120,"pawn",1,20)}

	enemy = {}
	love.filesystem.load('game/Enemies/pawn.lua')()
	love.filesystem.load('game/Enemies/soldier.lua')()
	love.filesystem.load('game/Enemies/wizard.lua')()
	love.filesystem.load('game/Enemies/monkey.lua')()
	
	enemy.pawn.load()
	enemy.soldier.load()
	enemy.wizard.load()
	enemy.monkey.load()

	enemydrop.load()
end

function enemies.draw()

	for i,v in pairs(currentLevel.enemySpawnPoints) do
		v:draw()
		--v:drawEnemies()
	end

	for i,v in pairs(currentLevel.allpawns) do
		v:draw()
	end
	
	for i,v in pairs(currentLevel.allsoldiers) do
		--print(tostring(i) .. "  " .. tostring(v))
		v:draw()
	end
	
	for i,v in pairs(currentLevel.allwizards) do
		v:draw()
	end
	
	for i,v in pairs(currentLevel.allmonkeys) do
		v:draw()
	end

	for i,v in pairs(enemydroplist) do
		v:draw()
	end
	--[[
		love.graphics.setLineWidth(3)
		love.graphics.setColor(0,0,0)
		
		for i,v in pairs(level.enemyspawn) do
			if collision.rectangles(v.x-spawnpic.width/2,v.y-spawnpic.height/2,spawnpic.width,spawnpic.height, getWorldScreenRect()) then
				love.graphics.draw(spawnpic.pic, v.x-spawnpic.width/2, v.y-spawnpic.height/2,0, spawnpic.width/spawnpic.picwidth,spawnpic.height/spawnpic.picheight)
			end
		end
		
		local enemyonscreen = false	
		for i,v in pairs(foe.foes) do
			if collision.rectangles(v.x-v.drawwidth/2, v.y-v.drawheight*0.95, v.drawwidth, v.drawheight, getWorldScreenRect()) then
				if v.killed.type then
					love.graphics.setColor(255,255,255,v.killed.countdown * 255)
					if v.xspeed > 0 then
						love.graphics.draw(foe.pic.right, v.x-v.drawwidth/2, v.y-v.drawheight*0.95,0,v.drawwidth/foe.picwidth, v.drawheight/foe.picheight)
					else
						love.graphics.draw(foe.pic.left, v.x-v.drawwidth/2, v.y-v.drawheight*0.95,0,v.drawwidth/foe.picwidth, v.drawheight/foe.picheight)
					end
				elseif v.xspeed > 0 then
					love.graphics.draw(foe.pic.right, v.x-v.drawwidth/2, v.y-v.drawheight*0.95,0,v.drawwidth/foe.picwidth, v.drawheight/foe.picheight)
				else
					love.graphics.draw(foe.pic.left, v.x-v.drawwidth/2, v.y-v.drawheight*0.95,0,v.drawwidth/foe.picwidth, v.drawheight/foe.picheight)
				end
				
				enemyonscreen = true	
				love.graphics.setLineWidth(1)
				--love.graphics.rectangle("line", v.x - v.actualwidth/2, v.y - v.actualheight * 0.95, v.actualwidth, v.actualheight) 
				love.graphics.setColor(255,255,255)
				--love.graphics.circle("fill", v.x, v.y, 2)
				--Collision Box
				
			end
		end
		
		for i,v in pairs(pawn.pawns) do
			if collision.rectangles(v.x-v.drawwidth/2, v.y-v.drawheight/2, v.drawwidth, v.drawheight, getWorldScreenRect()) then
				if v.killed.type == "squashed" then
					love.graphics.setColor(255,255,255,math.random(1,3)*80)
					love.graphics.draw(pawn.squashedpic[v.pic], v.x-v.drawwidth/2, v.y-v.drawheight/2,0,v.drawwidth/pawn.picwidth, v.drawheight/pawn.picheight)
				elseif v.killed.type == "arrow" then
					love.graphics.setColor(255,255,255,v.killed.countdown*255/3)
					love.graphics.draw(pawn.animation[v.pic][v.anim], v.x-v.drawwidth/2, v.y-v.drawheight/2,0,v.drawwidth/pawn.picwidth, v.drawheight/pawn.picheight)
				else
					love.graphics.draw(pawn.animation[v.pic][v.anim], v.x-v.drawwidth/2, v.y-v.drawheight/2,0,v.drawwidth/pawn.picwidth, v.drawheight/pawn.picheight)
				end
				enemyonscreen = true	
				--love.graphics.rectangle("line",v.x-v.actualwidth/2, v.y-v.actualheight/2,v.actualwidth, v.actualheight)
			end
		end
		
		if player.hp > 0 and table.length(pawn.pawns) + table.length(foe.foes) > 0 then
			if (music.fight.music:isPaused() or music.fight.music:isStopped()) then
				love.audio.pause()
				music.fight.music:rewind()
				music.fight.music:play()
			end
		elseif --not enemyonscreen player.hp > 0 then
			if (music.discovery.music:isPaused() or music.discovery.music:isStopped() ) then
				love.audio.pause()
				music.discovery.music:play()
			end
		end
	--]]
	
end

function enemies.update(dt)
	
	local n = 0
	enemy.pawn.updatePawnCollisions()
	for i,v in pairs(currentLevel.enemySpawnPoints) do
		v:update(dt)
		n = n + 1
		if v.destroy then
			currentLevel.enemySpawnPoints[i] = nil
		end
		--v:updateEnemies(dt)
	end

	for i,v in pairs(currentLevel.allpawns) do
		n = n + 1
		v:update(dt)
		if v.destroy then
			currentLevel.allpawns[i] = nil
		end
	end
	
	for i,v in pairs(currentLevel.allsoldiers) do
		v:update(dt)
		if v.destroy then
			currentLevel.allsoldiers[i] = nil
		end
		n = n + 1
	end
	
	for i,v in pairs(currentLevel.allwizards) do
		v:update(dt)
		n = n + 1
		if v.destroy then
			currentLevel.allwizards[i] = nil
		end
	end
	
	for i,v in pairs(currentLevel.allmonkeys) do
		v:update(dt)
		if v.destroy then
			currentLevel.allmonkeys[i] = nil
		end
	end

	for i,v in pairs(enemydroplist) do
		v:update(dt)
	end
	
	if player.hp > 0 and n > 2 then
		if (music.fight.music:isPaused() or music.fight.music:isStopped()) then
			love.audio.stop()
			music.fight.music:rewind()
			music.fight.music:play()
		end
	elseif n <2 and player.hp > 0 then
		if (music.discovery.music:isPaused() or music.discovery.music:isStopped()) then
			love.audio.stop()
			music.discovery.music:rewind()
			music.discovery.music:play()
		end
	end
	--print("N: " .. n)
	
--[[
updateEnemySpawnPoints(dt)
	for i,v in pairs(pawn.pawns) do
		if v.killed.type ~= "squashed" then
			pawn.formerpawns[i] = {}
			pawn.formerpawns[i].x = v.x
			pawn.formerpawns[i].y = v.y
			
			if pawn.jump then
				local rand = math.random()
				if rand < 0.007 then
					v.yspeed = -50
				end
			end
			v = updateObject(v, dt)	
			v.xspeed = v.speed
			if v.y + v.actualheight/2 > levely then
				v.y = levely - v.actualheight/2
				if v.yspeed > 0 then
					v.yspeed = 0
				end
			end
			if v.health <= 0 and v.killed.type ~= "arrow" then
				v.killed.type = "arrow"
				v.killed.countdown = 2
				v.yspeed = -50
				v.ygrav = 10
				v.speed = 0
			end
		end
		if v.killed.countdown then
			v.killed.countdown = v.killed.countdown - dt
			if v.killed.countdown <= 0 then
				pawn.pawns[i] = nil
			end
		end
		v.animdelay = v.animdelay + dt
		if v.animdelay > pawn.animation[v.pic].delay then
			v.animdelay = 0
			v.anim = v.anim + 1
			if v.anim > 6 then
				v.anim = 1
			end
		end
	end
	for i,v in pairs(pawn.pawns) do				
		for a,b in pairs(pawn.pawns) do
			if not v.killed.type and not b.killed.type then
				if collision.rectangles(b.x - b.actualwidth/2, b.y-b.actualheight/2, b.actualwidth,b.actualheight, v.x - v.actualwidth/2, v.y - v.actualheight/2 , v.actualwidth , v.actualheight) then
					local direction = collision.direction.rectangles(pawn.formerpawns[i].x - v.actualwidth/2,pawn.formerpawns[i].y-v.actualheight/2, v.actualwidth, v.actualheight, pawn.formerpawns[a].x - b.actualwidth/2,pawn.formerpawns[a].y-b.actualheight/2, b.actualwidth, b.actualheight)
					if direction == "right" then
						v.x = b.x + b.actualwidth/2 + v.actualwidth/2
						if v.speed * b.speed > 0 then
							v.speed = math.abs(v.speed)
						else
							v.speed = math.abs(v.speed)
							b.speed = -math.abs(b.speed)
						end
					elseif direction == "left" then
						v.x = b.x - b.actualwidth/2 - v.actualwidth/2
						if v.speed * b.speed > 0 then
							v.speed = -math.abs(v.speed)
						else
							v.speed = -math.abs(v.speed)
							b.speed = math.abs(b.speed)
						end
					elseif direction=="top"  then
						v.y = b.y - b.actualheight/2 - v.actualheight/2
						v.yspeed = 0
					elseif direction == "bottom"  then
						v.direction = "bottom" 
						b.yspeed = 0
						b.y = v.y - v.actualheight/2 - b.actualheight/2
					end
				end
			end --if not nil
		end  -- for loop
		
		if not v.killed.type then
			for j,rect in pairs(level.blocks) do
				if collision.rectangles(rect.x, rect.y, rect.width,rect.height, v.x - v.actualwidth/2, v.y - v.actualheight/2 , v.actualwidth , v.actualheight) then
					if rect.type == "grassydirt" or rect.type == "dirt" then
						local direction = collision.direction.rectangles(pawn.formerpawns[i].x - v.actualwidth/2,pawn.formerpawns[i].y-v.actualheight/2, v.actualwidth, v.actualheight, rect.x, rect.y, rect.width,rect.height)
						if direction == "right" then
							v.x = rect.x + rect.width + v.actualwidth/2
							v.speed = math.abs(v.speed)
						elseif direction == "left" then
							v.x = rect.x - v.actualwidth/2 
							v.speed = -math.abs(v.speed)
						elseif direction=="top"  then
							v.y = rect.y - v.actualheight/2
							v.yspeed = 0
						elseif direction == "bottom"  then
							v.yspeed = 0
							v.y = rect.y + rect.height + v.actualheight/2
						end
					elseif rect.type == 'water' then
						v.xspeed = v.speed * 0.55
						if v.yspeed > 0 then
							v.yspeed = v.yspeed - v.yspeed * dt * 10
						else
							v.yspeed = v.yspeed *0.99
						end
					end
				else
					v.direction = ""
				end
			end--for level loop
			
		end
		
	end
	
	
	foe.formerfoes = {}
	for i,v in pairs(foe.foes) do
		foe.formerfoes[i] = {}
		foe.formerfoes[i].x = v.x
		foe.formerfoes[i].y = v.y
		
		if v.killed.countdown then
			v.xspeed = 0
		end
		v = updateObject(v, dt)	
		v.xspeed = v.speed
		if v.y > levely  then
			--v.y = levely
			--v.yspeed = 0
		end
		
		if v.killed.countdown then
			v.killed.countdown = v.killed.countdown - dt
			if v.killed.countdown <= 0 then
				foe.foes[i] = nil
			end
		end
	end
	
	for i,v in pairs(foe.foes) do
		for j,rect in pairs(level.blocks) do
			if not v.killed.countdown then
				if collision.rectangles(rect.x, rect.y, rect.width,rect.height, v.x - v.actualwidth/2, v.y - v.actualheight * 0.95, v.actualwidth , v.actualheight) then
					if rect.type == "grassydirt" or rect.type == "dirt" then
						local direction = collision.direction.rectangles(foe.formerfoes[i].x - v.actualwidth/2,foe.formerfoes[i].y-v.actualheight*0.95, v.actualwidth, v.actualheight, rect.x, rect.y, rect.width,rect.height)
						if direction == "right" then
							v.x = rect.x + rect.width + v.actualwidth/2
							v.speed = math.abs(v.speed)
						elseif direction == "left" then
							v.x = rect.x - v.actualwidth/2 
							v.speed = -math.abs(v.speed)
						elseif direction=="top"  then
							v.y = rect.y - v.actualheight*0.05 - 0.1
							v.yspeed = 0
						elseif direction == "bottom"  then
							v.yspeed = 0
							v.y = rect.y + rect.height + v.actualheight * 0.95
						end
					elseif rect.type == 'water' then
						v.xspeed = v.speed * 0.55
						if v.yspeed > 0 then
							v.yspeed = v.yspeed - v.yspeed * dt * 10
						else
							v.yspeed = v.yspeed *0.99
						end
					end
				else
					v.direction = ""
				end
			end
		end--for level loop	
	end
	
	--]]

end

--[[
spawn = {}
function spawn.pawn(x,y, speed,size)
	local enemy = createObject({x=x,y=y, mass = 50, ygrav= 5, yspeed = math.random(0,6)*-15})
	enemy.direction = ""
	
	if not speed then
		speed = math.random(1,4)*10
		if math.random(0,1) == 0 then
			speed = -speed
		end
	end
	
	enemy.speed = speed

	local rand = 1--math.random(1,3)
	if rand == 1 then
		enemy.pic = "scared"
	elseif rand == 2 then
		enemy.pic = "original"
	else
		enemy.pic = "angry"
	end
	enemy.anim = 1
	enemy.animdelay = 0
	enemy.killed = {}
	enemy.killed.type = false
	enemy.killed.countdown = false
	
	enemy.drawwidth = size or math.random(1,3)/2 * pawn.drawwidth
	enemy.drawheight = enemy.drawwidth * pawn.drawproportion
	
	enemy.xp = math.ceil(enemy.drawwidth/90)

	enemy.actualwidth = 0.85 * enemy.drawwidth
	enemy.actualheight = 0.7 * enemy.drawheight
	
	enemy.health = math.round(3*(enemy.drawwidth/pawn.drawwidth)/1.5,1)
	
	return enemy
	--pawn.pawns[tostring(pawn.count)] = enemy
	--pawn.count = pawn.count + 1
end



function spawn.foe(x,y,speed)
	local enemy = createObject({x=x,y=y, mass = 50, ygrav= 5, yspeed = 0})
	enemy.direction = ""
	
	enemy.speed = speed or foe.speed

	enemy.killed = {}
	enemy.killed.type = false
	enemy.killed.countdown = false
	
	enemy.drawwidth = foe.drawwidth
	enemy.drawheight = foe.drawwidth * foe.drawproportion
	
	enemy.actualwidth = foe.actualwidth
	enemy.actualheight = foe.actualheight
	
	enemy.health = 1
	return enemy
	--foe.foes[tostring(foe.count)] = enemy
	--foe.count = foe.count + 1
end

--]]




-------------------------------------------------------------------------------------------
enemySpawnPoint = {}
enemySpawnPoint.__index = enemySpawnPoint
function enemySpawnPoint.make(atts)
	local t = {}
	setmetatable(t,enemySpawnPoint)
	t.metatable = 'enemySpawnPoint'
	
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
	if self.totalenemies and self.totalenemies <= 0 then
		if #self.enemies == 0 or true then
			self.destroy = true
		else
			self.display = false
		end
		return
	end

	self.x = self.x + self.xspeed*dt
	self.y = self.y + self.yspeed*dt
	
	self.counter = self.counter + dt
	if self.counter >= self.spawnrate then
		if not (self.maxenemies and #self.enemies > self.maxenemies) then
			self.counter = 0
			self.enemyatts.x,self.enemyatts.y = self.x,self.y
			table.insert(self.enemies,enemy[self.type].make(self.enemyatts))
			self.totalenemies = self.totalenemies and self.totalenemies - 1
			if self.spawnrate == 0 then
				self.x,self.y = self.x+self.xstep, self.y+self.ystep
			end
		end
	end
end

function enemySpawnPoint:draw()
	if self.display then
		if collision.rectangles(self.x-self.width/2,self.y-self.height/2,self.width,self.height, getWorldScreenRect()) then
			love.graphics.setColor(255,255,255)
			love.graphics.draw(spawnpic.pic, self.x-self.width/2, self.y-self.height/2,0, self.width/spawnpic.picwidth,self.height/spawnpic.picheight)
		end
	end
end

function enemySpawnPoint:updateEnemies(dt)
	for i,v in pairs(self.enemies) do
		v:update(dt)
		if v.destroy then
			self.enemies[i] = nil
			currentLevel["all" .. self.type .. "s"][v.allindex] = nil
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
