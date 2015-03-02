
enemydrop = {}

enemydrop.__index = enemydrop

function enemydrop.load()
	enemydroppics = {}

	enemydroppics.arrow = {}
	enemydroppics.arrow.pic = weapons.arrow.pic
	enemydroppics.arrow.width = weapons.arrow.pic:getWidth()
	enemydroppics.arrow.height = weapons.arrow.pic:getHeight()

	enemydroppics.health = {}
	enemydroppics.health.pic = hearts.pic.full
	enemydroppics.health.width = hearts.pic.full:getWidth()
	enemydroppics.health.height = hearts.pic.full:getHeight()


	enemydroplist = {}
end

function enemydrop.make(atts)
	local t
	if atts.physics then
		t = createObject(atts)
		t.physics = true
	else
		t = {}
		t.physics =false
	end
	
	setmetatable(t,enemydrop)
	t.metatable = 'enemydrop'
	
	t.x = atts.x or 0
	t.y = atts.y or 0

	t.x = t.x + (atts.xoffset or 0)
	t.y = t.y + (atts.yoffset or 0)

	t.width = atts.width or 35
	t.height = atts.height or 35

	t.bounce = atts.bounce or 0
	t.type = atts.type or ""

	t.value = atts.value or 0
	t.wait = atts.wait or 0

	t.color = atts.color or {255,255,255}
	t.boxcolor = atts.boxcolor or {90,180,255}
	t.former = {x=t.x,y=t.y}
	table.insert(enemydroplist,t)
	return t
end

function enemydrop:update(dt)

	if self.wait > 0 then self.wait = self.wait - dt end
	if not self.physics then
		return
	end

	self.former.x=self.x
	self.former.y=self.y
	updateObject(self,dt)

	self.inwaterwidth,self.inwaterheight = 0,0
	for j,rect in pairs(currentLevel.blocks) do
		if collision.rectangles(rect.x, rect.y, rect.width,rect.height, self.x - self.width/2, self.y - self.height/2 , self.width , self.height) then
			if not rect.permeable then --rect.type == "grassydirt" or rect.type == "dirt" then
				--local direction = collision.direction.rectangles(self.former.x - self.width/2,self.former.y-self.height/2, self.width, self.height, rect.x, rect.y, rect.width,rect.height)
				local direction = collision.direction.rectangles2(self.x - self.width/2,self.y-self.height/2, self.width, self.height,self.xspeed,self.yspeed, rect.x, rect.y, rect.width,rect.height,0,0)
				if direction == "right" and self.groundy ~= rect.y then
					self.x = rect.x + rect.width + self.width/2
					self.xspeed = math.abs(self.xspeed)*self.bounce
				elseif direction == "left" and self.groundy ~= rect.y then
					self.x = rect.x - self.width/2 
					self.xspeed = -math.abs(self.xspeed)*self.bounce
				elseif direction == "top"  then
					self.y = rect.y - self.height/2
					self.yspeed = -math.abs(self.yspeed)*self.bounce
					self.groundy = rect.y
				elseif direction == "bottom"  then
					self.yspeed = math.abs(self.yspeed)*self.bounce
					self.y = rect.y + rect.height + self.height/2
				end
			elseif rect.type == 'water' then
				--[[v.xspeed = v.speed * 0.55
				if v.yspeed > 0 then
					v.yspeed = v.yspeed - v.yspeed * dt * 10
				else
					v.yspeed = v.yspeed *0.99
				end --]]
				local xo, yo = collision.rectanglesOverlap(self.x-self.width/2, self.y-self.height/2, self.width, self.height, rect.x,rect.y,rect.width, rect.height)
				self.inwaterwidth = self.inwaterwidth + xo
				self.inwaterheight = self.inwaterheight + yo
				self.inwater = true
			end
		end
	end

end


function enemydrop:draw()

	local blurwidth = 5
	drawBlur.rectangle(self.x-self.width/2+blurwidth,self.y-self.height/2+blurwidth,self.width-2*blurwidth,self.height-blurwidth*2,blurwidth,{100,100,100},{255,255,255,0})
	love.graphics.setLineWidth(2)

	love.graphics.setColor(100,100,100)
	love.graphics.rectangle("line", self.x-self.width/2+blurwidth,self.y-self.height/2+blurwidth,self.width-2*blurwidth,self.height-2*blurwidth)

	love.graphics.setColor(self.boxcolor)
	love.graphics.rectangle("fill", self.x-self.width/2+blurwidth,self.y-self.height/2+blurwidth,self.width-2*blurwidth,self.height-blurwidth*2)

	love.graphics.setColor(self.color)
	if enemydroppics[self.type] then
		love.graphics.draw(enemydroppics[self.type].pic,self.x-self.width/2+blurwidth,self.y-self.height/2+blurwidth,self.rotation,(self.width-2*blurwidth)/enemydroppics[self.type].width,(self.width-2*blurwidth)/enemydroppics[self.type].width)
	else
		love.graphics.rectangle("fill",self.x-self.width/2+blurwidth,self.y-self.height/2+blurwidth,(self.width-2*blurwidth),(self.height-2*blurwidth))
	end
end
