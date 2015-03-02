 
 
 ----------------------------------------------------------------------------
button = {}
button.__index = button
buttonpic = love.graphics.newImage("Misc Pics/button.png")
buttonpicwidth = buttonpic:getWidth()
buttonpicheight = buttonpic:getHeight()

buttonoutlinepic = love.graphics.newImage("Misc Pics/button outline.png")
buttonsmalloutlinepic = love.graphics.newImage("Misc Pics/button small outline.png")
function button.make(att) --att stands for attributes
	local b = {}
	setmetatable(b, button)
	b.metatable = 'button'
	
	b.x,b.y = att.x or 0, att.y or 0
	b.text = att.text or ""
	b.textcolor = att.textcolor or {255,255,255}
	b.font = att.font or love.graphics.newFont(12)
	b.textheight = b.font:getHeight()
	b.textwidth = b.font:getWidth(b.text)	
	
	b.width,b.height = att.width or b.textwidth+25,att.height or b.textheight+8
	b.image = att.image or buttonpic
	b.imagewidth = b.image:getWidth()
	b.imageheight = b.image:getHeight()
	b.shadow = att.shadow
	b.imagecolor = att.imagecolor or {255,255,255}
	
	b.dark = {}
	for i,v in ipairs(b.imagecolor) do
		table.insert(b.dark,v*200/255)
	end
	
	b.selectedcolor = att.selectedcolor or {255,255,0}
	if b.shadow then
		b.shadow.x = b.shadow.x or 3
		b.shadow.y = b.shadow.y or 3
		b.shadow.width = b.shadow.width or 0
		b.shadow.height = b.shadow.height or 0
	end
	
	
	b.hover = false
	return b
end
 
function button:changeText(newtext)
	self.text = newtext
	self.textwidth = self.font:getWidth(self.text)	
end

function button:update()
	local x,y = love.mouse.getPosition()
	if collision.pointRectangle(x,y,self.x,self.y,self.width,self.height) then
		self.hover = true
	else
		self.hover = false
	end

end
 
function button:draw()
	if self.shadow then 
		love.graphics.setColor(0,0,0)
		love.graphics.draw(self.image,self.x+self.shadow.x,self.y+self.shadow.y,0,(self.width+self.shadow.width)/self.imagewidth,(self.height+self.shadow.height)/self.imageheight)
	end
	
	if self.selected then
		love.graphics.setColor(unpack(self.selectedcolor))
	elseif self.hover then
		love.graphics.setColor(unpack(self.imagecolor))
	else
		love.graphics.setColor(unpack(self.dark))
	end
	love.graphics.draw(self.image,self.x,self.y,0,self.width/self.imagewidth,self.height/self.imageheight)	
	

	
	love.graphics.setFont(self.font)
	love.graphics.setColor(unpack(self.textcolor))
	love.graphics.print(self.text, self.x+self.width/2 - self.textwidth/2, self.y + self.height/2 - self.textheight/2)
end



----------------------------------------------------------------------------
slider = {}
slider.__index = slider
function slider.make(att) --att stands for attributes
	local s = {}
	setmetatable(s, slider)
	s.metatable = 'slider'
	
	s.x,s.y = att.x or 0, att.y or 0
	s.text = att.text or ""
	s.textcolor = att.textcolor or {255,255,255}
	s.font = att.font or love.graphics.newFont(12)
	s.textheight = s.font:getHeight()
	s.textwidth = s.font:getWidth(s.text)	
	
	s.width,s.height = att.width or 300,att.height or 20
	s.image = att.image or sliderpic.pic
	s.imagewidth = s.image:getWidth()
	s.imageheight = s.image:getHeight()
	s.shadow = att.shadow
	if s.shadow then
		s.shadow.x = s.shadow.x or 3
		s.shadow.y = s.shadow.y or 3
		s.shadow.width = s.shadow.width or 0
		s.shadow.height = s.shadow.height or 0
	end
	
	s.arrowpic = att.sliderpic or sliderpic.arrowpic
	s.arrowpicheight = s.arrowpic:getHeight()
	s.arrowpicwidth = s.arrowpic:getWidth()
	s.arrowheight = att.height or 30
	s.arrowwidth = att.width or 15
	
	s.color = att.color or {255,255,255}
	s.value = att.value or 0
	s.round = att.round
	s.hover = false
	s.mouseoffx = 0
	
	s.multiplyer = att.multiplyer or 100
	s.multiplyerwidth = s.font:getWidth(s.multiplyer)
	
	return s
end

function slider:update()
	local x,y = love.mouse.getPosition()
	if collision.pointRectangle(x,y,self.x,self.y,self.width,self.height) then
		self.hover = true
	else
		self.hover = false
	end
	if self.selected and love.mouse.isDown('l') then
		self.value = (x + self.mouseoffx - self.x)/self.width
		if self.value > 1 then
			self.value = 1
		elseif self.value < 0 then
			self.value = 0
		end
	end
	if self.round then
		self.value = math.round(self.value,self.round)
	end
 end

function slider:draw()
	if self.shadow then
		love.graphics.setColor(0,0,0)
		love.graphics.draw(self.image,self.x+self.shadow.x,self.y+self.shadow.y,0,(self.width+self.shadow.width)/self.imagewidth,(self.height+self.shadow.height)/self.imageheight)			
	end
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.x,self.y,self.width,self.height)
	
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.image,self.x,self.y,0,self.width/self.imagewidth,self.height/self.imageheight)	
	
	if not self.hover and not self.selected then
		love.graphics.setColor(200,200,200,200)
		--love.graphics.draw(self.image,self.x,self.y,0,self.width/self.imagewidth,self.height/self.imageheight)	
	elseif self.selected then
		love.graphics.setColor(200,255,0,100)
		--love.graphics.draw(self.image,self.x,self.y,0,self.width/self.imagewidth,self.height/self.imageheight)	
	end

	love.graphics.setColor(255,255,255)
	--love.graphics.rectangle("fill", self.x+self.value*self.width - 1, self.y, 3,self.height)
	love.graphics.draw(self.arrowpic, self.x + self.value*self.width-self.arrowwidth/2, self.y-self.arrowheight*0.6,0,  self.arrowwidth/self.arrowpicwidth, self.arrowheight/self.arrowpicheight)
	
	love.graphics.setFont(self.font)
	love.graphics.setColor(unpack(self.textcolor))
	--love.graphics.print(self.text, self.x+self.width/2 - self.textwidth/2, self.y + self.height)
	love.graphics.print(self.text, self.x, self.y + self.height)
	love.graphics.print(math.round(self.value * self.multiplyer,1),self.x +self.width - self.multiplyerwidth, self.y + self.height )
end



----------------------------------------------------------------------------
drawBlur = {}

function drawBlur.rectangle(x,y,width,height,blurwidth,incolor, outcolor,resolution)

	blurwidth = blurwidth or 10
	incolor = incolor or {0,0,0,255}
	outcolor = outcolor or {0,0,0,0}

	incolor[4] = incolor[4] or 255
	outcolor[4] = outcolor[4] or 255
	
	resolution = resolution or 1
	if resolution <= 0 then
		error("bad argument #8 to function drawBlur.rectangle: resolution must be greater than 0")
	end
	--multipliers
	local rmult = (incolor[1]-outcolor[1])/blurwidth
	local gmult = (incolor[2]-outcolor[2])/blurwidth
	local bmult = (incolor[3]-outcolor[3])/blurwidth

	local amult = (incolor[4]-outcolor[4])/blurwidth
	love.graphics.setLineWidth(resolution)
	for i=0,blurwidth,resolution do
		love.graphics.setColor(rmult*i+outcolor[1],gmult*i+outcolor[2],bmult*i+outcolor[3],amult*i+outcolor[4])
		love.graphics.rectangle("line", x-(blurwidth-i),y-(blurwidth-i),width+2*(blurwidth-i),height+2*(blurwidth-i))
	end
end


function drawBlur.circle(x,y,inradius,nseg,blurwidth,incolor, outcolor,resolution)

	blurwidth = blurwidth or 10
	incolor = incolor or {0,0,0,255}
	outcolor = outcolor or {0,0,0,0}

	incolor[4] = incolor[4] or 255
	outcolor[4] = outcolor[4] or 255

	resolution = resolution or 1
	if resolution <= 0 then
		error("bad argument #7 to function drawBlur.circle: resolution must be greater than 0")
	end

	--multipliers
	local rmult = (incolor[1]-outcolor[1])/blurwidth
	local gmult = (incolor[2]-outcolor[2])/blurwidth
	local bmult = (incolor[3]-outcolor[3])/blurwidth
	local amult = (incolor[4]-outcolor[4])/blurwidth
	love.graphics.setLineWidth(resolution)
	for i=0,blurwidth,resolution do
		love.graphics.setColor(rmult*i+outcolor[1],gmult*i+outcolor[2],bmult*i+outcolor[3],amult*i+outcolor[4])
		love.graphics.circle("line", x,y,inradius + blurwidth-i,nseg)
	end
end

function drawBlur.image(image,centerx,centery,width,height,blurwidth,incolor, outcolor,resolution)
	
	local iwidth,iheight = image:getWidth(), image:getHeight()
	blurwidth = blurwidth or 10
	incolor = incolor or {0,0,0,255}
	outcolor = outcolor or {0,0,0,0}

	incolor[4] = incolor[4] or 255
	outcolor[4] = outcolor[4] or 255
	
	resolution = resolution or 1
	if resolution <= 0 then
		error("bad argument #11 to function drawBlur.image: resolution must be greater than 0")
	end
	--multipliers
	local rmult = (incolor[1]-outcolor[1])/blurwidth
	local gmult = (incolor[2]-outcolor[2])/blurwidth
	local bmult = (incolor[3]-outcolor[3])/blurwidth
	local amult = (incolor[4]-outcolor[4])/blurwidth

	for i=0,blurwidth,resolution do
		love.graphics.setColor(rmult*i+outcolor[1],gmult*i+outcolor[2],bmult*i+outcolor[3],amult*i+outcolor[4])
		local dwidth = width+blurwidth-i
		local dheight = height+blurwidth-i
		love.graphics.draw(image, centerx-dwidth/2,centery-dheight/2,0,dwidth/iwidth,dheight/iheight)
	end
end

function drawBlur.ellipse(x,y,xd,yd,angle,nseg,blurwidth,incolor,outcolor,resolution)
	--[[
	love.graphics.push()

	love.graphics.translate(x,y)
	love.graphics.rotate(angle)
	if yd>xd then
		love.graphics.scale(xd/yd,1)
		drawBlur.circle(0,0,xd,math.max(yd,10),blurwidth,incolor,outcolor,resolution)
	else
		love.graphics.scale(yd/xd,1)
		drawBlur.circle(0,0,yd,math.max(xd,10),blurwidth,incolor,outcolor,resolution)
	end
	love.graphics.pop()
	--]]
	angle = angle or 0


	blurwidth = blurwidth or 10
	incolor = incolor or {0,0,0,255}
	outcolor = outcolor or {0,0,0,0}

	incolor[4] = incolor[4] or 255
	outcolor[4] = outcolor[4] or 255

	resolution = resolution or 1
	if resolution <= 0 then
		error("bad argument #7 to function drawBlur.circle: resolution must be greater than 0")
	end

	--multipliers
	local rmult = (incolor[1]-outcolor[1])/blurwidth
	local gmult = (incolor[2]-outcolor[2])/blurwidth
	local bmult = (incolor[3]-outcolor[3])/blurwidth
	local amult = (incolor[4]-outcolor[4])/blurwidth
	love.graphics.setLineWidth(resolution)
	for i=0,blurwidth,resolution do
		love.graphics.setColor(rmult*i+outcolor[1],gmult*i+outcolor[2],bmult*i+outcolor[3],amult*i+outcolor[4])
		love.graphics.ellipse("line", x,y,xd+blurwidth-i,yd+blurwidth-i,angle,nseg)
	end
end

----------------------------------------------------------------------------


tiledraw = {}

function tiledraw.image(image, left,top,width,height, tilewidth,tileheight,xoffset,yoffset)
	local iwidth,iheight = image:getWidth(),image:getHeight()

	local xoffset,yoffset = xoffset or 0, yoffset or 0

	local x = left
	local y
	local n = 1
	love.graphics.setScissor(left,top,width,height)
	while x < left+width do
		y = top
		while y < top+height do
			love.graphics.draw(image,x,y,0,tilewidth/iwidth,tileheight/iheight)
			y = y + tileheight
			n = n + 1
		end
		x = x + tilewidth
		
	end

	love.graphics.setScissor()
	return n
end
  
---------------------------------------------------------------------------

love.graphics.oldRectangle = love.graphics.rectangle
function love.graphics.rectangle(dmode,left,top,width,height,ang) --draws a rectangle
	if ang == nil then
		love.graphics.oldRectangle(dmode,left,top,width,height)
		return
	end


	love.graphics.push()

	love.graphics.translate(left,top)
	love.graphics.rotate(ang)
	love.graphics.translate(-left,-top)

	love.graphics.oldRectangle(dmode,left,top,width,height)

	love.graphics.pop()
end

function love.graphics.ellipse(dmode,left,top,xd,yd, angle,nseg) --Draws an ellipse
	
	--[[love.graphics.push()

	xd = math.abs(xd)/2
	yd = (yd and math.abs(yd)/2) or xd

	love.graphics.translate(x,y)

	love.graphics.rotate(angle or 0)
	love.graphics.scale(xd,yd or xd)

	love.graphics.translate(-x,-y)

	love.graphics.circle(dmode,x,y,1,math.max(math.max(xd,yd),10))

	love.graphics.pop()

	angle = angle or 0
	love.graphics.setLineWidth(2)
	love.graphics.setColor(0,0,0)

	--]]
	angle = angle or  0
	love.graphics.push()

	love.graphics.translate(left,top)
	love.graphics.rotate(angle)
	love.graphics.translate(xd/2,yd/2)
	
	local lwidth = love.graphics.getLineWidth()
	if yd>xd then
		love.graphics.scale(1,yd/xd)
		love.graphics.circle(dmode,0,0,xd/2,math.max(xd/2,10))
	else
		love.graphics.scale(xd/yd,1)
		love.graphics.circle(dmode,0,0,yd/2,math.max(yd/2,10))
	end
	love.graphics.pop()
-----------------------------
--[[
	love.graphics.push()

	love.graphics.translate(x,y)
	love.graphics.rotate(angle)
	love.graphics.translate(-x,-y)


	--local xdif, ydif = xd*math.cos(angle), yd*math.sin(angle)
	--love.graphics.line(x+xdif,y+ydif,x-xdif,y-ydif)

	--love.graphics.line(x-xd,y,x+xd,y)
	--love.graphics.line(x,y-yd,x,y+yd)
	love.graphics.pop()
	--]]
end
