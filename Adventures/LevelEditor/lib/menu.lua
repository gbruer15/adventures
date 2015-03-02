


menu = {}
menu.__index = menu
menus = {}
menu.onmenus = {}
function menu.make(items,font,width,height,linespacing)
	local m = {}
	setmetatable(m,menu)
	
	local n = {}
	for i=1,#items do
		table.insert(n,i)
	end
	for i,v in pairs(items) do
		if type(v) ~= 'string' then
			if type(v) ~= 'table' or (type(v) == 'table' and v.type ~= 'menu') then
				error("Incorrect Item Data Type for Menu: Key " .. i)
			end
		end
		if type(i) ~= 'number' then
			items[n[1]] = v
			table.remove(items,i)
		elseif i < 1 or i > #items then
			items[n[1]] = v
			table.remove(items,i)
		else
			table.remove(n,i)
		end
	end
	m.items = items
	
	m.font = font or love.graphics.newFont(12)
	m.linespacing = linespacing or 4
	m.textheight = m.font:getHeight() + m.linespacing
	
	m.x,m.y = x or 0, y or 0
	
	m.width,m.height = width or 'auto',height or 'auto'
	if m.width == 'auto' then
		local mwidth = 0
		for i,v in ipairs(m.items) do
			if type(v) == 'string' then
				mwidth = math.max(mwidth,m.font:getWidth(v))
			else
				mwidth = math.max(mwidth,m.font:getWidth(v.title))
			end
		end
		m.width = mwidth + 9
	end
	if m.height == 'auto' then
		m.height = (m.textheight)*#m.items + m.linespacing
	end
	m.on = false
	
	m.type = 'menu'

	table.insert(menus,m)
	return m
end

function menu:draw()
	if self.on then
	---- shadow
		love.graphics.setColor(0,0,0,128)
		love.graphics.rectangle('fill',self.x+4,self.y+4,self.width,self.height)
	---- box
		love.graphics.setColor(150,150,150)
		love.graphics.rectangle('fill',self.x, self.y, self.width,self.height)
		love.graphics.setColor(100,100,100)
		love.graphics.setLineWidth(2)
		love.graphics.rectangle('line',self.x+1,self.y+1,self.width - 2,self.height - 2)
		
		
		local height = self.font:getHeight()
		if self.hover and menu.onmenus[1] == self then
			love.graphics.setColor(220,0,220)
			love.graphics.rectangle('fill', self.x+3,self.y + (self.textheight)*(self.hover-1)+self.linespacing/2 + 2, self.width-6,self.textheight-4)
		end
		love.graphics.setFont(self.font)
		love.graphics.setColor(255,255,255)
		
		
		for i=1,#self.items do
			if type(self.items[i]) == 'string' then
				love.graphics.print(self.items[i], self.x+4,self.y + (self.textheight)*(i-1)+self.linespacing)
			elseif type(self.items[i]) == 'table' then
				love.graphics.print(self.items[i].title, self.x+4,self.y+(self.textheight)*(i-1)+self.linespacing)
			end
		end
	end
	
end

function menu:update()
	local x,y = love.mouse.getPosition()
	if self.on then
		if collision.pointRectangle(x,y,self.x,self.y,self.width,self.height) then
			self.hover = math.ceil((y-self.y)/(self.textheight))
			if self.hover > #self.items then
				self.hover = #self.items
			elseif self.hover < 1 then
				self.hover = 1
			end
		else
			self.hover = false
		end
	end
end

function menu.updateAll()
	local x,y = love.mouse.getPosition()
	for i=1,#menu.onmenus do
		local self = menu.onmenus[i]
		self:update()
	end
end

function menu.drawAll()
	for i,v in pairs(menus) do
		v:draw()
	end
end

function menu:addItem(item)
	table.insert(self.items,item)
end

function menu:getRect()
	return self.x,self.y,self.width,self.height
end

function menu:setPosition(x,y)
	self.x,self.y = x,y
end

function menu:show()
	self.on = true
	table.insert(menu.onmenus,1,self)
end

function menu:hide()
	self.on = false
	for i,v in ipairs(menu.onmenus) do
		if v == self then
			table.remove(menu.onmenus,i)
			break
		end
	end
end

function menu:isOn()
	return self.on
end

function menu.anyOn()
	for i,v in pairs(menus) do
		if v.on then
			return v.on
		end
	end
	return false
end
