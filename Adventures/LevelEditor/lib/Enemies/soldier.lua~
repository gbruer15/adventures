
enemy.soldier = {}
enemy.soldier.__index = enemy.soldier

function enemy.soldier.load()

	soldierpics = {left = love.graphics.newImage("Enemy Pics/Soldiers/facing left.png"),right = love.graphics.newImage("Enemy Pics/Soldiers/facing right.png")}
	soldierpics.pic = soldierpics.right
	soldierpics.width = soldierpics.left:getWidth()
	soldierpics.height = soldierpics.left:getHeight()
	
	
end

function enemy.soldier.make(atts)
	local s = createObject{x = atts.x,y=atts.y,mass=atts.mass or 50, ygrav=atts.ygrav or 5, yspeed=atts.yspeed or 0, xspeed=atts.xspeed or 10}

	setmetatable(s,enemy.soldier)

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
	
	s.health = 1
	
	table.insert(level[player.location].allsoldiers,s)
	return s

end



function enemy.soldier:update(dt)
	self.former = {x=self.x,y=self.y}

	if self.killed.countdown then
		v.xspeed = 0
	end
	updateObject(self, dt)	
	
	if self.killed.countdown then
		self.killed.countdown = self.killed.countdown - dt
		if self.killed.countdown <= 0 then
			self.destroy = true
		end
	end

	if self.killed.countdown then return end

	for j,rect in pairs(level[player.location].blocks) do
		if collision.rectangles(rect.x, rect.y, rect.width,rect.height, self.x - self.actualwidth/2, self.y - self.actualheight * 0.95, self.actualwidth , self.actualheight) then
			if rect.type == "grassydirt" or rect.type == "dirt" then
				local direction = collision.direction.rectangles(self.former.x - self.actualwidth/2,self.former.y-self.actualheight*0.95, self.actualwidth, self.actualheight, rect.x, rect.y, rect.width,rect.height)
				if direction == "right" then
					self.x = rect.x + rect.width + self.actualwidth/2
					self.xspeed = math.abs(self.xspeed)
				elseif direction == "left" then
					self.x = rect.x - self.actualwidth/2 
					self.xspeed = -math.abs(self.xspeed)
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
		if self.xspeed > 0 then
			love.graphics.draw(soldierpics.right, self.x-self.drawwidth/2, self.y-self.drawheight*0.95,0,self.drawwidth/soldierpics.width, self.drawheight/soldierpics.height)
		else
			love.graphics.draw(soldierpics.left, self.x-self.drawwidth/2, self.y-self.drawheight*0.95,0,self.drawwidth/soldierpics.width, self.drawheight/soldierpics.height)
		end
	elseif self.xspeed > 0 then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(soldierpics.right, self.x-self.drawwidth/2, self.y-self.drawheight*0.95,0,self.drawwidth/soldierpics.width, self.drawheight/soldierpics.height)
	else
		love.graphics.setColor(255,255,255)
		love.graphics.draw(soldierpics.left, self.x-self.drawwidth/2, self.y-self.drawheight*0.95,0,self.drawwidth/soldierpics.width, self.drawheight/soldierpics.height)
	end
end
