weapons = {}


weapons.sword = {}
weapons.sword.__index = weapons.sword

weapons.sword.pic = love.graphics.newImage("Art/Weapon Pics/sword.png")
weapons.sword.picwidth = weapons.sword.pic:getWidth()
weapons.sword.picheight = weapons.sword.pic:getHeight()
weapons.sword.hiltx = 97
weapons.sword.hilty = 490
weapons.sword.hiltAngle = math.atan(490/97)


function weapons.sword.make()
	local sword = {}
	setmetatable(sword,weapons.sword)
	sword.metatable = 'weapons.sword'
	
	sword.type = "sword"
	sword.state = 'ready'
	
	sword.angle = math.pi/3--math.atan(490/97)+math.pi/4
	
	sword.width = 22
	sword.height = sword.width/weapons.sword.picwidth * weapons.sword.picheight+5
	
	sword.hiltMag = ((weapons.sword.hiltx*sword.width/weapons.sword.picwidth)^2 + (weapons.sword.hilty*sword.height/weapons.sword.picheight)^2)^0.5
	--sword.picHilt.x = weapons.sword.hiltx  *sword.width/weapons.sword.picwidth
	--sword.picHilt.y = weapons.sword.hilty  *sword.height/weapons.sword.picheight
	--sword.picHilt.angle = math.atan(490/97)
	
	sword.length = weapons.sword.hilty*sword.height/weapons.sword.picheight
	sword.lengthAngle = -math.pi/2
	
	sword.tips = {}
	sword.tipsLife = 0.2
	
	return sword
end

function weapons.sword:fixedSwingUdate(dt)
	--self.hiltx = player.x + (110-playerimages.picwidth/2)/playerimages.picwidth*player.drawwidth --the hilt will be placed, (110,345)
	--self.hilty = player.y + (345-playerimages.picheight/2)/playerimages.picheight*player.drawheight
	if self.state == 'ready' then
	elseif self.state == 'up' then
		player.armAngle = player.armAngle + self.aspeed*dt
		if math.abs(player.armAngle) > 2*math.pi/3 then
			self.state = 'down'
			player.armAngle = 2*math.pi/3*player.armAngle/math.abs(player.armAngle)
			self.aspeed = self.aspeed*-5.5
		end
	elseif self.state == 'down' then
		local lastA = player.armAngle
		player.armAngle = player.armAngle + self.aspeed*dt
		if lastA* player.armAngle < 0 then
			self.state = 'ready'
			player.armAngle = 0
			self.aspeed = 0
		end
		table.insert(self.tips,{self.tipx,self.tipy,t=love.timer.getTime()})
	end
	
	self.hilty = player.y+player.armOffsetY+ player.armLength*math.sin(playerfunctions.armAngle + player.armAngle)
	if player.facing == 'left' then--player.lastmoving == 'a' then
		self.hiltx = player.x-player.armOffsetX + player.armLength*math.cos(playerfunctions.armLengthAngle + player.armAngle)
		self.angle = player.armAngle-math.pi/2
		self.drawx = self.hiltx - math.cos(weapons.sword.hiltAngle + self.angle)*self.hiltMag
	else
		self.hiltx = player.x+player.armOffsetX+ player.armLength*math.cos(playerfunctions.armLengthAngle + player.armAngle)
		self.angle = player.armAngle+math.pi/2
		self.drawx = self.hiltx - math.cos(weapons.sword.hiltAngle + self.angle)*self.hiltMag
	end
	
	self.tipx = self.hiltx + self.length*math.cos(self.lengthAngle + self.angle)
	self.tipy = self.hilty + self.length*math.sin(self.lengthAngle + self.angle)
		
	self.drawy = self.hilty - math.sin(weapons.sword.hiltAngle + self.angle)*self.hiltMag
	
	if self.state == 'down' then
		for i,v in pairs(currentLevel.allsoldiers) do
			
			if collision.lineRectangle(self.hiltx,self.hilty,self.tipx,self.tipy, v:getCollisionBox()) then
				if not v.killed.countdown then
					local col,x,y =  collision.lineRectangle(self.hiltx,self.hilty,self.tipx,self.tipy, v:getHeadBox()) 
					if col then
					 	v:die('sword',1,{yspeed=-50,ygravity=10})
					 	if x then
							table.insert(states.game.explosions,explosion.make(x,y,1))
						end
					end
				end
			
			end
		end
	
		for i,v in pairs(currentLevel.allpawns) do
			local col,x,y = collision.lineRectangle(self.hiltx,self.hilty,self.tipx,self.tipy, v:getCollisionBox())
			if col then
				if not v.killed.countdown then
					v:getHurt(2,'sword',2,{xspeed = v.xspeed*0.5})
					if x then
						table.insert(states.game.explosions,explosion.make(x,y,1))
					end
				end
			end
		end
	
		for i,v in pairs(currentLevel.allwizards) do
			local col,x,y = collision.lineRectangle(self.hiltx,self.hilty,self.tipx,self.tipy, v:getCollisionBox())
			if col then
				if not v.killed.countdown then
					v:getHurt(1,'sword',0.5)
					if x then
						table.insert(states.game.explosions,explosion.make(x,y,1,{0,140,255}))
					end
				end
			end
			
		end
	end
	
end

function weapons.sword:update(dt)
	--self.hiltx = player.x + (110-playerimages.picwidth/2)/playerimages.picwidth*player.drawwidth --the hilt will be placed, (110,345)
	--self.hilty = player.y + (345-playerimages.picheight/2)/playerimages.picheight*player.drawheight
	if self.state == 'ready' then
		local mx,my = love.mouse.getPosition()
		local worldx,worldy = getWorldPoint(mx,my)
		player.armAngle = math.atan2(player.y-worldy,player.x-worldx) + math.pi/2
		if player.armAngle > math.pi then
			player.armAngle = player.armAngle-math.floor(player.armAngle/math.pi/2)*math.pi*2 - math.pi*2
		end
	elseif self.state == 'up' then
		self.aspeed = self.aspeed - 5*(player.armAngle-self.targetA)*dt
		local lastA = player.armAngle
		player.armAngle = player.armAngle + self.aspeed*dt
		if (lastA-self.targetA)* (player.armAngle-self.targetA) <= 0 then
			self.state = 'ready'
			player.armAngle = self.targetA
		end
	elseif self.state == 'down' then

		local lastA = player.armAngle
		player.armAngle = player.armAngle + self.aspeed*dt
		if self.aspeed* (player.armAngle-self.turnA) >= 0 then
			self.state = 'up'
			player.armAngle = self.turnA
			self.aspeed = -self.aspeed/math.abs(self.aspeed)*5
		end
		table.insert(self.tips,{self.tipx,self.tipy,t=love.timer.getTime()})
	end
	
	self.lastTipx,self.lastTipy = self.tipx, self.tipy
	self.lastHiltx, self.lastHilty = self.hiltx,self.hilty
	
	self.hilty = player.y+player.armOffsetY+ player.armLength*math.sin(playerfunctions.armAngle + player.armAngle)
	if player.facing == 'left' then--player.lastmoving == 'a' then
		self.hiltx = player.x-player.armOffsetX + player.armLength*math.cos(playerfunctions.armLengthAngle + player.armAngle)
		self.angle = player.armAngle-math.pi/2
		self.drawx = self.hiltx - math.cos(weapons.sword.hiltAngle + self.angle)*self.hiltMag
	else
		self.hiltx = player.x+player.armOffsetX+ player.armLength*math.cos(playerfunctions.armLengthAngle + player.armAngle)
		self.angle = player.armAngle+math.pi/2
		self.drawx = self.hiltx - math.cos(weapons.sword.hiltAngle + self.angle)*self.hiltMag
	end
	
	self.tipx = self.hiltx + self.length*math.cos(self.lengthAngle + self.angle)
	self.tipy = self.hilty + self.length*math.sin(self.lengthAngle + self.angle)
	
	self.drawy = self.hilty - math.sin(weapons.sword.hiltAngle + self.angle)*self.hiltMag
	
	if self.state == 'down' then
		for i,v in pairs(currentLevel.allsoldiers) do
			local col,x,y = collision.lineRectangle(self.hiltx,self.hilty,self.tipx,self.tipy, v:getCollisionBox())
			if col then
				if not v.killed.countdown then
				 	v:die('sword',1,{yspeed=-50,ygravity=10})
				 	player.xp = player.xp + v.xp
				 	if x then
						table.insert(states.game.explosions,explosion.make(x,y,1))
					end
				end
			else
			
				col,x,y = collision.lineRectangle(self.hiltx,self.hilty,self.lastTipx,self.lastTipy, v:getCollisionBox())
				if col then
					if not v.killed.countdown then
					 	v:die('sword',1,{yspeed=-50,ygravity=10})
					 	player.xp = player.xp + v.xp
					 	if x then
							table.insert(states.game.explosions,explosion.make(x,y,1))
						end
					end
				else
			
					col,x,y = collision.lineRectangle(self.lastHiltx,self.lastHilty,self.tipx,self.tipy, v:getCollisionBox())
					if col then
						if not v.killed.countdown then
						 	v:die('sword',1,{yspeed=-50,ygravity=10})
						 	player.xp = player.xp + v.xp
						 	if x then
								table.insert(states.game.explosions,explosion.make(x,y,1))
							end
						end
					end
				end
			end
			
		end
	
		for i,v in pairs(currentLevel.allpawns) do
			local col,x,y = collision.lineRectangle(self.hiltx,self.hilty,self.tipx,self.tipy, v:getCollisionBox())
			if col then
				if not v.killed.countdown then
					v:getHurt(2,'sword',0.5,{xspeed = v.xspeed*0.5},{xspeed=0,yspeed=0,ygravity=0})
					if x then
						table.insert(states.game.explosions,explosion.make(x,y,1))
					end
				end
			else
			
				col,x,y = collision.lineRectangle(self.hiltx,self.hilty,self.lastTipx,self.lastTipy, v:getCollisionBox())
				if col then
					if not v.killed.countdown then
					 	v:getHurt(2,'sword',0.5,{xspeed = v.xspeed*0.5},{xspeed=0,yspeed=0,ygravity=0})
						if x then
							table.insert(states.game.explosions,explosion.make(x,y,1))
						end
					end
				else
			
					col,x,y = collision.lineRectangle(self.lastHiltx,self.lastHilty,self.tipx,self.tipy, v:getCollisionBox())
					if col then
						if not v.killed.countdown then
						 	v:getHurt(2,'sword',0.5,{xspeed = v.xspeed*0.5},{xspeed=0,yspeed=0,ygravity=0})
							if x then
								table.insert(states.game.explosions,explosion.make(x,y,1))
							end
						end
					end
				end
			end
		end
	
		for i,v in pairs(currentLevel.allwizards) do
			local col,x,y = collision.lineRectangle(self.hiltx,self.hilty,self.tipx,self.tipy, v:getCollisionBox())
			if col then
				if not v.killed.countdown then
					v:getHurt(1,'sword',0.5)
					if x then
						table.insert(states.game.explosions,explosion.make(x,y,1,{0,140,255}))
					end
				end
			else
			
				col,x,y = collision.lineRectangle(self.hiltx,self.hilty,self.lastTipx,self.lastTipy, v:getCollisionBox())
				if col then
					if not v.killed.countdown then
					 	v:getHurt(1,'sword',0.5)
						if x then
							table.insert(states.game.explosions,explosion.make(x,y,1,{0,140,255}))
						end
					end
				else
			
					col,x,y = collision.lineRectangle(self.lastHiltx,self.lastHilty,self.tipx,self.tipy, v:getCollisionBox())
					if col then
						if not v.killed.countdown then
						 	v:getHurt(1,'sword',0.5)
							if x then
								table.insert(states.game.explosions,explosion.make(x,y,1,{0,140,255}))
							end
						end
					end
				end
			end
			
			
			
		end
	end
	
end

function weapons.sword:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(weapons.sword.pic, self.drawx, self.drawy,self.angle, self.width/weapons.sword.picwidth, self.height/weapons.sword.picheight)
	
	love.graphics.setColor(0,255,0)
	--love.graphics.circle("fill", self.hiltx,self.hilty,2)
	
	love.graphics.setColor(255,0,0)
	--love.graphics.circle("fill", self.tipx,self.tipy,2)
	
	
	local curTime = love.timer.getTime()
	for i,v in ipairs(self.tips) do
		love.graphics.setColor(255,255,255, math.max(255*(1-(curTime-v.t)/self.tipsLife),0))
		love.graphics.circle("fill",v[1],v[2],2*(#self.tips-i))
	end
	
	love.graphics.setLineWidth(2)
	love.graphics.setColor(0,0,0)
	--love.graphics.line(self.hiltx,self.hilty,self.tipx,self.tipy)

end

function weapons.sword:mousepressed(x,y,button)
	if button == 1 and self.state == 'ready' then
		self:swing()
	end
end


function weapons.sword:fixedSwing()
	self.state = 'up'
	self.tips = {}
	if player.facing == 'left' then
		self.aspeed = 10
	else
		self.aspeed = -10
	end
end

function weapons.sword:swing()
	self.state = 'down'
	self.targetA = player.armAngle
	self.turnA = player.armAngle - (2*math.pi/3)*player.armAngle/math.abs(player.armAngle)
	self.tips = {}
	if player.facing == 'left' then
		self.aspeed = -55
	else
		self.aspeed = 55
	end
end



weapons.bow = {}
weapons.bow.__index = weapons.bow

weapons.bow.pic = love.graphics.newImage("Art/Weapon Pics/bow.png")
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
	
	bow.maxPower = 40
	bow.minPower = 0
	bow.power = 0
	
	bow.angle = 0
	
	bow.stringPoints = {0,-30,  0,0,  0,30}
	bow.maxStretch = 15
	bow.stringSpeed = 0
	bow.stringMid = {x=0,y=0}
	
	local xF,yF = bezier.makeFunctions{0,-30, 20,-25, 20,25,   0,30}
	bow.hardPoints = {}
	for t=0,1,0.01 do
		table.insert(bow.hardPoints,xF(t))
		table.insert(bow.hardPoints,yF(t))
	end

	bow.offsetX = 20
	bow.offsetY = 0
	
	bow.newArrow = nil
	
	return bow
end

function weapons.bow:update(dt)
	self.x,self.y = player.x +player.armOffsetX,player.y+player.armOffsetY
	if self.state == 'aiming' then
		local x,y = love.mouse.getPosition()
		local worldx,worldy = getWorldPoint(x,y) --camera.x+(x-camera.width/2),camera.y+(y-camera.height/2)
		
		self.power = 0.3 * ( (worldx-self.x)^2 + (worldy - self.y)^2)^0.5
		
		if self.power > self.maxPower then
			self.power = self.maxPower
		elseif self.power < self.minPower then
			self.power = self.minPower
		end
		
		
		self.stringPoints[3] = -self.maxStretch*(self.power+5-self.minPower) /(self.maxPower+5-self.minPower)
		
		self.angle = math.atan2(worldy-self.y,worldx-self.x)
		
		local mag = ((self.stringMid.x)^2+self.stringMid.y^2)^0.5
		mag = -mag+(self.offsetX^2+self.offsetY^2)^0.5
		self.newArrow = weapons.arrow.make(self.x+mag*math.cos(self.angle),self.y+mag*math.sin(self.angle), self.power * 5, self.angle)
		
		if not love.mouse.isDown(1) then
			self:fire()
		end
	else
		if self.stringPoints[3] ~= 0 then
			self.stringSpeed = self.stringSpeed - 1000*self.stringPoints[3]*dt - 25*self.stringSpeed*dt --spring force minus damping force
			self.stringPoints[3] = self.stringPoints[3] + self.stringSpeed*dt
			--print(self.stringPoints[3])
			if math.abs(self.stringPoints[3])<0.001 then
				self.stringPoints[3] = 0
			end
		end
		
		local x,y = love.mouse.getPosition()
		local worldx,worldy = getWorldPoint(x,y)
		self.angle = math.atan2(worldy-self.y,worldx-self.x)
		
	end
	
	player.armAngle = self.angle - math.pi/2
end

function weapons.bow:draw()
	
	
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
			--love.graphics.circle("fill",x,y,size - math.abs(t*size/7))
			t = t + 0.1

			if x < camera.x - camera.width/2 or x > camera.x + camera.width/2 then
				break
			end
		end
		
		self.newArrow:draw()
		
	end
	
	local xF,yF = bezier.makeFunctions(self.stringPoints)
	local stringCurve = {}
	for t=0,1,0.01 do
		table.insert(stringCurve,xF(t))
		table.insert(stringCurve,yF(t))
	end
	
	self.stringMid = {x=xF(0.5),y=yF(0.5)}
	
	love.graphics.push()
	love.graphics.translate(self.x,self.y)
	love.graphics.rotate(self.angle)
	love.graphics.translate(-self.x,-self.y)
	
	love.graphics.translate(self.x+self.offsetX,self.y+self.offsetY)
	
	love.graphics.setLineWidth(2)
	love.graphics.setColor(255,255,255)
	love.graphics.line(stringCurve)
	
	love.graphics.setLineWidth(4)
	love.graphics.setColor(100,100,40)
	love.graphics.line(self.hardPoints)
	
	love.graphics.pop()
end

function weapons.bow:mousepressed(x,y,button)
	if button == 1 and self.arrowsLeft > 0 then
		self:pullBack()
	end
end

function weapons.bow:pullBack()
	self.state = 'aiming'
	self.power = self.minPower
	self.newArrow = weapons.arrow.make(self.x,self.y, self.power * 5, self.angle)
end

function weapons.bow:fire()
	local speed = self.power * 5
	--table.insert(player.arrows, weapons.arrow.make(self.x,self.y, speed, self.angle) )
	table.insert(player.arrows,self.newArrow)
	
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

weapons.arrow.pic = love.graphics.newImage("Art/Weapon Pics/arrow.png")
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

		
	for i,v in pairs(currentLevel.allsoldiers) do
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
	
	for i,v in pairs(currentLevel.allpawns) do
		if collision.pointRectangle(self.x,self.y, v:getCollisionBox()) then
			if not v.killed.countdown then
				v:getHurt(1,'arrow',2,{xspeed = v.xspeed*0.5})
				self:stickTo(v)
				return
			end
		end
	end
	
	--[
	for i,v in pairs(currentLevel.allwizards) do
		if collision.pointRectangle(self.x,self.y, v:getCollisionBox()) then
			if not v.killed.countdown then
				v:getHurt(1,'arrow',0.5)--v:getHurt(1,'arrow',2,{xspeed = v.xspeed*0.5})
				self:stickTo(v)
				return
			end
		end
	end
	--]]
	
	for i,v in pairs(currentLevel.allmonkeys) do
		if collision.pointRectangle(self.x,self.y, v:getCollisionBox()) then
			if not v.killed.countdown then
				v:getHurt(1,'arrow',2,{xspeed = v.xspeed*0.5})
				self:stickTo(v)
				return
			end
		end
	end

	self.collide = false
	for i,rect in pairs(currentLevel.blocks) do
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
	table.insert(states.game.explosions,explosion.make(self.x,self.y,1))
end

function weapons.arrow:calculatePoints(angle)
	local mag = weapons.arrow.width*0.1 ---------Consider making this a constant of this "class"
	self.tipx = self.x + math.cos(self.angle)*mag
	self.tipy = self.y + math.sin(self.angle)*mag

	local mag = (  (0.5*weapons.arrow.height)^2 + ( weapons.arrow.width^2) )^0.5 ---------Consider making this a constant of this "class"
	self.drawx = self.tipx - math.cos(weapons.arrow.angle + self.angle)*mag
	self.drawy = self.tipy - math.sin(weapons.arrow.angle + self.angle)*mag
end



weapons.none = {}
weapons.none.__index = weapons.none

function weapons.none.make()
	local self = {}
	setmetatable(self,weapons.none)
	self.metatable = 'weapons.none'
	
	self.type = "none"
	self.state = 'ready'
	
	return self
end

function weapons.none:update(dt)
	if self.state == 'ready' then
		
	end
	
end

function weapons.none:draw()
	
end

function weapons.none:mousepressed(x,y,button)
	
end

