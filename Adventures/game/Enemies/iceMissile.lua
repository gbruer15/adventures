
iceMissile = {}
iceMissile.__index = iceMissile

iceMissile.pic = love.graphics.newImage("Art/Weapon Pics/icy comet.png")
iceMissile.picWidth = iceMissile.pic:getWidth()
iceMissile.picHeight = iceMissile.pic:getHeight()

iceMissile.picRadius = iceMissile.picHeight*(81/128)/2
iceMissile.angleToBall = math.atan2(33,290)
iceMissile.magToBall = math.sqrt(290^2 + 33^2)

function iceMissile.make(att)
	local self = {}
	
	self.x = att.x or 0
	self.y = att.y or 0
	
	if att.speed and att.angle then
		self.xspeed = att.speed*math.cos(att.angle)
		self.yspeed = att.speed*math.sin(att.angle)
	else
		self.xspeed = att.xspeed or 5
		self.yspeed = att.yspeed or 5
	end
	
	self = createObject{x = self.x,y=self.y,mass=att.mass or 10, ygrav=att.ygrav or 5, yspeed=self.yspeed, xspeed=self.xspeed}
	
	setmetatable(self,iceMissile)
	
	self.height = att.height or 10
	self.width = att.width or iceMissile.picWidth*self.height/iceMissile.picHeight
	
	self.radius = iceMissile.picRadius*self.width/iceMissile.picWidth
	self.angle = math.atan2(self.yspeed,self.xspeed)
	
	self.drawx = self.x - math.cos(iceMissile.angleToBall + self.angle)*iceMissile.magToBall*self.width/iceMissile.picWidth
	self.drawy = self.y - math.sin(iceMissile.angleToBall + self.angle)*iceMissile.magToBall*self.width/iceMissile.picWidth

	self.moving = true
	
	self.icePower = 1
	
	return self
end

function iceMissile:update(dt)
	if self.destroy then
		return true
	elseif self.life then
		self.life = self.life - dt
		if self.life <= 0 then
			self.destroy = true
			return self.destroy
		end
	end
	
	if not self.moving then
		return
	end
	
	updateObject(self,dt)
	
	self.angle = math.atan2(self.yspeed,self.xspeed)
	
	
	for i,rect in pairs(currentLevel.blocks) do
		if collision.rectangleCircle(rect.x, rect.y, rect.width,rect.height, self:getSnowball()) then
			if not rect.permeable then
				self.moving = false
				self.life = 0.5
			elseif rect.type =='water' then
				local s = (self.xspeed * self.xspeed + self.yspeed * self.yspeed)^0.5
				local ang = math.atan2(self.yspeed,self.xspeed)
				s = s * 0.9
				self.xspeed = math.cos(ang)*s
				self.yspeed = math.sin(ang)*s
			end
		end 
	end --Level Collisions
	
	
end

function iceMissile:draw()
	love.graphics.setColor(255,255,255)
	
	self.drawx = self.x - math.cos(iceMissile.angleToBall + self.angle)*iceMissile.magToBall*self.width/iceMissile.picWidth
	self.drawy = self.y - math.sin(iceMissile.angleToBall + self.angle)*iceMissile.magToBall*self.width/iceMissile.picWidth
	--love.graphics.circle("fill",self.x,self.y,2)
	love.graphics.draw(iceMissile.pic,self.drawx,self.drawy,self.angle, self.width/iceMissile.picWidth,self.height/iceMissile.picHeight)
		
end

function iceMissile:getSnowball()
	return self.x,self.y,self.radius
end
