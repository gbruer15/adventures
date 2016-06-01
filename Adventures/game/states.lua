 
states = {} 

----------------------------------  Title Menu  -------------------------------
-------------------------------------------------------------------------------
states.titlemenu = {}
	function states.titlemenu.load()
		
		if (music.title.music:isStopped() or music.title.music:isPaused()) then
			love.audio.stop()
			music.title.music:setLooping(true)
			
			music.title.music:rewind()
			music.title.music:play()
		end
		
		title = {}
		title.text = "Adventures"
		title.font = defaultfont[64]
		
		title.width = title.font:getWidth(title.text)
		title.height = title.font:getHeight()
		
		title.x = window.width/2 - title.width/2
		title.y = 60
		state = 'titlemenu'

		local x = 20
		local xspacing = 15
		local centery = window.height-50
		buttonshadow = 5
		states.titlemenu.buttons = {}
		states.titlemenu.buttons.play = button.make{text="Play",width=160,height=60,x=window.width/2-160/2,y=window.height*0.5 - 60/2,font=neographfont[48], textcolor ={230,230,230}, selectedcolor = {255,255,255}, shadow = {x=buttonshadow,y=buttonshadow}}
		x = x + 190 + xspacing
		
		states.titlemenu.buttons.options = button.make{text="Options",width=170,height=60,x=x,y=centery - 60/2,font=neographfont[36], textcolor={0,0,0}, selectedcolor = {255,255,255}, shadow = {x=buttonshadow,y=buttonshadow}}
		x = x + 170 + xspacing
		
		--states.titlemenu.buttons.leveleditor = button.make{text="Level Editor",width=160,height=40,x=window.width/2-160/2,y=440,font=defaultfont[24], textcolor={0,0,0}}
		
		states.titlemenu.buttons.quit = button.make{text="Quit",width=160,height=50,x=x,y=centery - 50/2,font=neographfont[28], textcolor={40,0,0}, selectedcolor = {255,255,255}, shadow = {x=buttonshadow,y=buttonshadow}}

	end

	function states.titlemenu.update(dt)
		
		for i,b in pairs(states.titlemenu.buttons) do
			b:update()
		end
	end

	function states.titlemenu.draw()
		
		--love.graphics.setColor(0,162,232)
		--love.graphics.rectangle('fill', 0,0,window.width,window.height)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(titlecastle.pic,0,0,0,window.width/titlecastle.width,window.height/titlecastle.height)
		
		love.graphics.setColor(200,0,150)
		--love.graphics.rectangle("fill", title.x - 100,title.y-20,title.width+200, title.height+40)
		
		love.graphics.setColor(0,0,150)
		love.graphics.setLineWidth(10)
		--love.graphics.rectangle("line", title.x - 100 + 5,title.y-20 + 5,title.width+200-10, title.height+40-10)
		
		love.graphics.setColor(255,255,255)
		love.graphics.setFont(title.font)
		--love.graphics.print(title.text,title.x,title.y)
		
		for i,b in pairs(states.titlemenu.buttons) do
			b:draw()
		end
		
		love.graphics.setColor(255,255,255)
		love.graphics.setFont(defaultfont[24])
		--love.graphics.print("Music mostly by Joel Eaton", 40,270,-math.pi/10)

	end


	function states.titlemenu.mousepressed(x,y,button)
		for i,b in pairs(states.titlemenu.buttons) do
			if b.hover then
				b.selected = true
				b.x = b.x + 2
				b.y = b.y + 2
				b.shadow.x = 1
				b.shadow.y = 1
			end
			
		end
	end

	function states.titlemenu.mousereleased(x,y,button)
		for i,b in pairs(states.titlemenu.buttons) do
			if b.hover and b.selected then
				if i =='play' then
					states.fileselect.load()
				elseif i =='quit' then
					QUIT = true
				elseif i == 'options' then
					states.mainoptions.load()
				end
			elseif b.selected then
				b.selected = false
				b.x = b.x - 2
				b.y = b.y - 2
				b.shadow.x = buttonshadow
				b.shadow.y = buttonshadow
			end
			
		end
	end

	function states.titlemenu.keypressed(key)
		if key == "escape" then
			love.event.quit()
		elseif key ==' ' then
			states.fileselect.load()
		elseif key == 'f' then
			window.fullscreen = not window.fullscreen
			love.graphics.setMode( window.width, window.height, window.fullscreen)
		end
	end

------------------------------------  Options  --------------------------------
-------------------------------------------------------------------------------
states.mainoptions = {}
 function states.mainoptions.load()
	state = 'mainoptions'
	
	states.mainoptions.buttons = {}
	states.mainoptions.buttons.back = button.make{text="Back",width=160,height=60,x=window.width-180,y=520,font=neographfont[22], textcolor ={30,10,10}}
	
	states.mainoptions.sliders = {}
	states.mainoptions.sliders.titlevolume = slider.make{value=music.title.music:getVolume(),text="Title Music",textcolor={10,10,20},x = 40,y=150, font=impactfont[24], color={120,120,255}, multiplyer= 100, round=0.01}
	states.mainoptions.sliders.fightvolume = slider.make{value=music.fight.music:getVolume(),text="Battle Music",textcolor={10,10,20},x = 40,y=240, font=impactfont[24], color={120,120,255}, multiplyer= 100,round = 0.01}
	states.mainoptions.sliders.discoveryvolume = slider.make{value=music.discovery.music:getVolume(),text="Battle Music",textcolor={10,10,20},x = 40,y=330, font=impactfont[24], color={120,120,255}, multiplyer= 100,round = 0.01}
 end
 
 function states.mainoptions.update()
	music.title.music:setVolume(states.mainoptions.sliders.titlevolume.value)
	music.fight.music:setVolume(states.mainoptions.sliders.fightvolume.value)
	music.discovery.music:setVolume(states.mainoptions.sliders.discoveryvolume.value)
	for i,b in pairs(states.mainoptions.buttons) do
		b:update()
	end
	for i,s in pairs(states.mainoptions.sliders) do
		s:update()
	end
 end
 
 function states.mainoptions.draw()
	love.graphics.setColor(255,255,255)
	local tile = stonebrick.pic
	local x = 0
	local y = 0
	local twidth = 50
	local theight = 50
	while y < window.height  do
		while x < window.width do
			love.graphics.draw(stonebrick.pic, x,y, 0, twidth/stonebrick.width, theight/stonebrick.height)
			x = x + twidth
		end
		y = y + theight
		x = 0
	end
	
	love.graphics.setFont(neographfont[60])
	love.graphics.setColor(0,0,0)
	love.graphics.printf("Sound Settings",0,20,window.width,'center')
	
	for i,b in pairs(states.mainoptions.buttons) do
		b:draw()
	end
	
	for i,s in pairs(states.mainoptions.sliders) do
		s:draw()
	end
 end
 
 function states.mainoptions.mousepressed(x,y,button)
	for i,b in pairs(states.mainoptions.buttons) do
		if b.hover then
			if i =='back' then
				states.titlemenu.load()
			end
		end
	end
	
	for i,s in pairs(states.mainoptions.sliders) do
		if s.hover then
			if s.selected then
				s.value = (x - s.x)/s.width
			else
				s.selected = true
			end
		elseif collision.pointRectangle(x,y,s.x + s.width * s.value - s.arrowwidth/2, s.y - s.arrowheight*0.6,s.arrowwidth, s.arrowheight) then
			s.mouseoffx = s.x + s.width*s.value - x
			s.selected = true
		else
			s.selected = false
			s.mouseoffx = 0
		end
	end
 end
 
 function states.mainoptions.mousereleased(x,y,button)
	
 end
 
 function states.mainoptions.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	
 end

----------------------------------  File Select  ------------------------------
-------------------------------------------------------------------------------
states.fileselect = {}
	function states.fileselect.load()
		
		states.fileselect.buttons = {}
		
		local height = 150--window.height * 0.17
		local width = 600--window.width*0.75
		local spacing = 18
		local top = 90
		local left = 10--window.width/2-width/2
		states.fileselect.buttons.one = button.make{text="1",width=width,height=height,x=left,y=top,font=impactfont[48], textcolor ={0,0,0}, image = greenrect.pic, imagecolor={255,100,100,200}, selectedcolor = {255,210,160}}
		states.fileselect.buttons.two = button.make{text="2",width = width,height =height,x=left,y=top+height+spacing,font=impactfont[48], textcolor ={0,0,0},image = greenrect.pic,imagecolor={100,255,100,200},selectedcolor = {150,255,160}}
		states.fileselect.buttons.three = button.make{text="3",width=width,height=height,x=left,y=top+height+spacing+height+spacing,font=impactfont[48], textcolor ={0,0,0},image = greenrect.pic,imagecolor={100,100,255,200},selectedcolor = {150,210,255}}
		
		states.fileselect.buttons.back = button.make{text="Back to Title",height=44,x=window.width-175,y=550,font=impactfont[28], textcolor={0,0,0}, shadow = {width=3,height=3}, selectedcolor={255,255,255}}
		states.fileselect.buttons.start = button.make{text="START",x=window.width-175,y=100,font=impactfont[48], textcolor={0,0,0},image=greenrect.pic,selectedcolor={255,255,100}}
		states.fileselect.buttons.delete = button.make{text="DELETE",x=window.width-175,y=190,font=impactfont[48], textcolor={0,0,0},image=greenrect.pic,selectedcolor={255,100,100}}
		
		levelupxps = {1,5,10,25,50,75,100,180,250,500,750,1000,1400,1800,2200,2600,3000,3600,4200,4800}
		
		headerkeys = {'name','level','hp','maxhp','xp','gold', 'location'}
		filenames = {'one','two','three'}
		fileheaders = {}
		for i,v in ipairs(filenames) do
			if love.filesystem.isFile("Save " .. v .. "/file " .. v .. ' player.lua') and love.filesystem.isFile("Save " .. v .. "/file " .. v .. ' header.lua') then
				states.fileselect.buttons[v]:changeText("")
				--fileheaders[v] = stringtotable(grant.table.load("file " .. v .. " header.txt"))
				fileheaders[v] = love.filesystem.load("Save " .. v .. "/file " .. v .. ' header.lua')()
			else
				fileheaders[v] = false
				states.fileselect.buttons[v]:changeText("New Game")
			end
		end
		
		love.graphics.setBackgroundColor(0,0,0)
		
		fileselectTile = {}
		fileselectTile.pic = graybrick.pic
		fileselectTile.width = 100
		fileselectTile.height = 100
		
		barheight = 18
		
		state = 'fileselect'
		
	end

	function states.fileselect.update()
		for i,b in pairs(states.fileselect.buttons) do
			b:update()
		end
	end

	function states.fileselect.draw()
		
		love.graphics.setColor(150,150,150)
		local x =0
		local y
		while x < window.width do
			y = 0
			while y < window.height do
				love.graphics.draw(fileselectTile.pic,x,y,0,fileselectTile.width/graybrick.width,fileselectTile.height/graybrick.height)
				y = y + fileselectTile.height
			end
			x = x + fileselectTile.width
		end
		
		
		love.graphics.setFont(neographfont[60])
		love.graphics.setColor(0,0,0)
		love.graphics.print("Choose wisely...",34,2)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Choose wisely...",30,0)
		

		for i,b in pairs(states.fileselect.buttons) do
			b:draw()
			
			if fileheaders[i] then
				
				local comp = {}
				for i=1,3 do
					comp[i] = 255 - b.selectedcolor[i]+95
				end
				comp[4] = 200
				
				love.graphics.setFont(neographfont[28])
				love.graphics.setColor(0,0,0)
				love.graphics.print(fileheaders[i].name, b.x+0.05*b.width+2, b.y + 0.15*b.height+1-7)
				
				love.graphics.setColor(100,200,240)
				love.graphics.print(fileheaders[i].name, b.x+0.05*b.width, b.y + 0.15*b.height-7)
				
				
				
				love.graphics.setColor(0,0,0)
				love.graphics.print("Level " .. fileheaders[i].level, b.x+0.95*b.width - neographfont[28]:getWidth("Level " .. fileheaders[i].level) + 2, b.y + 0.15*b.height+1-7)
				love.graphics.setColor(100,255,255)
				love.graphics.print("Level " .. fileheaders[i].level, b.x+0.95*b.width- neographfont[28]:getWidth("Level " .. fileheaders[i].level), b.y + 0.15*b.height-7)
				

				
				----XP Bar----
				
				local bary = b.y+0.37*b.height
				love.graphics.setFont(impactfont[20])
		
				love.graphics.setColor(10,60,10)
				love.graphics.print("XP", b.x + 0.05*b.width+2,bary - 2)
				love.graphics.setColor(20,225,20)
				love.graphics.print("XP", b.x + 0.05*b.width,bary - 4)
				
				
				local barx = b.x + 0.05*b.width + impactfont[20]:getWidth("XP")+2
				
				local barwidth = 0.9*b.width - (impactfont[20]:getWidth("XP")+2)
				local textx = barx+barwidth/2 - impactfont[12]:getWidth(fileheaders[i].xp .. '/' .. levelupxps[fileheaders[i].level])/2
				love.graphics.setColor(20,20,20)
				love.graphics.rectangle("fill", barx,bary,barwidth,barheight)
				
				love.graphics.setColor(0,200,0)
				love.graphics.rectangle("fill", barx+2,bary+2,(barwidth-4)*math.min(fileheaders[i].xp/levelupxps[fileheaders[i].level],1), barheight-4)
				
				love.graphics.setFont(neographfont[14])
				love.graphics.setColor(20,20,20)
				love.graphics.print(fileheaders[i].xp .. '/' .. levelupxps[fileheaders[i].level], textx+1,bary-2+1)

				love.graphics.setColor(250,250,250)
				love.graphics.print(fileheaders[i].xp .. '/' .. levelupxps[fileheaders[i].level], textx,bary-2)
				
				----HP Bar----
				bary = bary + barheight+4
				
				love.graphics.setFont(impactfont[20])
				love.graphics.setColor(90,10,10)
				love.graphics.print("HP", b.x + 0.05*b.width+2,bary-2)
				love.graphics.setColor(225,20,20)
				love.graphics.print("HP", b.x + 0.05*b.width,bary-4)
				
				textx = barx+barwidth/2 - impactfont[12]:getWidth(fileheaders[i].hp .. '/' .. fileheaders[i].hp)/2
				
				love.graphics.setColor(20,20,20)
				love.graphics.rectangle("fill", barx,bary,barwidth,barheight)
				
				love.graphics.setColor(200,0,0)
				love.graphics.rectangle("fill", barx+2,bary+2,(barwidth-4)*fileheaders[i].hp/fileheaders[i].maxhp, barheight-4)
				
				love.graphics.setFont(neographfont[14])
				love.graphics.setColor(20,20,20)
				love.graphics.print(fileheaders[i].hp .. '/' .. fileheaders[i].maxhp, textx+1,bary-2+1)

				love.graphics.setColor(250,250,250)
				love.graphics.print(fileheaders[i].hp .. '/' .. fileheaders[i].maxhp, textx,bary-2)


				-----Location-----
				love.graphics.setFont(neographfont[20])

				love.graphics.setColor(100,100,100)
				love.graphics.print(fileheaders[i].location, b.x + b.width*0.05 -2,b.y+b.height*0.67-1)
				love.graphics.setColor(255,255,255)
				love.graphics.print(fileheaders[i].location, b.x + b.width*0.05 +2,b.y+b.height*0.67+1)

				love.graphics.setFont(neographfont[20])
				love.graphics.setColor(0,0,0)
				love.graphics.print(fileheaders[i].location, b.x + b.width*0.05,b.y+b.height*0.67)
			end
		end
	end

	function states.fileselect.mousepressed(x,y,button)
		hitfile = false
		for i,b in pairs(states.fileselect.buttons) do
			if b.hover then
				if b.selected or i == 'back' then
					if i == 'back' then
						b.selected = true
						b.x = b.x + 2
						b.y = b.y + 2
						b.shadow.x = 1
						b.shadow.y = 1
						b.shadow.width,b.shadow.height = 2,2
						return
					elseif i =='delete' then
						
						if love.filesystem.removeDirectory("Save " .. selectedfile) then
							fileheaders[selectedfile] = false
							states.fileselect.buttons[selectedfile]:changeText("New Game")
						end
					else
						states.levelselect.load()
						return
					end
				elseif i ~= 'start' and i~= 'delete' then
					hitfile = true
					selectedfile = i
					b.selected = true
				end
			else
				b.selected = false
			end
			
		end
		
		if not hitfile then
			selectedfile = false
		end
		states.fileselect.buttons.start.selected = hitfile
		states.fileselect.buttons.delete.selected = hitfile
	end
	function states.fileselect.mousereleased(x,y,button)
		local b = states.fileselect.buttons.back
		if b.hover and b.selected then
			states.titlemenu.load()
		elseif b.selected then
			b.selected = false
			b.x = b.x - 2
			b.y = b.y - 2
			b.shadow.x = 3
			b.shadow.y = 3
			b.shadow.width,b.shadow.height = 3,3
		end
	end

	function states.fileselect.keypressed(key)
		if key == 'escape' then
			love.event.quit()
		elseif key == ' ' then
			selectedfile = 'one'
			states.levelselect.load()
		end
	end


--------------------------------  Loading Screen  ----------------------------
------------------------------------------------------------------------------
states.loadingscreen = {}
	function states.loadingscreen.load(nextone,speed,...)
		dotdelay = 0.74
		love.audio.stop()	
		
		music.loading.music:play()
		
		startingtime = love.timer.getTime()
		t = {"",".","..","..."}
		dotcounter = 1
		
		loadspeed = speed or 1
		nextstate = nextone
		state = 'loadingscreen'	
		
		if states[nextstate].loaded then
			states[nextstate].load(unpack(...))
		else
			states[nextstate].loaded = true
		end
		states.loadingscreen.done = false
		states.loadingscreen.percentdone = 0
		up = 1
	end

	function states.loadingscreen.update(dt)
		if love.timer.getTime() - startingtime > dotdelay * dotcounter then
			dotcounter = dotcounter + 1
			if math.random() < 1 then
				if up == 1 then
					if math.random() < 0.02 then
						up = -up
					end
				else
					if math.random() < 0.8 then
						up = -up
					end
				end
			end
		elseif states.loadingscreen.done == false then
			if math.random() < 0.3 then
				states.loadingscreen.percentdone = states.loadingscreen.percentdone + math.random(-50,250)/2*dt * up * loadspeed
			end
		end
		if states.loadingscreen.percentdone >= 100 and states.loadingscreen.done == true then
			states[nextstate].load()	
		elseif states.loadingscreen.percentdone >= 100 and states.loadingscreen.done == false then
			states.loadingscreen.done = 0
			states.loadingscreen.percentdone = 100
		elseif states.loadingscreen.done then
			states.loadingscreen.done = states.loadingscreen.done + dt
			states.loadingscreen.percentdone = 100
			if states.loadingscreen.done >= 1 then
				states.loadingscreen.done = true
			end
		end
	end

	function states.loadingscreen.draw()
		love.graphics.setColor(255,255,255)
		local tile = stonebrick.pic
		local x = 0
		local y = 0
		local twidth = 50
		local theight = 50
		while y < window.height  do
			while x < window.width do
				love.graphics.draw(stonebrick.pic, x,y, 0, twidth/stonebrick.width, theight/stonebrick.height)
				x = x + twidth
			end
			y = y + theight
			x = 0
		end
		love.graphics.setFont(neographfont[60])
		love.graphics.setColor(0,0,0)
		love.graphics.print("Loading Game" .. t[dotcounter-math.floor((dotcounter-1)/#t)*#t],50,100)
		
		love.graphics.setLineWidth(2)
		love.graphics.rectangle('line', 50,400,700,30)
		
		love.graphics.setColor(100,100,100)
		love.graphics.rectangle('fill', 52,402,700-4,30-4)
		
		love.graphics.setColor(0,200,0)
		love.graphics.rectangle('fill', 50+2,400+2, (700-4)*states.loadingscreen.percentdone/100, 30-4)
		
		love.graphics.setFont(defaultfont[24])
		love.graphics.setColor(0,0,0)
		love.graphics.print(math.round(states.loadingscreen.percentdone,0.1) .. "%", 350,400+2)
	end

	function states.loadingscreen.mousepressed(x,y,button)
	end

	function states.loadingscreen.keypressed(key)
		if key == 'm' then
			states.titlemenu.load()
		else
			states[nextstate].load()
		end
	end

---------------------------------  Level Select  -----------------------------
------------------------------------------------------------------------------
states.levelselect = {}
	function states.levelselect.load()
		local self = states.levelselect
		
		if (music.title.music:isPaused() or music.title.music:isStopped()) then
			love.audio.stop()
			music.title.music:rewind()
			music.title.music:play()
		end
		
		--[[
		self.levels = {}
		local stuff = love.filesystem.getDirectoryItems("LevelEditor/Levels")
		for i,v in pairs(stuff) do
			--if love.filesystem.isFile("LevelEditor/Levels/" .. v) and string.sub(v,string.len(v)-3) == '.lua' then
				--table.insert(self.levels,string.sub(v,1,string.len(v)-4))
			--end
			if love.filesystem.isDirectory("LevelEditor/Levels/"..v) then
				local start = string.len(v)
				local stop = string.len(v)
				while tonumber(string.sub(v,start,stop)) ~= nil do
					start = start-1
				end
				if stop ~= start then
					local n = tonumber(string.sub(v,start+1,stop))
					self.levels[n] = string.sub(v,1,start)
				end
			end
		end
		--]]
		self.rectangles = {}
		local nc = 4--5
		local width = 140
		local height = 130
		local hspace = 15
		local vspace = 20
		
		local startx = window.width/2 - ((width+hspace)*nc-hspace)/2
		local x = startx
		local y = 90
		local ccount = 1 --column count
		
		for i,v in ipairs(level.mainLevelNames) do
			table.insert(self.rectangles,{x=x,y=y,width=width,height=height,levelname=v,number=i,hover=false})
			
			ccount = ccount + 1
			x = x + width + hspace
			if ccount > nc then
				y = y + height + vspace
				x = startx
				ccount = 1
			end
		
		end
		
		self.buttons = {}
		self.buttons.quit = button.make{x=30,y=window.height*0.7,text="Quit",image=greenrect.pic,imagecolor={250,100,80},textcolor={0,0,0},font=defaultfont[24]}
		self.buttons.save = button.make{x=30,y=window.height*0.9,text="Save",image=greenrect.pic,imagecolor={80,100,250},textcolor={0,0,0},font=defaultfont[24]}

		self.backColor = {150,150,150}
		if selectedfile == 'one' then
			self.backChanging = 1
		elseif selectedfile == 'two' then
			self.backChanging = 2
		else
			self.backChanging = 3
		end
		metersize = 50
		initializePhysics(metersize)
		love.filesystem.load('game/weapons.lua')()
		playerfunctions.load()
		
		
		if not love.filesystem.isFile("Save " .. selectedfile .. "/file " .. selectedfile .. ' player.lua') then
			savegame(selectedfile)
			print("Made new save file.")
		end
		
		state = 'levelselect'
	end
	function states.levelselect.update(dt)
		local self = states.levelselect
		
		local mx, my = love.mouse.getPosition()
		self.hover = false
		for i,v in ipairs(self.rectangles) do
			if collision.pointRectangle(mx,my, v.x,v.y,v.width,v.height) then
				v.hover = true
				self.hover = v
			else
				v.hover = false
			end
		end
		
		for i,b in pairs(self.buttons) do
			b:update()
		end
		
		self.backColor[self.backChanging] = 127*(math.sin(love.timer.getTime())+1)
	end
	
	function states.levelselect.draw()
		local self = states.levelselect
		
		love.graphics.setColor(self.backColor)
		local x =0
		local y
		while x < window.width do
			y = 0
			while y < window.height do
				love.graphics.draw(fileselectTile.pic,x,y,0,fileselectTile.width/graybrick.width,fileselectTile.height/graybrick.height)
				y = y + fileselectTile.height
			end
			x = x + fileselectTile.width
		end
		
		love.graphics.setFont(defaultfont[14])
		for i,v in ipairs(self.rectangles) do
		
			love.graphics.setColor(10,70,250)
			love.graphics.rectangle("fill",v.x,v.y,v.width,v.height)
			
			if v.hover then
				love.graphics.setColor(255,0,0,100)
				--love.graphics.rectangle("fill", v.x,v.y,v.width,v.height)
				
				drawBlur.rectangle(v.x, v.y, v.width, v.height, 13, {255,255,255,150}, {255,255,255,0})
			end
			love.graphics.setColor(255,255,255)
			local width = v.width-10
			local height = v.height-30
			love.graphics.draw(levelPic.pics[i],v.x+v.width/2-width/2,v.y+v.height-6-height,0,width/levelPic.width,height/levelPic.height)
			if player.levelNumber == i then
				love.graphics.setColor(255,255,255)
				local width = v.width/4
				local height = width * playerimages.picheight/playerimages.picwidth
				love.graphics.draw(playerimages.towards,v.x+v.width/2 - width/2,v.y+v.height-height,0,width/playerimages.picwidth,height/playerimages.picheight)
			end
			love.graphics.setColor(255,255,255)
			love.graphics.printf(v.levelname,v.x,v.y+4,v.width,'center')
			
		end
		
		for i,b in pairs(self.buttons) do
			b:draw()
		end
		
		love.graphics.setColor(255,255,255)
		love.graphics.setFont(neographfont[28])
		love.graphics.printf(player.name,0,0,window.width,'center')
	end
	
	function states.levelselect.mousepressed(x,y,button)
		local self = states.levelselect
		if self.hover then
			--local new = player.location ~= self.hover.levelname
			local new = player.levelNumber ~= self.hover.number
			states.game.load(self.hover.number,new)
			return
		end
		for i,b in pairs(self.buttons) do
			if b.hover then
				if i == 'quit' then
					states.fileselect.load()
				elseif i == 'save' then
				
				end
				break
			end
		end
	
	end
	
	function states.levelselect.keypressed(key)
		if key == 'escape' then
			love.event.quit()
			QUIT=true
		elseif key == ' ' then
			local levelNumber = (player.levelNumber~=0 and player.levelNumber) or 1
			local new = player.levelNumber ~= levelNumber
			states.game.load(levelNumber,new)
			return
		end
	
	end
-------------------------------------  Game  ---------------------------------
------------------------------------------------------------------------------
states.game = {}
	function states.game.load(levelNumber,restartinglevel)
		--fred = love.thread.newThread("fred","george.lua")
		
		--[[
		if fred:get('error') then
			error(fred:get('error'))
		end
		--]]
		
		slowmotion = 1
		
		hud.load()
		camera.load()
				
		enemies.load()
		
		if player.levelNumber ~= levelNumber or restartinglevel then
			player.levelNumber = levelNumber
			for i in pairs(player.visited) do
				player.visited[i] = nil
			end
		end
		
		currentLevel = level.loadMain(levelNumber,restartinglevel)

		player.location = currentLevel.levelname
	  	player.visited[player.location] = true
	  	
		if restartinglevel and currentLevel.spawnpoint then
			player.x,player.y = unpack(currentLevel.spawnpoint)
		end
		background.load()
		
		pausedscreen.load()

		upgradescreen.load()
		upgrades = upgradescreen.make()


		crazycolor = false
		paused = false
		night = false
	 
		state = 'game'

		states.game.buttons = {}
		states.game.explosions = {}
		
		love.timer.step()
			
		love.audio.stop()
		
		music.discovery.music:setLooping(true)
		music.discovery.music:rewind()
		music.discovery.music:play()
		
		charactercode = 1
		
		
		gamecanvas = love.graphics.newCanvas()
	end

	function states.game.update(dt)
		if dt > 1/30  then
			dt = 1/30
		end
		dt = dt * slowmotion
		if not paused then
			playerfunctions.update(dt)
			if player.hp > 0 then
				player.weapons[player.equippedWeapon]:update(dt)
			end
			enemies.update(dt)
			camera.update(dt)
			for i,v in ipairs(states.game.explosions) do
				v:update(dt)
			end
			local i = #states.game.explosions
			while i > 0 do
				if states.game.explosions[i].destroy then
					table.remove(states.game.explosions,i)
				end
				i = i - 1
			end
		else
			pausedscreen.update(dt)
		end
		hud.update(dt)
	end
	 
	function states.game.draw()	

		if not paused or true then
			camera.set()
			
			if clear and not night then
				background.draw(gameTile)
			end
			
			
			level.drawLevel()
			love.graphics.setColor(100,100,0)
			
			enemies.draw()
			
			--playerfunctions.drawWeapons()
		
			playerfunctions.draw()
			--playerfunctions.draw({0,255,255,player.frozen/player.maxFrozen*255})
			
			--player.weapons[player.equippedWeapon]:draw()
			
			for i,v in ipairs(states.game.explosions) do
				v:draw()
			end
			
			level.drawWater()
			

			local x,y = love.mouse.getPosition()
			local worldx,worldy = getWorldPoint(x,y)--camera.x+(x-camera.width/2),camera.y+(y-camera.height/2)
			if clear then love.graphics.circle("fill",worldx,worldy,3) end
			
			love.graphics.setFont(defaultfont[64])
			love.graphics.setColor(255,255,255)
			
			camera.unset()

			if love.keyboard.isDown('u') then
				drawBlur.circle(x,y,0,nil,59,{0,0,0,0},{0,0,0,100})
				drawBlur.circle(x,y,60,nil,19,{0,0,0,100},{200,200,200})
				drawBlur.circle(x,y,80,nil,4,{200,200,200},{255,255,255})
				drawBlur.circle(x,y,85,nil,4,{255,255,255},{200,200,200})
				drawBlur.circle(x,y,90,nil,19,{200,200,200},{0,0,0,100})
				drawBlur.circle(x,y,110,nil,20,{0,0,0,100},{0,0,0,20})
			end
		end
		hud.draw()
		if not paused or true then
			if player.hurttime > 0 then
				if player.hp > 0 then
					--love.graphics.setColor(255,0,0, player.hurttime/player.maxhurttime*200 )
					--love.graphics.rectangle("fill", 0,hud.height, camera.width,camera.height)
					
					love.graphics.setColor(255,0,0, player.hurttime/player.maxhurttime*100 +10)
					love.graphics.rectangle("fill", 0,hud.height, camera.width,camera.height)
				else
					love.graphics.setColor(255,0,0, 255 - (player.hurttime/player.maxhurttime)^10 * 255 )
					--love.graphics.setColor(70,100,255, 255 - (player.hurttime/player.maxhurttime)^10 * 255 )
					love.graphics.rectangle("fill", 0,hud.height, camera.width,camera.height)
					
					--love.graphics.setColor(255,255,255,255 - (player.hurttime/player.maxhurttime) * 255)
					love.graphics.setFont(defaultfont[200])
					love.graphics.setColor(0,0,0,(255 - (player.hurttime/player.maxhurttime) * 255)*0.9)
					love.graphics.print("DEAD",119,102)
					
					love.graphics.setColor(150,0,0,(255 - (player.hurttime/player.maxhurttime) * 255)*0.9)
					love.graphics.print("DEAD",115,100)
				end
			end
		end
		
		if night then
			love.graphics.setColor(0,0,0,100)
			love.graphics.rectangle("fill", 0,hud.height,window.width,window.height)
		end
		if paused then
			love.graphics.setColor(255,255,255,100)
			love.graphics.rectangle("fill", 0,hud.y+hud.height,window.width,window.height-hud.height)

			pausedscreen:draw()
		end
		
		if info then
			love.graphics.setFont(defaultfont[14])
			love.graphics.setColor(255,255,255)
			love.graphics.print("Player X: " .. player.x, 10,10)
			love.graphics.print("Player Y: " .. player.y, 10,30)
		
			mousex,mousey = love.mouse.getPosition()
			love.graphics.print("Mouse X: " .. camera.x+(mousex-camera.width/2), 10,50)
			love.graphics.print("Mouse Y: " .. camera.y+(mousey-camera.height/2), 10,70)
		
			love.graphics.print("Camera Offset X: " .. camera.offset.x, 10,110)
			love.graphics.print("Camera Offset Y: " .. camera.offset.y, 10,130)
		
			love.graphics.print("Player in Water Height: " .. player.inwaterheight, 10,150)
			love.graphics.print("Player in Water?: " .. tostring(player.inwater), 10,165)

			love.graphics.print("# of Jumps: " .. player.jumps, 10, 185)
			love.graphics.print("X Speed: " .. player.xspeed, 10, 205)
			love.graphics.print("Y Speed: " .. player.yspeed, 10, 220)
			
			love.graphics.print("Arm Angle: " .. player.armAngle/math.pi .. "pi", 10, 235)
			love.graphics.setColor(255,0,0)
			local x,y = love.mouse.getPosition()
			if clear then love.graphics.circle("fill",x,y,2) end
		end
		
	end

	function states.game.mousepressed(x,y,button)
		if player.hp > 0 then
			if y < hud.height then
				hud.mousepressed(x,y,button)
			elseif not paused then
				player.weapons[player.equippedWeapon]:mousepressed(x,y,button)
				
				--[[ Fun tool and Debugging tool: Stops a pawn's horizontal motion when it is clicked
				local wx, wy = getWorldPoint(x,y)
				for i,v in pairs(level[player.location].allpawns) do
					if collision.pointRectangle(wx,wy,v.x-v.actualwidth/2,v.y-v.actualheight,v.actualwidth,v.actualheight) then
						v.xspeed = 0
						break
					end
				end
				--]]
			else
				pausedscreen.mousepressed(x,y,button)
			end
		end
		
	end

	function states.game.keypressed(key)
		if key == "escape" then
			if player.shooting == 'aiming' then
				player.shooting = false
			else
				love.event.quit()
			end
		elseif key == 'f5' then
			table.insert(screenshots,love.graphics.newScreenshot())
			screenshots[#screenshots]:encode("Screenshot " .. #screenshots .. ".png")
		elseif key == 'f4' then
			grant.table.save(currentLevel.allpawns,"enemies.lua")
		elseif key == "p" then
			paused = not paused
		elseif key =="w" then
			print(tostring(player.door) .. " " .. tostring(player.inlevel) .. " " .. tostring(player.goingthroughdoor))
			if player.door and player.inlevel then
				if player.goingthroughdoor then
					print("Already going through door.")
					return
				end
				playerfunctions.goThroughDoor()
			else
				if player.inwaterheight < player.height*3/4 then
					if player.jumps < player.maxjumps and not paused and player.hp > 0 then
						player.jumps = player.jumps + 1
						if player.inwaterheight >= player.height/3 then
							factor = 2
						else
							factor = 1
						end
						if player.yspeed >= 0 then
							player.yspeed = -85*factor * (player.jumpability)^0.5
						else
							player.yspeed = player.yspeed -70*factor * (player.jumpability)^0.5
						end
						player.oxygenlevel = player.oxygenlevel - 0.5
						--player.anim.type = "jumping"
						--player.anim.frame = 1
					end
				else
					--player.yspeed = (40-70)*(player.wateragility/player.maxwateragility)^0.5 - 40
				end
			end
		elseif key == 'lshift' then
			if love.keyboard.isDown('a') or love.keyboard.isDown('d') then
				player.quick.speed = player.runspeed
			end
		elseif key == "a" or key == 'd' then
			if love.keyboard.isDown('lshift') then
				player.quick.speed = player.runspeed
			elseif player.quick.count > 0 and player.quick.count < player.quick.delay then
				player.quick.speed = player.runspeed - (player.runspeed-1)/2 
			else
				player.quick.count = 0
			end
		elseif key == 'q' then
			playerfunctions.changeWeapon()
		elseif key == 'r' then
			states.game.load(true)
		elseif key =='n' then
			night = not night
		elseif key == 'l' then
			camera.lock = not camera.lock
		elseif key == 'c' then
			crazycolor = not crazycolor
		elseif key == 'i' then
			info = not info
		elseif key == 'm' then
			if music.discovery.music:isStopped() then
				music.discovery.fastmusic:stop()
				music.discovery.music:play()
			else
				music.discovery.music:stop()
				music.discovery.fastmusic:play()	
			end
		elseif key == 'f' then
			--window.fullscreen = not window.fullscreen
			--love.window.setFullscreen(window.fullscreen,'desktop')
		elseif key == 'h' then
			playerfunctions.damage(1,'foe')
		elseif key == 'o' then
			player.infinitearrows = not player.infinitearrows
		elseif key == '.' then
			for a,b in pairs(upgradescreen.pages) do
				for i,v in pairs(b.upgrades) do
					player[v.playerkey] = v.values[#v.values]
				end
			end
		else
			if key == 'q' or key == 'e' or key == 't' or key == 'x' or key == 'o' or key == 'y' then
				--error("You tried to perform arithmetic. Please be more careful. \n Who knows what that kind of arithmetic could lead to.")
			else
				--error("You pressed the '" .. key .. "' key. This key has no function \n associated with it. Please don't press random keys.")
			end
		end
	end

	function states.game.mousereleased(x,y,button)
		if not paused then
			if button == 1 and player.shooting == 'aiming' then
				--player.shooting = true
			end
		else
			pausedscreen.mousereleased(x,y,button)
		end
	end

	function states.game.keyreleased (key)
		if key == "a" or key =="d" then
			if not (love.keyboard.isDown('a') or love.keyboard.isDown('d')) then
				player.quick.speed = 1
			end
		elseif key =='lshift' then	
			player.quick.speed = 1
		end
		
	end


----------------------------------  Game Over  -------------------------------
------------------------------------------------------------------------------
states.gameover = {}
	function states.gameover.load()
		
		if (music.dying.music:isPaused() or music.dying.music:isStopped()) then
			love.audio.stop()
			music.dying.music:rewind()
			music.dying.music:play()
		end
		local self = states.gameover
		
		
		self.buttons = {fromstart = button.make{text="Restart Level.",textcolor={0,80,0},x=400,y=430,height=50, image=buttonpic, font=neographfont[22],shadow={x=-3,y=3,width=0,height=0}},
		no = button.make{text="No.",textcolor = {200,0,0},x=180,y=450,width=100,height=50, image=buttonpic, font=neographfont[22],shadow={x=3,y=3,width=1,height=2}}, fromsave = button.make{text="Continue from last save",textcolor={255,255,255},x=370,y=490,height=50,image=buttonpic,font=impactfont[24],shadow={x=-3,y=-3}}
		}
		love.graphics.setBackgroundColor(255,255,255)
		alpha = 0
		
		state = 'gameover'
	end

	function states.gameover.update(dt)
		local self = states.gameover
		for i,b in pairs(self.buttons) do
			b:update()
		end
		hud.update()
	end

	function states.gameover.draw()
		local self = states.gameover
		love.graphics.setColor(255,0,0)
		--love.graphics.setColor(70,100,255)
		love.graphics.rectangle("fill", 0,hud.height, camera.width,camera.height)
		
		--love.graphics.setColor(255,255,255)
		love.graphics.setFont(defaultfont[200])
		
		love.graphics.setColor(0,0,0)
		love.graphics.print("DEAD",119,102)
		
		love.graphics.setColor(150,0,0)
		love.graphics.print("DEAD",115,100)
			

		alpha = alpha + 1		
		if alpha > 200 then
			alpha = 200
		end
		
		local bigW = 680
		local bigH = 270
		love.graphics.setColor(0,0,0,alpha*0.5)
		love.graphics.draw(buttonpic,window.width/2-bigW*0.9/2,315,0,bigW*0.9/buttonpicwidth, bigH*0.9/buttonpicheight)
		
		love.graphics.setColor(0,100,0,alpha)
		love.graphics.draw(buttonsmalloutlinepic, window.width/2-bigW/2,310,0,bigW/buttonpicwidth,bigH/buttonpicheight)
		
		love.graphics.setColor(255,255,255)
		love.graphics.setFont(defaultfont[36])
		love.graphics.printf("Would you like to play again?",225,330, 350,'center')
		
		for i,b in pairs(self.buttons) do
			b:draw()
		end
		
		hud.draw()
			
	end

	function states.gameover.keypressed(key)
		if key == 'escape' then
			love.event.quit()
		end
	end
	function states.gameover.mousepressed(x,y,button)
		local self = states.gameover
		for i,b in pairs(self.buttons) do
			if b.hover then
				if i == 'fromsave'then
					local n = player.levelNumber
					playerfunctions.load()
					if n ~= player.levelNumber then	
						states.game.load(n,true)
					else
						states.game.load(n)
					end			
				elseif i == 'fromstart' then
					local l = allLevels[player.levelNumber][level.mainLevelNames[player.levelNumber]] or level.loadMain(player.levelNumber,true,true)
					local newp = l.startingPlayer
					
					for i,v in pairs(newp) do
						player[i] = v
					end
					states.game.load(player.levelNumber,true)
				elseif i=='no' then
					states.levelselect.load()				
				end
			end
		end
		for i,b in pairs(hud.buttons) do
			if b.hover then
				if i == 'quit' then
					states.titlemenu.load()
				end
			end
		end
	end
	
----------------------------------  Level Won  -------------------------------
------------------------------------------------------------------------------
states.levelwon = {}
	function states.levelwon.load()
		local self = states.levelwon
		
		if (music.title.music:isPaused() or music.title.music:isStopped()) then
			love.audio.stop()
			music.title.music:rewind()
			music.title.music:play()
		end
		
		container = {}
		container.width = 0.8*window.width
		container.height = 0.8*window.height
		container.x = window.width/2-container.width/2
		container.y = window.height/2-container.height/2
		
		self.buttons = {}
		local cx = window.width/2-container.width/4
		if level.getLevelFilePath(player.levelNumber+1) then
			self.buttons.nextLevel = button.make{text="Next Level",textcolor={0,150,0},centerx=cx,y=450, image=greenrect.pic, font=impactfont[24],shadow={x=3,y=3,width=0,height=0},selectedcolor={200,200,200}}
		end
		self.buttons.toLevelSelect = button.make{text="Level Select",textcolor = {200,0,0},x=483,y=450, image=greenrect.pic, font=defaultfont[24],shadow={x=3,y=3,width=0,height=0},selectedcolor={200,200,200}}
		
		
		--love.graphics.setBackgroundColor(150,220,220)
		
		titletext = "Level " .. player.levelNumber .. " Completed.\nCongratulations."
		
		
		
		state = 'levelwon'
	end

	function states.levelwon.update(dt)
		local self = states.levelwon
		for i,b in pairs(self.buttons) do
			b:update()
		end
	end

	function states.levelwon.draw()
	
		love.graphics.setColor(255,255,255)
		local tile = stonebrick.pic
		local x = 0
		local y = 0
		local twidth = 50
		local theight = 50
		while y < window.height  do
			while x < window.width do
				love.graphics.draw(stonebrick.pic, x,y, 0, twidth/stonebrick.width, theight/stonebrick.height)
				x = x + twidth
			end
			y = y + theight
			x = 0
		end
		
		local self = states.levelwon
		
		
		love.graphics.setColor(10,180,50)
		love.graphics.rectangle("fill",container.x,container.y,container.width,container.height)
		--drawBlur.rectangle(container.x,container.y,container.width,container.height, math.ceil(10+20*(1+math.sin(love.timer.getTime()*4))),{10,180,50},{10,180,50,0}) 
		
		self.drawPulsingBorder()		
		
		love.graphics.setFont(neographfont[48])
		love.graphics.setColor(0,0,0)
		love.graphics.printf(titletext,container.x+1,container.y+1,container.width,'center')
		love.graphics.setColor(200,100,200)
		love.graphics.printf(titletext,container.x,container.y,container.width,'center')
		
		for i,b in pairs(self.buttons) do
			b:draw()
		end
				
	end
	
	function states.levelwon.drawPulsingBorder()
		local res = 3
		local tfactor = 12
		local incolor = colors.getPulsingColors({255,255,0},{255,0,0},tfactor/4)
		local outcolor = colors.getPulsingColors({255,255,0},{255,0,0,0},tfactor/4)
		local blurwidth = 20+math.ceil(15*(1+math.sin(love.timer.getTime()*tfactor)))
		drawBlur.rectangleInversePower(container.x,container.y,container.width,container.height, blurwidth ,incolor,outcolor,-0.5,res) 
	
	
		love.graphics.setColor(0,0,0)
		love.graphics.setLineWidth(res-1)
		res = 2
		love.graphics.rectangle("line",container.x+res/2,container.y+res/2,container.width-res,container.height-res)
	end

	function states.levelwon.keypressed(key)
		if key == 'escape' then
			love.event.quit()
		end
	end
	function states.levelwon.mousepressed(x,y,button)
		local self = states.levelwon
		if button==1 then
			for i,b in pairs(self.buttons) do
				if b.hover then
					b.shadow.x = b.shadow.x-2
					b.shadow.y = b.shadow.y-2
					b.x = b.x+2
					b.y = b.y+2
					b.selected = true
					break
				end
			end
		end
	end
	
	function states.levelwon.mousereleased(x,y,button)
		local self = states.levelwon
		if button== 1 then
			for i,b in pairs(self.buttons) do				
				if b.selected then
					b.shadow.x = b.shadow.x+2
					b.shadow.y = b.shadow.y+2
					b.x = b.x-2
					b.y = b.y-2
					b.selected = false
					if b.hover then
						if i == 'nextLevel' then
							states.game.load(player.levelNumber + 1,true)
						elseif i == 'toLevelSelect' then
							states.levelselect.load()
						end
					end
					break
				end
			end
		end
	end
	
------------Empty State----------
states.empty = {}

function states.empty.load()
	state = 'empty'
end

function states.empty.update(dt)

end

function states.empty.draw()

end
