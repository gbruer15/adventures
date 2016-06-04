titlemenu = {}
titlemenu.__index = titlemenu
function titlemenu.make()
	local t = {}
	setmetatable(t,titlemenu)

	t.buttons = {}
	t.buttons.newLevel = button.make{text="Make New Level",x=200,y=300}
	t.buttons.editLevel = button.make{text="Edit Existing Level",x=200,y=330}

	return t
end

function titlemenu:update(dt)
	for i,v in pairs(self.buttons) do
		v:update()
	end
end

function titlemenu:draw()
	for i,v in pairs(self.buttons) do
		v:draw()
	end
end

function titlemenu:mousepressed(x,y,button)
	for i,v in pairs(self.buttons) do

		if v.hover then
			if i == 'newLevel' then
				local levelname = textinput(20)
				state = levelediting.make(levelname)
				level.makeNew(editor.level)
			elseif i == 'editLevel' then
				local appfolderstuff = getFileNames("Level Editor Levels",'.lua')
				for i,v in ipairs(appfolderstuff) do
					appfolderstuff[i] = {name = v,fullpathname = "Level Editor Levels/" .. v .. '.lua'}
					local modified,err = love.filesystem.getLastModified(appfolderstuff[i].fullpathname)
					if modified then
						appfolderstuff[i].modified = os.date("%c", nil)
					else
						appfolderstuff[i].modified = "nil"
						print(err)
					end
				end
				
				rootstuff = getFileNames("Levels",'.lua')
				local stuff = love.filesystem.getDirectoryItems("Levels")
				local trim = '.lua'
				local trimlen = 4
				local rootstuff = {}
				for i,v in pairs(stuff) do
					if love.filesystem.isDirectory("Levels/" .. v) then
						local stuff = love.filesystem.getDirectoryItems("Levels/" .. v)
						for a,b in pairs(stuff) do
							if love.filesystem.isFile("Levels/" .. v .. '/' .. b) then
								if string.sub(b,string.len(b)-trimlen+1) == trim then
									local name = string.sub(b,1,string.len(b)-trimlen)
									local t = {name = name,dir=v,fullpathname = "Levels/" .. v ..'/'.. name .. '.lua'}
									print(":::" .. t.dir)
									local modified,err = love.filesystem.getLastModified(t.fullpathname)
									if modified then
										t.modified = os.date("%c", modified)
									else
										t.modified = "nil"
										print(err)
									end
									table.insert(rootstuff,t)
					
								else
									print("::" .. b)--string.sub(b,string.len(b)-trimlen+1))
								end
							else
								print(":" .. b)
							end
						end
					else
						
					end
				end
				--[[for i,v in ipairs(rootstuff) do
					rootstuff[i] = {name = v,fullpathname = "Levels/" .. v .. '.lua'}
					local modified,err = love.filesystem.getLastModified(rootstuff[i].fullpathname)
					if modified then
						rootstuff[i].modified = os.date("%c", modified)
					else
						rootstuff[i].modified = "nil"
						print(err)
					end
				end --]]
				if #appfolderstuff + #rootstuff > 0 then
					state = choosefile.make(appfolderstuff,rootstuff)
				end
			end
		end

	end

end

function getFileNames(directory,trim,list)
	local stuff = love.filesystem.getDirectoryItems(directory)
	local trimlen = string.len(trim)
	list = list or {}
	for i,v in pairs(stuff) do
		if love.filesystem.isFile(directory .. '/' .. v) then
			if string.sub(v,string.len(v)-trimlen+1) == trim then
				table.insert(list,string.sub(v,1,string.len(v)-trimlen))
			else
				print(string.sub(v,string.len(v)-trimlen+1))
			end
		elseif love.filesystem.isDirectory(directory .. '/' .. v) then
			getFileNames(directory .. '/' .. v, trim, list)
		end
	end
	return list
end

function titlemenu:keypressed(k)
	if k == 'escape' then
		love.event.quit()
	end

end

choosedirectory = {}
choosedirectory.__index = choosedirectory

function choosedirectory.make()

end

choosefile = {}
choosefile.__index = choosefile

function choosefile.make(appfiles,selffiles)
	local t = {}
	setmetatable(t,choosefile)

	t.buttons = {}

	local y = 100
	local x = 300
	if appfiles then
		for i,v in pairs(appfiles) do
			local b = button.make{text=v.name .. "  " .. v.modified,height=30,font=neographfont[14],y=y,x=x,image=greenrect.pic,imagecolor={30,100,220}}
			b.name = v.name
			y = y + 34
			table.insert(t.buttons,b)
		end
	end

	if selffiles then
		y = y + 50
		for i,v in pairs(selffiles) do
			local b = button.make{text=v.name .. "  " .. v.modified,height=30,font=neographfont[14],y=y,x=x,image=greenrect.pic,imagecolor={220,100,30}}
			b.name = v.name
			b.dir = v.dir
			y = y + 34
			table.insert(t.buttons,b)
		end
	end

	return t
end

function choosefile:update(dt)
	for i,b in pairs(self.buttons) do
		b:update()
	end
end

function choosefile:draw()
	for i,b in pairs(self.buttons) do
		b:draw()
	end
end

function choosefile:mousepressed(x,y,button)
	for i,b in pairs(self.buttons) do
		if b.hover then
			state=levelediting.make(b.name,b.dir)
			level.load(editor.level, b.dir)
		end
	end
end

function choosefile:keypressed(k)
	if k == 'escape' then
		love.event.quit()
	end
end

levelediting = {}
levelediting.__index = levelediting

function levelediting.make(levelname, dir)
	local t = {}
	setmetatable(t,levelediting)

	enemies.load()
	editor.load(levelname, dir)

	camera.load()
	camera.xscale,camera.yscale = 0.5,0.5

	hud.load()
	
	watercolor = {0,55,188,155}

	return t

end


function levelediting:update(dt)
	camera.update(dt)
	hud.update(dt)

	mousex,mousey = love.mouse.getPosition()
	wmousex,wmousey = camera.getWorldPoint(mousex,mousey)
	editor.x,editor.y = wmousex,wmousey
	
	if editor.state == 'adding' then
		if editor.rounding() then
			level[editor.level].blocks[1].width,level[editor.level].blocks[1].height = editor.x - level[editor.level].blocks[1].x , editor.y - level[editor.level].blocks[1].y
		else
			level[editor.level].blocks[1].width,level[editor.level].blocks[1].height = math.round(editor.x,grid.spacing) - level[editor.level].blocks[1].x , math.round(editor.y,grid.spacing) - level[editor.level].blocks[1].y
		end
	elseif editor.selected and editor.state == 'moving' then
		if editor.rounding() then
			editor.selected.x = -editor.offsetx + editor.x
			editor.selected.y = -editor.offsety + editor.y
		else
			editor.selected.x = -editor.offsetx + math.round(editor.x,grid.spacing)
			editor.selected.y = -editor.offsety + math.round(editor.y,grid.spacing)
		end
	end
	
	editor.colliding = 0
	editor.hover = {}
	for a,b in pairs(editor.leveleditables) do
		for i,v in pairs(level[editor.level][a]) do
			local left = (v.getLeft and v:getLeft()) or v.x
			local top = (v.getTop and v:getTop()) or v.y
			if collision.pointRectangle(editor.x,editor.y,left,top,v.width,v.height) then
				--editor.hover[v] = true
				table.insert(editor.hover,{v,leveltype=a,index=i})
				editor.colliding = editor.colliding + 1
			end
		end
	end
	
	menu.updateAll()
	love.window.setTitle(love.timer.getFPS())
end

function levelediting:draw()
	love.graphics.setBackgroundColor(0,151,254)

	mousex,mousey = love.mouse.getPosition()
	wmousex,wmousey = camera.getWorldPoint(mousex,mousey)
	
	camera.set()
		
		if grid.show then
			grid.draw()
		end
		
		love.graphics.setColor(220,0,0)
		love.graphics.circle("fill",level[editor.level].spawnpoint[1],level[editor.level].spawnpoint[2],editor.spawnpointradius)

		love.graphics.setColor(100,100,255)
		
		level.drawWater()
		level.drawLevel()

		enemies.draw()

		if editor.selected then
			love.graphics.setColor(255,0,0,50)
			local left = (editor.selected.getLeft and editor.selected:getLeft()) or editor.selected.x
			local top = (editor.selected.getTop and editor.selected:getTop()) or editor.selected.y
			love.graphics.rectangle("fill",left,top,editor.selected.width,editor.selected.height)
		else
			table.sort(editor.hover,editor.sortHover)
			local i = 0
			for a,b in ipairs(editor.hover) do
				love.graphics.setColor(255,255-i*255/#editor.hover,0,50)
				--[[
				local left = (i.getLeft and i:getLeft()) or i.x
				local top = (i.getTop and i:getTop()) or i.y
				love.graphics.rectangle("fill",left,top,i.width,i.height)
				--]]
				local v = b[1]
				local left = (v.getLeft and v:getLeft()) or v.x
				local top = (v.getTop and v:getTop()) or v.y
				love.graphics.rectangle("fill",left,top,v.width,v.height)
				
				i = i + 1
			end
		end

		love.graphics.setColor(0,200,0)
		if love.keyboard.isDown('rctrl') or love.keyboard.isDown('lctrl') then
			love.graphics.circle("fill", editor.x,editor.y,3/camera.xscale)
		else
			love.graphics.circle("fill", math.round(editor.x,grid.spacing),math.round(editor.y,grid.spacing),3/camera.xscale)
		end
		
	camera.unset()
	
	
	drawBlur.rectangle(camera.moveEdge,hud.height+camera.moveEdge,window.width-camera.moveEdge*2,window.height-hud.height-camera.moveEdge*2,camera.moveEdge,{200,20,0,100},{200,0,0,200})
	--drawBlur.rectangle(camera.moveEdge,hud.height+camera.moveEdge,window.width-camera.moveEdge*2,window.height-hud.height-camera.moveEdge*2,camera.moveEdge,{250,20,0,0},{220,0,0,200})
	--love.graphics.setColor(250,0,20,200)
	--love.graphics.setLineWidth(camera.moveEdge*2)
	--love.graphics.rectangle("line", 0,hud.height,window.width,window.height-hud.height)
	
	
	hud.draw()
	love.graphics.setColor(255,255,255)
	
	love.graphics.setFont(defaultfont[14])
	love.graphics.print("Round X: " .. math.round(editor.x,grid.spacing), 4,10)
	love.graphics.print("Round Y: " .. math.round(editor.y,grid.spacing), 4, 25)
	
	love.graphics.print("World X: " .. editor.x, 4, 45)
	love.graphics.print("World Y: " .. editor.y,4,60)
	
	love.graphics.print("Editor State: " .. editor.state,4,80)
	love.graphics.print("Current Rectangle Type: '" .. editor.leveltypes[editor.recttype] .. "'",4,95)
	love.graphics.print("Colliding: " .. editor.colliding,4,110)
	
	if editor.keydisplay then
		love.graphics.print(editor.keykey,window.width-200,20)
	end

	menu:drawAll()

end

function levelediting:keypressed(key)
	if key == 'escape' then
		if menu.anyOn() then
			for i,v in pairs(menus) do
				v:hide()
			end
		else
			love.event.quit()
		end
	elseif key == 'q' then
		if editor.state == 'adding' then
			editor.state = 'ready' 
			table.remove(level.blocks,1)
		elseif editor.state == 'connecting' then
			editor.state = 'readytoconnect'
		end
	elseif key == '-' and love.keyboard.isDown('rctrl') then
		camera.xscale = camera.xscale*0.8
		camera.yscale = camera.yscale*0.8
	elseif key == '=' and love.keyboard.isDown('rctrl') then
		camera.xscale = camera.xscale/0.8
		camera.yscale = camera.yscale/0.8
	elseif key == '0' and love.keyboard.isDown('rctrl') then
		camera.xscale,camera.yscale = 1,1
	elseif key == 'd' then	
		editor.state = 'delete'
	elseif key == 'a' then
		editor.state = 'ready'
	elseif key == 'g' then	
		grid.show = not grid.show
	elseif key == 'm' then
		editor.state = 'moving'
	elseif key == 'n' then	
		editor.state = 'nodes'
	elseif key == 'c' then
		editor.state = 'readytoconnect'
	elseif key == 'k' then
		editor.keydisplay = not editor.keydisplay
	elseif key == 't' then
		editor.recttype = editor.recttype + 1
		if editor.recttype > #editor.leveltypes then
			editor.recttype = 1
		end
		if editor.state == 'adding' then
			level[editor.level].blocks[1].type = editor.leveltypes[editor.recttype]
		end
	end
end

function levelediting:mousepressed(x,y,button)
	editor.mousepressed(x,y,button)

end

function levelediting:mousereleased(x,y,button)
	if button == 1 then
		if editor.state == 'adding' then
			x,y = camera.getWorldPoint(x,y)
			if editor.rounding() then
				level[editor.level].blocks[1].width,level[editor.level].blocks[1].height = x - level[editor.level].blocks[1].x, y - level[editor.level].blocks[1].y
			else
				level[editor.level].blocks[1].width,level[editor.level].blocks[1].height = math.round(x,grid.spacing) - level[editor.level].blocks[1].x, math.round(y,grid.spacing) - level[editor.level].blocks[1].y
			end
			if level[editor.level].blocks[1].width < 0 then
				level[editor.level].blocks[1].width = -level[editor.level].blocks[1].width
				level[editor.level].blocks[1].x = level[editor.level].blocks[1].x - level[editor.level].blocks[1].width
			end
			if level[editor.level].blocks[1].height < 0 then
				level[editor.level].blocks[1].height = -level[editor.level].blocks[1].height
				level[editor.level].blocks[1].y = level[editor.level].blocks[1].y - level[editor.level].blocks[1].height
			end
			level[editor.level].blocks[1].type = editor.leveltypes[editor.recttype]
			if level[editor.level].blocks[1].height == 0 or level[editor.level].blocks[1].width == 0 then
				table.remove(level[editor.level].blocks,1)
			end	
			if level[editor.level].blocks[1].type == 'water' or level[editor.level].blocks[1].type == 'sign' then
				level[editor.level].blocks[1].permeable = true
			elseif level[editor.level].blocks[1].type == 'door' then
				table.insert(level[editor.level].doors, level[editor.level].blocks[1])
				table.remove(level[editor.level].blocks,1)
			end

			local i = 1
			while level[editor.level].blocks[i] == nil do i = i + 1 end
			local sorted = {level[editor.level].blocks[i]}
			while i <= #level[editor.level].blocks do
				local placed = false
				for x,y in ipairs(sorted) do
					if not placed and level.drawOrderSort(level[editor.level].blocks[i],y) then
						table.insert(sorted,x,level[editor.level].blocks[i])
						placed = true
					end
				end
				if not placed then
					table.insert(sorted, i,level[editor.level].blocks[i])
				end
				i = i + 1
			end
			--level.blocks = sorted
			editor.state = 'ready'
		elseif editor.state == 'moving' then
			editor.selected = nil
		end
	end

end

function levelediting:quit()
	done = false
	
	love.graphics.setFont(defaultfont[14])
	love.graphics.setColor(100,100,100)
	love.graphics.rectangle("fill", 100,100,300,40)
	love.graphics.setColor(255,255,255)
	love.graphics.printf("Press 'y' to save and quit, press 'n' to quit without saving, and press 'c' to not quit",100,100, 280,'center')
	
	love.graphics.present()
		
	while not done do
		if love.event then
            love.event.pump()
            for e,a,b,c,d in love.event.poll() do
                if e == "quit" then
                    if not love.quit or not love.quit() then
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a,b,c,d)
            end
        end
		if love.keyboard.isDown('y') then
			save = true
			done = true
		end
		if love.keyboard.isDown('n') then
			save = false
			done = true
		end
		if love.keyboard.isDown('c') then
			return true
		end
	end
	if save then
		level.save(editor.level)
	end
end
