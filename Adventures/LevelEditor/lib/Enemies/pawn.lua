
enemy.pawn = {}
enemy.pawn.__index = enemy.pawn

function enemy.pawn.load()
	pawnpics = {angry = love.graphics.newImage("Enemy Pics/Pawns/joel pawn.png"), scared = love.graphics.newImage("Enemy Pics/Pawns/scared pawn.png"), original = love.graphics.newImage("Enemy Pics/Pawns/original pawn.png")}
	pawnpics.pic = pawnpics. angry
	
	pawnpics.squashed = {angry = love.graphics.newImage("Enemy Pics/Pawns/squashed joel pawn.png"), scared = love.graphics.newImage("Enemy Pics/Pawns/squashed scared pawn.png"),original = love.graphics.newImage("Enemy Pics/Pawns/squashed original pawn.png")}
	
	pawnpics.animation = {}
	pawnpics.animation.original = {}
	pawnpics.animation.original.delay = 0.1
	for i=1,6 do
		table.insert(pawnpics.animation.original, love.graphics.newImage("Enemy Pics/Pawns/original animation/" .. i .. ".png"))
	end

	pawnpics.animation.angry = {}
	pawnpics.animation.angry.delay = 0.02
	for i=1,6 do
		table.insert(pawnpics.animation.angry, love.graphics.newImage("Enemy Pics/Pawns/joel animation/" .. i .. ".png"))
	end

	pawnpics.animation.scared = {}
	pawnpics.animation.scared.delay = 0.05
	for i=1,6 do
		table.insert(pawnpics.animation.scared, love.graphics.newImage("Enemy Pics/Pawns/scared animation/" .. i .. ".png"))
	end
	
	pawnpics.width = pawnpics.angry:getWidth()
	pawnpics.height = pawnpics.angry:getHeight()

end

function enemy.pawn.make(atts)
	local p = createObject{x = atts.x,y=atts.y,mass=atts.mass or 50, ygrav=atts.ygrav or 5, yspeed=atts.yspeed or 0, xspeed=atts.xspeed or math.random(1,4)*10*(math.random(0,1)*2-1)}

	setmetatable(p,enemy.pawn)

	p.former = {}
	p.former.x = p.x
	p.former.y = p.y
	p.direction = ""

	p.face = atts.face
	if not p.face then
		local rand = math.random(1,3)
		if rand == 1 then
			p.face = "scared"
		elseif rand == 2 then
			p.face = "original"
		else
			p.face = "angry"
		end
	end



	p.picanim = animation.make(1,7,pawnpics.animation[p.face].delay*6,true)

	p.killed = {}
	p.killed.type = false
	p.killed.countdown = false
	
	p.drawwidth = atts.drawwidth or math.random(1,3)*40
	p.drawheight = p.drawwidth * pawnpics.height/pawnpics.width
	
	p.xp = atts.xp or math.ceil(p.drawwidth/90)

	p.actualwidth = atts.actualwidth or 0.85 * p.drawwidth
	p.actualheight = atts.actualheight or 0.7 * p.drawheight
	
	p.health = atts.health or math.round((p.drawwidth/40),1)
	
	p.jump = atts.jump or false

	p.collidewith = {}
	
	level[player.location].numPawns = level[player.location].numPawns + 1
	p.allindex = level[player.location].numPawns

	level[player.location].allpawns[p.allindex] = p
	return p

end



function enemy.pawn:update(dt)
	if self.killed.type ~= "squashed" then
		self.former = {x=self.x,y=self.y}
		
		if self.jump then
			local rand = math.random()
			if rand < 0.007 then
				self.yspeed = -50
			end
		end
		updateObject(self, dt)	

		--[[
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
		--]]
	end
	if self.killed.countdown then
		self.killed.countdown = self.killed.countdown - dt
		if self.killed.countdown <= 0 then
			self.destroy = true
		end
	end
	--[[
	v.animdelay = v.animdelay + dt
	if v.animdelay > pawn.animation[v.pic].delay then
		v.animdelay = 0
		v.anim = v.anim + 1
		if v.anim > 6 then
			v.anim = 1
		end
	end

	--]]

	self.picanim:update(dt)

	if self.killed.type or self.destroy then return end
	--[[
		for i,b in ipairs(level.allpawns) do
			if not b.killed.type and b ~= self then
				if collision.rectangles(self.x - self.actualwidth/2, self.y-self.actualheight/2, self.actualwidth,self.actualheight, b.x - b.actualwidth/2, b.y - b.actualheight/2 , b.actualwidth , b.actualheight) then
					local direction = collision.direction.rectangles(self.former.x - self.actualwidth/2,self.former.y-self.actualheight/2, self.actualwidth, self.actualheight, b.former.x - b.actualwidth/2,b.former.y-b.actualheight/2, b.actualwidth, b.actualheight)
					if direction == "right" then
						self.x = b.x + b.actualwidth/2 + self.actualwidth/2
						self.xspeed = math.abs(self.xspeed)
						b.xspeed = -math.abs(b.xspeed)
					elseif direction == "left" then
						self.x = b.x - b.actualwidth/2 - self.actualwidth/2
						self.xspeed = -math.abs(self.xspeed)
						b.xspeed = math.abs(b.xspeed)
					elseif direction == "top"  then
						self.y = b.y - b.actualheight/2 - self.actualheight/2
						self.yspeed = 0
					elseif direction == "bottom"  then
						b.yspeed = 0
						b.y = self.y - self.actualheight/2 - b.actualheight/2
					end
				end
			end --if not nil
		end
	--]]

	self.inwater = false
	self.inwaterwidth = 0
	self.inwaterheight = 0

	for j,rect in pairs(level[player.location].blocks) do
		if collision.rectangles(rect.x, rect.y, rect.width,rect.height, self.x - self.actualwidth/2, self.y - self.actualheight/2 , self.actualwidth , self.actualheight) then
			if not rect.permeable then --rect.type == "grassydirt" or rect.type == "dirt" then
				--local direction = collision.direction.rectangles1(self.former.x - self.actualwidth/2,self.former.y-self.actualheight/2, self.actualwidth, self.actualheight,self.xspeed,self.yspeed, rect.x, rect.y, rect.width,rect.height,0,0)
				local direction = collision.direction.rectangles2(self.x - self.actualwidth/2,self.y-self.actualheight/2, self.actualwidth, self.actualheight,self.xspeed,self.yspeed, rect.x, rect.y, rect.width,rect.height,0,0)
				if direction == "right" and self.groundy ~= rect.y then
					self.x = rect.x + rect.width + self.actualwidth/2
					self.xspeed = math.abs(self.xspeed)
				elseif direction == "left" and self.groundy ~= rect.y then
					self.x = rect.x - self.actualwidth/2 
					self.xspeed = -math.abs(self.xspeed)
				elseif direction == "top"  then
					self.y = rect.y - self.actualheight/2
					self.yspeed = 0
					self.groundy = rect.y
				elseif direction == "bottom"  then
					self.yspeed = 0
					self.y = rect.y + rect.height + self.actualheight/2
				end
			elseif rect.type == 'water' then
				--[[v.xspeed = v.speed * 0.55
				if v.yspeed > 0 then
					v.yspeed = v.yspeed - v.yspeed * dt * 10
				else
					v.yspeed = v.yspeed *0.99
				end --]]
				local xo, yo = collision.rectanglesOverlap(self.x-self.actualwidth/2, self.y-self.actualheight/2, self.actualwidth, self.actualheight, rect.x,rect.y,rect.width, rect.height)
				self.inwaterwidth = self.inwaterwidth + xo
				self.inwaterheight = self.inwaterheight + yo
				self.inwater = true
			end
		else
			--v.direction = "" ------------??????????????????????? What is this used for??
		end
	end--for level loop

	if self.inwater then
		applyForce(self,0, -self.ygravity/200*(self.inwaterwidth*self.actualwidth/3*self.inwaterheight),dt)
		applyForce(self,-0.5/200*self.actualheight*self.actualwidth/3*self.xspeed*math.abs(self.xspeed), -0.5/200*self.actualwidth*self.actualwidth/3*self.yspeed*math.abs(self.yspeed),dt)
	end

end


function enemy.pawn.updatePawnCollisions()
	for a=1,level[player.location].numPawns do
		local b = level[player.location].allpawns[a]
		if b ~= nil and not b.killed.type then
			for i=a+1,level[player.location].numPawns do
				v = level[player.location].allpawns[i]
				
				if v ~= nil and not v.killed.type then
					local collide = collision.rectangles(v.x - v.actualwidth/2, v.y-v.actualheight/2, v.actualwidth,v.actualheight, b.x - b.actualwidth/2, b.y - b.actualheight/2 , b.actualwidth , b.actualheight)
					if collide then
						
						local direction = collision.direction.rectangles1(v.former.x - v.actualwidth/2,v.former.y-v.actualheight/2, v.actualwidth, v.actualheight,v.xspeed,v.yspeed, b.former.x - b.actualwidth/2,b.former.y-b.actualheight/2, b.actualwidth, b.actualheight,b.xspeed,b.yspeed)
						--local direction = collision.direction.rectangles2(v.x - v.actualwidth/2,v.y-v.actualheight/2, v.actualwidth, v.actualheight, v.xspeed,v.yspeed, b.x - b.actualwidth/2,b.y-b.actualheight/2, b.actualwidth, b.actualheight, b.xspeed,b.yspeed)

						local px,py = v.x,v.y
						if direction == "right" then
							v.x = b.x + b.actualwidth/2 + v.actualwidth/2
							if v.xspeed * b.xspeed > 0 then
								v.xspeed = math.abs(v.xspeed)
							else
								v.xspeed = math.abs(v.xspeed)
								b.xspeed = -math.abs(b.xspeed)
							end
							--v.xspeed = -math.abs(v.xspeed) --I should try to remember why these two lines don't
							--b.xspeed = math.abs(b.xspeed)  -- work but the preceding 6 lines do
						elseif direction == "left" then
							v.x = b.x - b.actualwidth/2 - v.actualwidth/2
							if v.xspeed * b.xspeed > 0 then
								v.xspeed = -math.abs(v.xspeed)
							else
								v.xspeed = -math.abs(v.xspeed)
								b.xspeed = math.abs(b.xspeed)
							end
							--v.xspeed = math.abs(v.xspeed) --I should try to remember why these two lines don't
							--b.xspeed =-math.abs(b.xspeed) -- work but the preceding 6 lines do
						elseif direction == "top"  then
							v.y = b.y - b.actualheight/2 - v.actualheight/2
							v.yspeed = 0
						elseif direction == "bottom"  then
							b.yspeed = 0
							b.y = v.y - v.actualheight/2 - b.actualheight/2
						end

						if direction then
							v.collidewith[b] = true
							b.collidewith[v] = true
						end
						if (v.x-px)^2+(v.y-py)^2 > 20*20 then
							--paused = true
							print("D: " .. direction )
							v.bad = true
						end
					else--if not collide then
						v.collidewith[b] = nil
					end
				end
			end


		end		
	end

end


function enemy.pawn:draw()
	if self.killed.type == "squashed" then
		love.graphics.setColor(255,255,255,math.random(1,3)*80)
		love.graphics.draw(pawnpics.squashed[self.face], self.x-self.drawwidth/2, self.y-self.drawheight/2,0,self.drawwidth/pawnpics.width, self.drawheight/pawnpics.height)
	elseif self.killed.type == "arrow" then
		love.graphics.setColor(255,255,255,v.killed.countdown*255/3)
		love.graphics.draw(pawnpics.animation[self.face][math.floor(self.picanim.value)], self.x-self.drawwidth/2, self.y-self.drawheight/2,0,self.drawwidth/pawnpics.width, self.drawheight/pawnpics.height)
	else
		love.graphics.setColor(255,255,255)
		love.graphics.draw(pawnpics.animation[self.face][math.floor(self.picanim.value)], self.x-self.drawwidth/2, self.y-self.drawheight/2,0,self.drawwidth/pawnpics.width, self.drawheight/pawnpics.height)
	end
	love.graphics.setColor(math.min(self.allindex*4,255), math.max(255-self.allindex*4,0),255)
	if self.bad then
		love.graphics.setColor(255,255,0)
	end
	--love.graphics.rectangle("fill",self.x-self.actualwidth/2,self.y-self.actualheight/2,self.actualwidth,self.actualheight)

	love.graphics.setFont(defaultfont[14])
	love.graphics.setColor(255,255,255)
	--love.graphics.printf(self.allindex,self.x-self.actualwidth/2,self.y-self.actualheight*0.3,self.actualwidth,'center')
end

function enemy.pawn:die(type,countdown,atts)
	self.health = 0

	self.killed.type = type or 'inexplicable'
	self.killed.countdown = countdown or 0

	atts = atts or {}
	self.ygravity = atts.ygravity or 0
	self.yspeed = atts.yspeed or 0
	self.xspeed = atts.xspeed or 0

	local rand = math.random()
	if rand < 0.5 then
		enemydrop.make{x=self.x,y=self.y,type='arrow',physics=true,ygrav=4,yspeed=-50,mass=10,yoffset=-10,bounce=0.5,value=5,width=60,height=30,boxcolor={60,150,200},wait=1}
	else
		enemydrop.make{x=self.x,y=self.y,type='health',physics=true,ygrav=4,yspeed=50,mass=10,yoffset=-10,bounce=0.5,value=5,width=60,height=30,boxcolor={60,150,200},wait = 1}
	end
end

function enemy.pawn:getHurt(damage,type,countdown,hurtatts,deathatts)
	self.health = self.health - 1

	if self.health <= 0 then
		self:die(type,countdown,deathatts)
		return
	end

	if type(hurtatts) == 'table' then
		self.ygravity = hurtatts.ygravity or self.ygravity
		self.yspeed = hurtatts.yspeed or self.yspeed
		self.xspeed = hurtatts.xspeed or self.xspeed
	end
end
