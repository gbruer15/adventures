
require("iceMissile")
enemy.wizard = {}
enemy.wizard.__index = enemy.wizard
enemy.wizard.type = "wizard"

function enemy.wizard.load()
	wizardpics = {left = love.graphics.newImage("Art/Enemy Pics/Wizard/facing left.png"),right = love.graphics.newImage("Art/Enemy Pics/Wizard/facing right.png")}
	wizardpics.width = wizardpics.left:getWidth()
	wizardpics.height = wizardpics.left:getHeight()
	
end

function enemy.wizard.make(atts)
	local s = createObject{x = atts.x,y=atts.y,mass=atts.mass or 50, ygrav=atts.ygrav or 5, yspeed=atts.yspeed or 0, xspeed=atts.xspeed or 10}

	s.crazymove = atts.crazymove or false
	setmetatable(s,enemy.wizard)
	s.metatable = 'enemy wizard'
	s.type = 'wizard'
	s.timeCount = 0
	if s.xspeed > 0 then
		s.pic = wizardpics.right
	else
		s.pic = wizardpics.left
	end
	
	s.killed = {}
	s.killed.type = false
	s.killed.countdown = false
	
	if atts.drawwidth then
		s.drawwidth = atts.drawwidth
		s.drawheight = atts.drawheight or s.drawwidth*wizardpics.height/wizardpics.width
	else
		s.drawheight = atts.drawheight or 180
		s.drawwidth = s.drawheight * wizardpics.width/wizardpics.height
	end

	s.xp = atts.xp or 1

	s.actualwidth = (79-34)/98 * s.drawwidth
	s.actualheight = (353-45)/353 * s.drawheight
	
	s.head = {}
	s.head.width, s.head.height = s.actualwidth, s.actualheight*40/160
	s.head.xoffset, s.head.yoffset = -s.actualwidth/2, -s.actualheight*0.95 

	s.health = 5
	s.missiles = {}
	s.missileSpeed = atts.missileSpeed or 60
	s.missileGravity = atts.missileGravity or 0.2
	
	s.fireRate = atts.fireRate or 2.5
	s.fireCount = 0
	
	currentLevel.numWizards = currentLevel.numWizards + 1
	s.allindex = currentLevel.numWizards

	currentLevel.allwizards[s.allindex] = s
	
	return s

end



function enemy.wizard:update(dt)
	--[
	for i,v in ipairs(self.missiles) do
		v:update(dt)
	end
	--]]
	
	--[-- Alternative destruction
	for i=#self.missiles,1,-1 do
		if self.missiles[i].destroy then
			table.remove(self.missiles,i)
			--print("Destroyed")
		end
	end
	--]]
	
	self.former = {x=self.x,y=self.y,xspeed=self.xspeed}

	if self.killed.countdown then
		self.xspeed = 0
	end
	updateObject(self, dt)	
	
	if self.killed.countdown then
		self.killed.countdown = self.killed.countdown - dt
		if self.killed.countdown <= 0 then
			self.destroy = true
		end
		return
	end
	
	if self.crazymove then
		self.timeCount = self.timeCount + dt
		local x = self.timeCount
		--self.xspeed = 3*math.sin(x) + 3*math.cos(x)*math.sin(x) + math.sin(x)^2
		self.xspeed = 3*math.sin(x) + 3*math.cos(x)*math.sin(x) - 2*math.cos(x)^2 + 3*math.cos(x)*math.sin(x)^2+1
		self.xspeed = self.xspeed*4
	
		if self.xspeed*self.former.xspeed < 0 then
			self:fireMissile()
		end
	else
		self.fireCount = self.fireCount + dt
		if self.fireCount >= self.fireRate then
			self:fireMissile()
			self.fireCount = 0			
		end
	end
	
	for j,rect in pairs(currentLevel.blocks) do
		local l,t,w,h = self:getCollisionBox()
		if collision.rectangles(rect.x, rect.y, rect.width,rect.height, l,t,w,h) then
			if not rect.permeable then
				local direction = collision.direction.rectangles1(self.former.x - (self.x-l),self.former.y-(self.y-t), w,h,self.xspeed,self.yspeed, rect.x, rect.y, rect.width,rect.height,0,0)
				
				local l,t,w,h = self:getCollisionBox()
				if direction == "right" then
					self.x = rect.x + rect.width + (self.x-l)
					self:turn()
					--self.xspeed = math.abs(self.xspeed)
				elseif direction == "left" then
					self.x = rect.x - (l+w-self.x)--self.actualwidth/2 
					self:turn()
					--self.xspeed = -math.abs(self.xspeed)
				elseif direction=="top"  then
					self.y = rect.y - (t+h-self.y)-0.1--self.actualheight/2   -- is this 0.1 necessary
					self.yspeed = 0
				elseif direction == "bottom"  then
					self.yspeed = 0
					self.y = rect.y + rect.height + (self.y-t)--self.actualheight/2
				end
			elseif rect.type == 'water' then
				self.xspeed = self.xspeed * 0.55
				if self.yspeed > 0 then
					self.yspeed = self.yspeed - self.yspeed * dt * 10
				else
					self.yspeed = self.yspeed *0.99
				end
			end
		else
			--self.direction = ""
		end
	end--for level loop	

end


function enemy.wizard:draw()
	if self.killed.type then
		love.graphics.setColor(255,255,255,self.killed.countdown * 255)
	else
		love.graphics.setColor(255,255,255)
	end
	
	local x,y,w,h = self:getBoundingBox()
	love.graphics.draw(self.pic, x,y,0,w/wizardpics.width, h/wizardpics.height)
	
	for i,v in ipairs(self.missiles) do
		v:draw(dt)
	end
end

function enemy.wizard:fireMissile()
	local ox,oy = self:getOrbPoint()
	local x,y = player.x-ox, player.y - (oy)
	local theta
	if self.missileGravity ~= 0 then
		theta = math.atan2(-self.missileSpeed^2 + (self.missileSpeed^4+self.missileGravity*(-self.missileGravity*x*x+2*y*self.missileSpeed^2) )^0.5,(self.missileGravity*x))
	else
		theta = math.atan2(y,x)
	end
	table.insert(self.missiles,iceMissile.make{x=ox,y=oy,speed=self.missileSpeed,angle=theta, ygrav=self.missileGravity})
end

function enemy.wizard:turn()
	self.xspeed = -self.xspeed
	if self.pic == wizardpics.left then
		self.pic = wizardpics.right
	else
		self.pic = wizardpics.left
	end
end

function enemy.wizard:getHurt(damage,typ,countdown,hurtatts,deathatts)
	self.health = self.health - 1
	
	if self.health <= 0 then
		player.xp = player.xp + self.xp
		self:die(typ,countdown,deathatts)
		return
	end

	if type(hurtatts) == 'table' then
		self.ygravity = hurtatts.ygravity or self.ygravity
		self.yspeed = hurtatts.yspeed or self.yspeed
		self.xspeed = hurtatts.xspeed or self.xspeed
	end
end


function enemy.wizard:die(type,countdown,atts)
	self.health = 0

	self.killed.type = type or 'inexplicable'
	self.killed.countdown = countdown or 0

	atts = atts or {}
	self.ygravity = atts.ygravity or 0
	self.yspeed = atts.yspeed or 0
	self.xspeed = atts.xspeed or 0
	
	player.xp = player.xp + self.xp
	local rand = math.random()
	if rand < 0.5 then
		--enemydrop.make{x=self.x,y=self.y,type='arrow',physics=true,ygrav=4,yspeed=-50,mass=10,yoffset=-10,bounce=0.5,value=5,width=60,height=30,boxcolor={60,150,200},wait=1}
	else
		--enemydrop.make{x=self.x,y=self.y,type='health',physics=true,ygrav=4,yspeed=50,mass=10,yoffset=-10,bounce=0.5,value=2,width=30,height=30,boxcolor={255,255,200},wait = 1}
	end
end

function enemy.wizard:getCollisionBox()
	return self.x-self.actualwidth/2,self.y-self.actualheight, self.actualwidth, self.actualheight
end

function enemy.wizard:getBoundingBox()
	return self.x-self.drawwidth/2,self.y-self.drawheight,self.drawwidth,self.drawheight
end

function enemy.wizard:getHeadBox()
	return self.x-self.drawwidth*(49-38)/98, self.y - self.drawheight*(353-49)/353, self.drawwidth*(74-38)/98, self.drawheight*(82-49)/353
end

function enemy.wizard:getOrbPoint()
	local l,t = self:getBoundingBox()
	return l+self.drawwidth*(90)/98, t + self.drawheight*(45)/353
end
