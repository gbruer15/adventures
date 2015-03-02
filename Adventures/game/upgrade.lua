

upgradescreen = {}

function upgradescreen.load() 
	upgradescreen.width = window.width*0.8
	upgradescreen.height = (window.height-hud.height)*0.9
	upgradescreen.x = window.width/2-upgradescreen.width/2
	upgradescreen.y = (window.height-hud.height)/2 + hud.height-upgradescreen.height/2

	upgradescreen.hspace = 40
	upgradescreen.vspace = 35

	upgradescreen.bwidth = (upgradescreen.width - upgradescreen.hspace*4)/3
	upgradescreen.bheight = 120

	upgradescreen.titlefont = defaultfont[48]
	upgradescreen.descriptionfont = impactfont[20]

	upgrade.namefont = neographfont[22]
	upgrade.costfont = impactfont[20]
	upgrade.cnfont = neographfont[20]
	upgradescreen.upgrades = {}

	upgradescreen.pages = {}
	table.insert(upgradescreen.pages, {title="General",upgrades={upgrade.make("Max Health", "Increase your total Hit Points", {10,15,21,29,39,41,55,71,89,109,131,154,180}, {1,2,2,3,3,3,4,4,4,4,5,5,5}, "maxhp"),upgrade.make("Jump Height", "Increase your jump height", {1,1.4,2,2.5,3,3.8}, {5,6,7,8,9,9}, "jumpability"),upgrade.make("# of Jumps", "Increase your number of jumps", {1,2,3,4}, {1,3,5,7}, "maxjumps"),upgrade.make("Speed", "Increase your speed", {30,37,44,51,58,65}, {2,3,5,7,10,12}, "speed")}}) 
	--upgrade.make("Quiver Size","Get more room for arrows!", {0,4,10,15,20,30,50,100,100,100,100,100,100,100,100,100,100,100,100},{1,2,3,4,5,6,7,8,9,10,5,5,5,5,5,5,5,5,5},"maxnumberofarrows")} }
	table.insert(upgradescreen.pages, {title="General",upgrades={upgrade.make("Swimming", "Increase your swimming prowess", {1,4,7,10,13,16,19,22,25,28,30,50}, {1,2,3,4,5,6,7,8,8,8,9,9,9,9,9,9,9}, "wateragility"),upgrade.make("Lungs", "Increase your lung capacity", {10,20,35,55,80,110}, {1,2,3,4,5,6,7,8,8,8,9}, "maxoxygenlevel"),upgrade.make("Breathe Rate", "Increase the rate at which you breathe", {2,4,5,6,7,8,9,10,12,15,20}, {1,2,3,4,5,6,7,8,8,9,10}, "breatherate") }})

	upgradescreen.curpage = 1

	upgradescreen.arrowwidth = 100
	upgradescreen.arrowheight = upgradescreen.arrowwidth*weapons.arrow.picheight/weapons.arrow.picwidth
	upgradescreen.buttons = {}
	upgradescreen.buttons.back = button.make{text="Return to Pause Menu", font = neographfont[22], x=upgradescreen.x+upgradescreen.width-neographfont[22]:getWidth("Return to Pause Menu")-27, y = upgradescreen.y+upgradescreen.height-neographfont[22]:getHeight() - 12, shadow = {x=3,y=3}, selectedcolor = {255,255,255}}
	upgradescreen.buttons.left = button.make{text="", x=upgradescreen.x+5, y = upgradescreen.y+upgradescreen.height-upgradescreen.arrowheight-5,width=upgradescreen.arrowwidth,height=upgradescreen.arrowheight, shadow = {x=3,y=3}, selectedcolor = {255,255,255}, image=leftarrow.pic}

	upgradescreen.buttons.right = button.make{text="", x=upgradescreen.x+50+upgradescreen.arrowwidth, y = upgradescreen.y+upgradescreen.height-upgradescreen.arrowheight-5,width=upgradescreen.arrowwidth,height=upgradescreen.arrowheight, shadow = {x=3,y=3}, selectedcolor = {255,255,255}, image=weapons.arrow.pic}

end
function upgradescreen.make()
	local s = setmetatable({}, {__index = upgradescreen})
	s.metatable = 'upgradescreen'
	return s
end

function upgradescreen:update(dt)
	local mx, my = love.mouse.getPosition()
	self.uhover = nil
	for i,v in pairs(self.pages[self.curpage].upgrades) do
		local bx = i - math.floor((i-1)/3)*3-1
		local by = math.floor((i-1)/3)
		bx = self.x+self.hspace + bx*(self.bwidth+self.hspace)
		by = self.y+by*(self.bheight+self.vspace)+100
		if collision.pointRectangle(mx,my,bx, by, self.bwidth,self.bheight) then
			self.uhover = v
			break
		end
	end

	for i,b in pairs(self.buttons) do
		b:update()
	end
	if self.curpage == 1 then
		self.buttons.left.hover = false
	elseif self.curpage == #self.pages then
		self.buttons.right.hover = false
	end
end

function upgradescreen:draw()

	drawBlur.rectangle(self.x,self.y,self.width,self.height,8,{0,0,0,250}, {0,0,0,0},2)


	love.graphics.setColor(255,255,40)
	--love.graphics.rectangle("fill",self.x, self.y, self.width, self.height)

	love.graphics.setColor(255,255,255)
	tileDraw.image(stonebrick.pic,self.x,self.y,self.width,self.height, 100, 100)


	local width,height = self.titlefont:getWidth("Upgrades!")+20,self.titlefont:getHeight()+10

	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",2+self.x+20,2+self.y+10,width,height)

	love.graphics.setColor(150,180,150)
	tileDraw.image(stonebrick.pic,self.x+20,self.y+10,width,height, 50, 50)

	love.graphics.setColor(255,100,100)
	love.graphics.setFont(self.titlefont)
	love.graphics.printf("Upgrades!", self.x+20, self.y+10, width, "center")

	love.graphics.setColor(0,0,100)
	love.graphics.rectangle("fill",self.x+self.width/2+20, self.y+24,240,46)
	
	love.graphics.setColor(255,200,200)
	love.graphics.setFont(self.descriptionfont)
	love.graphics.printf("Upgrade Points: " .. player.upoints, self.x+self.width/2+20, self.y+34, 240, "center")

	love.graphics.setLineWidth(3)
	for i,v in ipairs(self.pages[self.curpage].upgrades) do
		local bx = i - math.floor((i-1)/3)*3-1
		local by = math.floor((i-1)/3)
		bx = self.x+self.hspace + bx*(self.bwidth+self.hspace)
		by = self.y+by*(self.bheight+self.vspace)+100
		love.graphics.setColor(200,200,200)
		love.graphics.rectangle("fill",bx, by, self.bwidth,self.bheight)

		love.graphics.setColor(0,0,0,200)
		love.graphics.rectangle("line",bx, by, self.bwidth,self.bheight)

		love.graphics.setFont(v.namefont)
		love.graphics.setColor(0,0,0)--love.graphics.setColor(100,200,79)
		love.graphics.printf(v.name, bx, by, self.bwidth, 'center')

		love.graphics.setFont(v.costfont)
		love.graphics.setColor(100,50,255)
		if v.level < #v.values then
			love.graphics.printf("Cost: " .. v.costs[v.level],bx, by+v.namefont:getHeight(), self.bwidth, 'center')
		end

		love.graphics.setColor(180,40,255)
		love.graphics.setFont(v.cnfont)
		love.graphics.printf("Current: " .. v.values[v.level], bx, by+v.namefont:getHeight()+v.costfont:getHeight(), self.bwidth, 'center')

		love.graphics.setColor(180,40,255)
		if v.level < #v.values then
			love.graphics.printf("Next: " .. v.values[v.level+1], bx, by+v.namefont:getHeight()+v.costfont:getHeight() + v.cnfont:getHeight(), self.bwidth, 'center')
		else
			love.graphics.printf("Maxed out", bx, by+v.namefont:getHeight()+v.costfont:getHeight() + v.cnfont:getHeight(), self.bwidth, 'center')
		end

		if v.level >= #v.values then
			love.graphics.setColor(100,100,100,100)
			love.graphics.rectangle("fill", bx,by, self.bwidth,self.bheight)
		elseif v.costs[v.level] > player.upoints then
			love.graphics.setColor(200,0,0,100)
			love.graphics.rectangle("fill", bx,by,self.bwidth,self.bheight)
		else
			love.graphics.setColor(0,200,0,100)
			love.graphics.rectangle("fill", bx,by,self.bwidth,self.bheight)
		end
	end

	for i,b in pairs(self.buttons) do
		b:draw()
	end

	love.graphics.setColor(0,0,0)
	if self.curpage == 1 then
		love.graphics.draw(self.buttons.left.image, self.buttons.left.x,self.buttons.left.y, 0,self.buttons.left.width/self.buttons.left.imagewidth,self.buttons.left.height/self.buttons.left.imageheight)
	elseif self.curpage == #self.pages then
		love.graphics.draw(self.buttons.right.image, self.buttons.right.x,self.buttons.right.y, 0,self.buttons.right.width/self.buttons.right.imagewidth,self.buttons.right.height/self.buttons.right.imageheight)
	end

	if self.uhover then
		love.graphics.setColor(0,155,70)
		love.graphics.setFont(self.descriptionfont)
		--love.graphics.print(self.uhover.description, self.x+self.width-300, self.y+self.height-100)
		love.graphics.printf(self.uhover.description, self.x, self.y+self.height-60, self.width, "center")
		--love.graphics.print("Cost: " .. self.uhover.costs[self.uhover.level],self.x+self.width-300, self.y+self.height-100 + self.descriptionfont:getHeight()+5)
	end
end

function upgradescreen:mousepressed(x,y,button)
	if button == 'l' then
		for i,b in pairs(self.buttons) do
			if b.hover then
				b.selected = true
				b.x,b.y = b.x+2,b.y+2
				b.shadow.x,b.shadow.y = 1,1
			end
		end

		if self.uhover then
			self.uhover:clicked()
			return
		end
	end
end
function upgradescreen:mousereleased(x,y,button)
	if button =='l' then
		for i,b in pairs(self.buttons) do
			if b.selected then
				if b.hover then
					if i == 'back' then
						pausedscreen.showupgrades = false
					elseif i == 'left' and self.curpage > 1 then
						self.curpage = self.curpage - 1
					elseif i == 'right' and self.curpage < #self.pages then
						self.curpage = self.curpage + 1
					end
				end
				b.selected = false
				b.x,b.y = b.x-2,b.y-2
				b.shadow.x,b.shadow.y = 3,3
			end
		end
	end
end

upgrade = {}

function upgrade.make(name,description, values, costs, playerkey, namefont)
	local s = setmetatable({},{__index=upgrade})

	s.name = name
	s.namefont = namefont
	s.namewidth = s.namefont:getWidth(s.name)

	s.values = values
	s.costs = costs

	s.playerkey = playerkey
	s.description = description
	if player[s.playerkey] == nil then
		error("player." .. tostring(s.playerkey) .. " does not exist.d")
	end

	for i,v in ipairs(s.values) do
		if v == player[s.playerkey] then
			s.level = i
			break
		end
	end
	if s.level == nil then
		error("Player value of " .. player[s.playerkey] .. " for " .. s.name .. "is not optional for this upgradable. Change the value of player." .. playerkey .. " to a valid number.")
	end
	

	return s
end

function upgrade:clicked()

	if self.level < #self.values --[[ and player.upoints >= self.costs[self.level] ]] then
		player.upoints = player.upoints - self.costs[self.level]

		self.level = self.level+1
		player[self.playerkey] = self.values[self.level]

		if self.playerkey == 'maxhp' then
			player.hp = math.ceil(player.hp*player.maxhp/self.values[self.level-1])
		elseif self.playerkey == 'wateragility' then
			player.buoyancy = player.wateragility/player.maxwateragility*(player.maxbuoyancy-player.minbuoyancy) + player.minbuoyancy
		end
	end


end
