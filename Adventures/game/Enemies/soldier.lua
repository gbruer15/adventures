
enemy.soldier = {}
enemy.soldier.__index = enemy.soldier
enemy.soldier.type = "soldier"

function enemy.soldier.load()

	soldierpics = {left = love.graphics.newImage("Art/Enemy Pics/Soldiers/facing left.png"),right = love.graphics.newImage("Art/Enemy Pics/Soldiers/facing right.png")}
	soldierpics.width = soldierpics.left:getWidth()
	soldierpics.height = soldierpics.left:getHeight()
	
end

function enemy.soldier.make(atts)
	local s = createObject{x = atts.x,y=atts.y,mass=atts.mass or 50, ygrav=atts.ygrav or 5, yspeed=atts.yspeed or 0, xspeed=atts.xspeed or 10}

	setmetatable(s,enemy.soldier)
	s.metatable = 'enemy.soldier'
	s.type = 'soldier'
	if s.xspeed > 0 then
		s.pic = soldierpics.right
	else
		s.pic = soldierpics.left
	end
	
	s.killed = {}
	s.killed.type = false
	s.killed.countdown = false
	
	if atts.drawwidth then
		s.drawwidth = atts.drawwidth
		s.drawheight = atts.drawheight or s.drawwidth*soldierpics.height/soldierpics.width
	else
		s.drawheight = atts.drawheight or 180
		s.drawwidth = s.drawheight * soldierpics.width/soldierpics.height
	end

	s.xp = atts.xp or 1

	s.actualwidth = 0.85 * s.drawwidth
	s.actualheight = 15/23 * s.drawheight
	
	s.spearhead = {}
	s.spearhead.width,s.spearhead.height = 12*s.drawwidth/soldierpics.width , 16*s.drawwidth/soldierpics.width
	s.spearhead.xoffset, s.spearhead.yoffset = s.drawwidth/2 - 4*s.drawwidth/soldierpics.width,-s.drawheight*0.95

	s.head = {}
	s.head.width, s.head.height = s.actualwidth, s.actualheight*40/160
	s.head.xoffset, s.head.yoffset = -s.actualwidth/2, -s.actualheight*0.95 

	s.health = 1
	
	currentLevel.numSoldiers = currentLevel.numSoldiers + 1
	s.allindex = currentLevel.numSoldiers

	currentLevel.allsoldiers[s.allindex] = s
	
	return s

end



function enemy.soldier:update(dt)
	self.former = {x=self.x,y=self.y}

	if self.killed.countdown then
		self.xspeed = 0
	end
	updateObject(self, dt)	
	
	if self.killed.countdown then
		self.killed.countdown = self.killed.countdown - dt
		if self.killed.countdown <= 0 then
			self.destroy = true
		end
	end

	if self.killed.countdown then return end

	for j,rect in pairs(currentLevel.blocks) do
		if collision.rectangles(rect.x, rect.y, rect.width,rect.height, self.x - self.actualwidth/2, self.y - self.actualheight * 0.95, self.actualwidth , self.actualheight) then
			if not rect.permeable then
				local direction = collision.direction.rectangles1(self.former.x - self.actualwidth/2,self.former.y-self.actualheight*0.95, self.actualwidth, self.actualheight,self.xspeed,self.yspeed, rect.x, rect.y, rect.width,rect.height,0,0)
				if direction == "right" then
					self.x = rect.x + rect.width + self.actualwidth/2
					self:turn()
					--self.xspeed = math.abs(self.xspeed)
				elseif direction == "left" then
					self.x = rect.x - self.actualwidth/2 
					self:turn()
					--self.xspeed = -math.abs(self.xspeed)
				elseif direction=="top"  then
					self.y = rect.y - self.actualheight*0.05 - 0.1   -- is this 0.1 necessary
					self.yspeed = 0
				elseif direction == "bottom"  then
					self.yspeed = 0
					self.y = rect.y + rect.height + self.actualheight * 0.95
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


function enemy.soldier:draw()
	if self.killed.type then
		love.graphics.setColor(255,255,255,self.killed.countdown * 255)
	else
		love.graphics.setColor(255,255,255)
	end
	love.graphics.draw(self.pic, self.x-self.drawwidth/2, self.y-self.drawheight*0.95,0,self.drawwidth/soldierpics.width, self.drawheight/soldierpics.height)
	
end

function enemy.soldier:getCollisionBox()
	return self.x-self.actualwidth/2,self.y-self.actualheight*0.95, self.actualwidth, self.actualheight
end

function enemy.soldier:getHeadBox()
	return self.x-self.actualwidth/2, self.y - self.actualheight*0.95, self.actualwidth, self.actualheight*40/160
end


function enemy.soldier:getSpearHeadBox(x,y)
	x,y = x or self.x, y or self.y
	if self.xspeed > 0 then
		left = x - self.drawwidth/2 + 4*self.drawwidth/soldierpics.width
	else
		left = x + self.drawwidth/2 - 16*self.drawwidth/soldierpics.width
	end
	return left, y - self.drawheight*0.95 , 12*self.drawwidth/soldierpics.width , 16*self.drawwidth/soldierpics.width, self.xspeed, self.yspeed
end

function enemy.soldier:turn()
	self.xspeed = -self.xspeed
	if self.pic == soldierpics.left then
		self.pic = soldierpics.right
	else
		self.pic = soldierpics.left
	end
end

function enemy.soldier:die(type,countdown,atts)
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
