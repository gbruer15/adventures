weapons = {}



weapons.bow = {}
weapons.bow.__index = weapons.bow

weapons.bow.pic = love.graphics.newImage("Weapon Pics/bow.png")
function weapons.bow.make(quiverSize, numArrows)
	local bow = {}
	setmetatable(bow,weapons.bow)
	bow.metatable = 'weapons.bow'
	
	bow.quiverSize = quiverSize or 0
	bow.arrowsLeft = numArrows or bow.quiverSize
	bow.arrows = {}
	bow.type = "bow"
	bow.state = 'ready'
	--bow.x, bow.y = player.x,player.y
	
	bow.maxPower = 100
	bow.minPower = 0
	bow.power = 0
	
	return bow
end

function weapons.bow:update(dt)
	self.x,self.y = player.x,player.y
	if self.state == 'aiming' then
		local x,y = love.mouse.getPosition()
		local worldx,worldy = getWorldPoint(x,y) --camera.x+(x-camera.width/2),camera.y+(y-camera.height/2)
		
		self.power = 0.3 * ( (worldx-self.x)^2 + (worldy - self.y)^2)^0.5
		if self.power > self.maxPower then
			self.power = self.maxPower
		elseif self.power < self.minPower then
			self.power = self.minPower
		end
		
		self.angle = math.atan2(worldy-self.y,worldx-self.x)
		
		if not love.mouse.isDown(1) then
			self:fire()
		end
	end
	
	for i,b in ipairs(self.arrows) do
		if b:update(dt)	then
			table.remove(self.arrows,i)
		end
	end
end

function weapons.bow:draw()
	for i,v in ipairs(self.arrows) do
		v:draw()
	end
	
	if self.state == "aiming" and clear then		
		local speed = self.power * 5
		
		local xspeed = math.cos(self.angle)*speed
		local yspeed = math.sin(self.angle)*speed
		local t = 0
		
		local size = (self.power)^0.6
		while math.abs(t) <= 7 do
			y = weapons.arrow.ygravity*metersize/2 * t*t + yspeed* t + self.y
			x = xspeed * t + self.x
			love.graphics.setColor(255 - math.abs(t*255/7),math.abs(t*255/7),math.abs(t*255/7), 255 - math.abs(t*255/7))
			love.graphics.circle("fill",x,y,size - math.abs(t*size/7))
			t = t + 0.1

			if x < camera.x - camera.width/2 or x > camera.x + camera.width/2 then
				break
			end
		end
	end
	
end

function weapons.bow:pullBack()
	self.state = 'aiming'
	self.power = self.minPower
end

function weapons.bow:fire()
	local speed = self.power *5
	
	table.insert(self.arrows, weapons.arrow.make(self.x,self.y, speed, self.angle) )

	
	if self.quiverSize then
		self.arrowsLeft = self.arrowsLeft - 1
	end
	self.state = 'ready'
	
	sfx.twong:stop()
	sfx.twong:play()
	
end


weapons.arrow = {}
weapons.arrow.__index = weapons.arrow
weapons.arrow.ygravity = 5

weapons.arrow.pic = love.graphics.newImage("Weapon Pics/arrow.png")
weapons.arrow.picwidth = weapons.arrow.pic:getWidth()
weapons.arrow.picheight = weapons.arrow.pic:getHeight()
weapons.arrow.width = 40
weapons.arrow.height = 10
weapons.arrow.angle = math.atan2(0.5*weapons.arrow.height, weapons.arrow.width)

function weapons.arrow.make(x,y, speed, angle)
	local arrow = createObject({x=x, 
								y=y,
								ygrav = weapons.arrow.ygravity, 
								mass = 0.001})
	setmetatable(arrow, weapons.arrow)
	arrow.metatable = 'weapons.arrow'
	
	arrow.angle = angle
	
	arrow.xspeed = math.cos(arrow.angle)*speed
	arrow.yspeed = math.sin(arrow.angle)*speed

	arrow.moving = true
	
	arrow.stuck = false
	
	local mag = weapons.arrow.width*0.1
	arrow.tipx = arrow.x + math.cos(arrow.angle)*mag
	arrow.tipy = arrow.y + math.sin(arrow.angle)*mag
	
	local mag = (  (0.5*weapons.arrow.height)^2 + ( weapons.arrow.width^2) )^0.5
	arrow.drawx = arrow.tipx - math.cos(weapons.arrow.angle + arrow.angle)*mag
	arrow.drawy = arrow.tipy - math.sin(weapons.arrow.angle + arrow.angle)*mag
	
	
	
	if crazycolor then
		local rand = math.random(2,2)
		if rand == 1 then
			arrow.color = {255,0,0}
		elseif rand == 2 then
			arrow.color = {0,255,0}
		elseif rand == 3 then
			arrow.color = {0,0,255}
		end
	else
		arrow.color = {255,255,255}
	end
	
	return arrow
end

function weapons.arrow:update(dt)
	if self.life then
		self.life = self.life - dt
		if self.life <= 0 then
			return true
		end
	end
	
	if not self.moving then
		return
	end


	if not self.stuckTo then
		updateObject(self, dt)
	else
		self.drawx = self.stuckTo.x - self.xoff 
		self.drawy = self.stuckTo.y - self.yoff
		self.life = self.stuckTo.killed.countdown
		return
	end
	
	self.angle = math.atan2(self.yspeed,self.xspeed) 
	local mag = weapons.arrow.width*0.1 ---------Consider making this a constant of this "class"
	self.tipx = self.x + math.cos(self.angle)*mag
	self.tipy = self.y + math.sin(self.angle)*mag

	local mag = (  (0.5*weapons.arrow.height)^2 + ( weapons.arrow.width^2) )^0.5 ---------Consider making this a constant of this "class"
	self.drawx = self.tipx - math.cos(weapons.arrow.angle + self.angle)*mag
	self.drawy = self.tipy - math.sin(weapons.arrow.angle + self.angle)*mag

		
	for i,v in pairs(level[player.location].allsoldiers) do
		if collision.pointRectangle(self.x,self.y, v:getCollisionBox()) then
			if not v.killed.countdown then
				if collision.pointRectangle(self.x,self.y, v:getHeadBox()) then
				 	v:die('arrow',1,{yspeed=-50,ygravity=10})
				end					
				self:stickTo(v)				
				return
			end
			
		end
	end
	
	for i,v in pairs(level[player.location].allpawns) do
		if collision.pointRectangle(self.x,self.y, v:getCollisionBox()) then
			if not v.killed.countdown then
				v:getHurt(1,'arrow',2,{xspeed = v.xspeed*0.5})
				self:stickTo(v)
				return
			end
		end
	end

	self.collide = false
	for i,rect in pairs(level[player.location].blocks) do
		if collision.pointRectangle(self.x, self.y,rect.x, rect.y, rect.width,rect.height) then
			if true then
				if not rect.permeable then
					self.moving = false
					self.life = 4
				elseif rect.type =='water' then
					local s = (self.xspeed * self.xspeed + self.yspeed * self.yspeed)^0.5
					local ang = math.atan2(self.yspeed,self.xspeed)
					s = s * 0.9
					self.xspeed = math.cos(ang)*s
					self.yspeed = math.sin(ang)*s
				end
			else -- bouncy. doesn't work very well
				self.collide = true --[[
				if rect.type == "grassydirt" or rect.type == "dirt" then
					local direction = collision.direction.pointRectangle(player.formerarrows[a].x, player.formerarrows[a].y, rect.x, rect.y, rect.width, rect.height)
					if direction == "right" then
						self.x = rect.x + rect.width
						self.xspeed = math.abs(self.xspeed)* 0.6
					elseif direction == "left" then
						self.x = rect.x
						self.xspeed = - math.abs(self.xspeed) * 0.6
					elseif direction == "top" or rect.direction=="top" then
						self.y = rect.y
						self.yspeed = -math.abs(self.yspeed)* 0.6
						self.xspeed = self.xspeed * 0.6
					elseif direction == "bottom" or rect.direction=="bottom" then
						self.yspeed = math.abs(self.yspeed)* 0.6
						self.y = rect.y + rect.height
						self.xspeed = self.xspeed * 0.6
					end
				elseif rect.type == 'water' then
					self.xspeed = self.xspeed * dt * 54.6
					self.yspeed = self.yspeed * dt * 54.6
				end
				if math.round(self.xspeed,0.01) == 0 then
					self.stuck.countdown = 2
					self.ygravity = -5
				end
				--]]
			end
		end 
	end --Level Collisions
	
	if self.collide then
		self.angle = math.atan2(self.yspeed,self.xspeed) 
		local mag = playerarrow.width*0.1
		self.tipx = self.x + math.cos(self.angle)*mag
		self.tipy = self.y + math.sin(self.angle)*mag

		local mag = (  (0.5*playerarrow.height)^2 + ( playerarrow.width^2) )^0.5
		self.drawx = self.tipx - math.cos(playerarrow.angle + self.angle)*mag
		self.drawy = self.tipy - math.sin(playerarrow.angle + self.angle)*mag
	end


end

function weapons.arrow:draw()

	if collision.rectangles(self.drawx-self.width,self.drawy-self.width,self.width * 2,self.height * 2, getWorldScreenRect()) then
		if self.life and self.life < 3 then
			love.graphics.setColor(255,255,255,self.life*255/3)
		else
			love.graphics.setColor(255,255,255)
		end
		love.graphics.draw(weapons.arrow.pic, self.drawx, self.drawy,self.angle, self.width/weapons.arrow.picwidth,self.height/weapons.arrow.picheight)
		--[[
		if self.stuckTo then
			love.graphics.setColor(255,255,255)
			if pawn.pawns[self.stuck.key] then
				if pawn.pawns[self.stuck.key].countdown then
					love.graphics.setColor(255,255,255,pawn.pawns[self.stuck.key].countdown*255/3)
				else
					love.graphics.setColor(255,255,255)
				end
			end
			if night then
				love.graphics.setColor(0,255,0)
			end
			love.graphics.draw(playerarrow.pic, self.drawx, self.drawy,self.angle, playerarrow.width/playerarrow.picwidth,playerarrow.height/playerarrow.picheight)
		elseif self.life then
			love.graphics.setColor(255,255,255)
			if self.life < 3 then
				love.graphics.setColor(255,255,255,self.life*85)
			end
			love.graphics.draw(playerarrow.pic, self.drawx, self.drawy,self.angle, playerarrow.width/playerarrow.picwidth,playerarrow.height/playerarrow.picheight)				
		else
			love.graphics.draw(weapons.arrow.pic, self.drawx, self.drawy,self.angle, self.width/weapons.arrow.picwidth,self.height/weapons.arrow.picheight)
		end
		--]]
		
		
	end
	
	
--	love.graphics.setColor(0,200,0)
--	love.graphics.circle("fill", self.x,self.y,2)
--	love.graphics.setColor(120,120,0)
--	love.graphics.circle("fill", self.tipx,self.tipy,2)
--	
--	
--	--love.graphics.line(self.x,self.y,self.drawx,self.drawy)
--	love.graphics.setColor(255,0,0)
--	love.graphics.circle("fill", self.drawx,self.drawy, 1)
--	love.graphics.setColor(0,0,200)			
--	love.graphics.circle("fill", self.x,self.y, 1)	
		
end

function weapons.arrow:stickTo(enemy)
	self.stuckTo = enemy
	self.xoff = enemy.x - self.drawx
	self.yoff = enemy.y - self.drawy
end

