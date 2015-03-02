level = {}
level._index = level
level.mustdefine = {blocks = {}, doors={}, enemySpawnPoints={}, allpawns = {}, numPawns = 0, allsoldiers = {},numSoldiers=0,allwizards={},numWizards=0,enemydrops={},spawnpoint={0,0}}

level.directory = 'Levels/'
level.directoryItems = love.filesystem.getDirectoryItems(level.directory)

level.drawOrder = {'water', 'grassydirt', 'dirt', 'sign'}

function level.getLevelFilePath(number,name)
	name = name or level.mainLevelNames[number]
	return level.directory..level.mainLevelNames[number]..' '..number..'/'..name.. '.lua'
end

level.mainLevelNames = {}
for i,v in pairs(level.directoryItems) do
	if love.filesystem.isDirectory(level.directory..v) then
		local start = string.len(v)
		local stop = string.len(v)
		while tonumber(string.sub(v,start,stop)) ~= nil do
			start = start-1
		end
		if stop ~= start then
			local n = tonumber(string.sub(v,start+1,stop))
			level.mainLevelNames[n] = string.sub(v,1,start)
			if not love.filesystem.isFile(level.getLevelFilePath(n)) then
				error(level.getLevelFilePath(n))
			end
		end
	end
end


function level.load(levelname, dir)

	if not dir and love.filesystem.isFile('Level Editor Levels/' .. levelname .. '.lua') then
		level[levelname] = love.filesystem.load('Level Editor Levels/' .. levelname .. '.lua')()
	else
		level[levelname] = love.filesystem.load('Levels/' .. dir .. '/' .. levelname .. '.lua')()
	end

	for i,v in pairs(level.mustdefine) do
		level[levelname][i] = level[levelname][i] or v
	end
	
	level.mustdefinemeta = {enemySpawnPoints=enemySpawnPoint,allpawns=enemy.pawn,allsoldiers=enemy.soldier}

	level.setmetatables(level[levelname])
	--[[for i,v in pairs(level.mustdefine) do
		if i ~= "metatables" then
			level[levelname][i] = level[levelname][i] or v
		end
	end

--[
	for i,v in pairs(level.mustdefinemeta) do
		for a,b in pairs(level[levelname][i]) do
			setmetatable(b,v)
			if i == 'allpawns' then
				setmetatable(b.picanim,animation)
			end
		end
	end
--]]

--[[
	for i,v in pairs(level[levelname].enemySpawnPoints) do
		if getmetatable(v) == nil then
			setmetatable(v,enemySpawnPoint)
		end
	end

	for i,v in pairs(level[levelname].allpawns) do
		if getmetatable(v) == nil then
			setmetatable(v,enemy.pawn)
		end
		if getmetatable(v.picanim) == nil then
			setmetatable(v.picanim, animation)
		end
	end

	for i,v in pairs(level[levelname].allsoldiers) do
		if getmetatable(v) == nil then
			setmetatable(v,enemy.soldier)
		end
	end
]]

end


function level.makeNew(levelname)
	level[levelname] = {}
	for i,v in pairs(level.mustdefine) do
		level[levelname][i] = v
	end
end

function level.setmetatables(leveltable)
	local m = {[leveltable.enemySpawnPoints] = 'enemySpawnPoint',
		--[leveltable.allsoldiers]='return enemy.soldier',
		--[leveltable.allpawns] = {'return enemy.pawn',picanim='return animation'} ,
		--[leveltable.allwizards] = {'return enemy.wizard',missiles="return iceMissile"},
		--[player.arrows] = 'return weapons.arrow',
		--[enemydroplist] = 'enemydrop',
			}
	setmetatables(m)
	
	--for i,v in pairs(player.weapons) do
		--setmetatable(v,weapons[v.type])		
	--end

	--[[for i,v in pairs(player.weapons.bow.arrows) do
		if v.stuckTo then
			v.stuckTo = leveltable['all' .. v.stuckTo.type .. 's'][v.stuckTo.allindex]
		end
	end
	--]]
end

function setmetatables(masterlist,obj)
	if masterlist[1] then
		if obj then
			if string.find(masterlist[1],'.') then
				setmetatable(obj,loadstring(masterlist[1])())
			else
				setmetatable(obj,_G[masterlist[1]])
			end
			
		else
			if string.find(masterlist[1],'.') then
				setmetatable(masterlist,loadstring(masterlist[1])())
			else
				setmetatable(masterlist,_G[masterlist[1]])
			end
		end
	end

	for key,metathing in pairs(masterlist) do
		if type(key) == 'table' then
			for i,v in pairs(key) do
				if type(metathing) == 'table' and obj == nil then
					setmetatables(metathing,v)
				else
					if string.find(metathing,'.',nil,true) then
						setmetatable(v,loadstring(metathing)())
					else
						setmetatable(v,_G[metathing])
					end
				end
			end
		elseif type(key) == 'string' then
			if type(obj[key]) == 'table' then
				for i,v in pairs(obj[key]) do
					print(metathing)
					setmetatable(v,loadstring(metathing)())
				end
			else
				setmetatable(obj[key],_G[metathing])
			end
		end
	end

end

function level.save(levelname)
	if not love.filesystem.isDirectory("Level Editor Levels") then
		love.filesystem.createDirectory("Level Editor Levels")
	end

	local filepath = "Level Editor Levels/" .. levelname .. '.lua'

	
	local levelstring = "local level = {}\nlevel.levelname = '" .. levelname .. "'\n"

	for i,v in pairs(level.mustdefine) do
		local startstring = "\n\nlevel." .. i .. " = "
		if type(level[levelname][i]) == 'table' then
			if i == 'enemySpawnPoints' then
				levelstring = levelstring .. startstring .. tabletostring(level[levelname][i],true,{'enemies'})
			else
				levelstring = levelstring .. startstring .. tabletostring(level[levelname][i],true)
			end
		else
			levelstring = levelstring .. startstring .. tostring(level[levelname][i])
		end
	end
	levelstring = levelstring .. "\nreturn level"
	love.filesystem.write(filepath,levelstring)
end


function level.update()
	local wx,wy = camera.getWorldPoint(love.mouse.getPosition())
	for i,v in pairs(level[editor.level].blocks) do
		v.hover = collision.pointRectangle(wx,wy, v.x,v.y,v.width,v.height)
	end
	for i,v in pairs(level[editor.level].doors) do
		v.hover = collision.pointRectangle(wx,wy, v.x,v.y,v.width,v.height)
	end


end
function level.draw(type)
	if type == 'water' then
		level.drawWater()
	elseif type == "earth" then
		level.drawLevel()
	else
		level.drawWater()
		level.drawLevel()
	end

end



function level.drawWater()
	--love.graphics.setColor(unpack(watercolor))
	love.graphics.setColor(255,255,255)
	for i,rect in ipairs(level[editor.level].blocks) do
		if rect.type == 'water' or rect.type == "deathtrap" then
			if collision.rectangles(rect.x,rect.y,rect.width,rect.height, getWorldScreenRect()) then
				--if rect.type == 'deathtrap' then
				
				if rect.color then 
					love.graphics.setColor(unpack(rect.color))
				else
					love.graphics.setColor(unpack(watercolor))
				end
				--love.graphics.rectangle("fill", rect.x, rect.y, rect.width, rect.height)
				local nx = math.ceil(rect.width/water.width)
				local ny = math.ceil(rect.height/water.height)
				for x = 0,nx-1 do
					for y = 0,ny-1 do
						love.graphics.draw(water.pic,rect.x + x*water.width, rect.y + y*water.height)
					end
				end
			end
		end
		
	end
	
	
end

function level.drawOrderSort(a,b)
	local i = 1
	while i <= #level.drawOrder do
		if a.type == level.drawOrder[i] then
			break
		elseif b.type == level.drawOrder[i] then
			return false
		end
		i = i + 1
	end

	return true 
end

function level.drawLevel()
	local wx,wy = camera.getWorldPoint(love.mouse.getPosition())
	local l,t,w,h = getWorldScreenRect()
	
	local sorted = {level[editor.level].blocks[#level[editor.level].blocks]}
	local i = #level[editor.level].blocks - 1
	while i > 1 do
		local placed = false
		for x,y in ipairs(sorted) do
			if level[editor.level].blocks[i] == nil then
				break
			end
			if not placed and level.drawOrderSort(level[editor.level].blocks[i],y) then
				table.insert(sorted,x,level[editor.level].blocks[i])
				placed = true
			end
		end
		if not placed then
			table.insert(sorted, i,level[editor.level].blocks[i])
		end
		i = i - 1
	end
	table.insert(sorted,1,level[editor.level].blocks[1])

	level[editor.level].blocks = sorted

	for i,rect in ipairs(level[editor.level].blocks) do
		if collision.rectangles(rect.x,rect.y,rect.width,rect.height, getWorldScreenRect()) then
			if rect.type == 'dirt' or rect.type == "grassydirt" then
				local rx,ry = rect.x, rect.y
				local width, height = rect.width, rect.height
				if width < 0 then
					rx = rx+width
					width = -width
				end
				if height < 0 then
					ry = ry+height
					height = -height
				end

				if rect.color then 
					love.graphics.setColor(unpack(rect.color))
				else
					love.graphics.setColor(205,205,205)
				end
				local nx = math.ceil(width/grassydirt.width)
				local ny = math.ceil(height/grassydirt.height)
				for x = 0,nx-1 do
					if rect.type == 'grassydirt' then
						love.graphics.draw(grassydirt.pic,rx + x*width/nx, ry)
					else
						love.graphics.draw(dirt.pic,rx + x*width/nx, ry)
					end
					for y = 1,ny-1 do
						love.graphics.draw(dirt.pic,rx + x*width/nx, ry + y*height/ny)
					end
				end
			elseif rect.type == 'sign' then
				love.graphics.setColor(50,10,0,255)
				love.graphics.rectangle("fill",rect.x,rect.y,rect.width,rect.height)
				love.graphics.setFont(defaultfont[28])

				love.graphics.setColor(255,255,255)
				if rect.text then
					love.graphics.printf(rect.text, rect.x+10, rect.y+10, rect.width-20, "center")
				else
					love.graphics.print("This is a sign", rect.x+10, rect.y+10)
				end
			elseif rect.type == 'stonebrick' then
				local rx,ry = rect.x, rect.y
				local width, height = rect.width, rect.height
				if width < 0 then
					rx = rx+width
					width = -width
				end
				if height < 0 then
					ry = ry+height
					height = -height
				end

				if rect.color then 
					love.graphics.setColor(unpack(rect.color))
				else
					love.graphics.setColor(255,255,255)
				end
				local nx = math.ceil(width/stonebrick.width)
				local ny = math.ceil(height/stonebrick.height)
				for x = 0,nx-1 do
					for y = 0,ny-1 do
						love.graphics.draw(stonebrick.pic,rx + x*width/nx, ry + y*height/ny)
					end
				end
			elseif rect.type ~= 'water' then
				love.graphics.setColor(127,30,200)
				love.graphics.rectangle('fill', rect.x, rect.y, rect.width, rect.height)
			end

			love.graphics.setColor(220,100,50)
			love.graphics.setLineWidth(math.ceil(2/camera.xscale))
			love.graphics.rectangle("line", rect.x,rect.y,rect.width,rect.height)
		end
	end

	for i,rect in pairs(level[editor.level].doors) do
		if collision.rectangles(rect.x,rect.y,rect.width,rect.height, getWorldScreenRect()) then
			love.graphics.setColor(255,255,255)
			if rect.double then
				love.graphics.draw(door.pic, rect.x, rect.y,0, rect.width/door.width/2, rect.height/door.height)
				love.graphics.draw(door.pic, rect.x+rect.width, rect.y,0, -rect.width/door.width/2, rect.height/door.height)
			else
				love.graphics.draw(door.pic, rect.x, rect.y,0, rect.width/door.width, rect.height/door.height)
			end
		end
	end
end
