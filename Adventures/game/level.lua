level = {}
level._index = level
level.mustdefine = {blocks = {}, doors={}, enemySpawnPoints={}, allpawns = {}, numPawns = 0, allsoldiers = {},numSoldiers=0,allwizards={},numWizards=0,allmonkeys={},numMonkeys=0,enemydrops={},spawnpoint={0,0}}

level.directory = 'LevelEditor/Levels/'
level.directoryItems = love.filesystem.getDirectoryItems(level.directory)

function level.getLevelFilePath(number,name)
	name = name or level.mainLevelNames[number]
	if name == nil then
		return false
	end
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


allLevels = {}
function level.getLevel(x,n) --returns the level table given a number and a name 
	return allLevels[x][n]
end
function level.loadMain(levelnumber,restartinglevel,getSavedStartingPlayer)
	allLevels[levelnumber] = allLevels[levelnumber] or {}
	local l
	if restartinglevel then
		allLevels[levelnumber][level.mainLevelNames[levelnumber]] = love.filesystem.load(level.getLevelFilePath(levelnumber))()
		l = allLevels[levelnumber][level.mainLevelNames[levelnumber]]
		local player = player
		if getSavedStartingPlayer then
			local saved = love.filesystem.load("Save "..selectedfile..'/Levels/'..level.mainLevelNames[levelnumber]..'.lua')()
			player = saved.startingPlayer or player
			if not saved.startingPlayer then
				print("level.loadMain: no saved starting player.")
			end
		end
		l.startingPlayer = {}
		for i,v in pairs(player) do
			l.startingPlayer[i] = v
		end
	else
		allLevels[levelnumber][player.location] = love.filesystem.load("Save "..selectedfile..'/Levels/'..player.location..'.lua')()
		l = allLevels[levelnumber][player.location]
	end
	
	for i,v in pairs(level.mustdefine) do
		l[i] = l[i] or v
	end
	
	watercolor = {0,55,188,155}
	
	level.setmetatables(l)
	
	for i,self in pairs(l.allsoldiers) do
		if type(self) == 'table' then
			if self.xspeed > 0 then
				self.pic = soldierpics.right
			else
				self.pic = soldierpics.left
			end
		end
	end
	
	for i,self in pairs(l.allwizards) do
		if type(self) == 'table' then
			if self.xspeed > 0 then
				self.pic = wizardpics.right
			else
				self.pic = wizardpics.left
			end
		end
	end
	
	return l
end

function level.loadSecondary(levelname)
	if not allLevels[player.levelNumber][levelname] then
		if player.visited[levelname] then
			allLevels[player.levelNumber][levelname] = love.filesystem.load("Save "..selectedfile..'/Levels/'..levelname..'.lua')()
		else
			allLevels[player.levelNumber][levelname] = love.filesystem.load(level.getLevelFilePath(player.levelNumber,levelname))()
		end
	end
	local l = allLevels[player.levelNumber][levelname]
	
	for i,v in pairs(level.mustdefine) do
		l[i] = l[i] or v
	end
	enemydroplist = {}

	level.setmetatables(l)
	
	for i,self in pairs(l.allsoldiers) do
		if type(self) == 'table' then
			if self.xspeed > 0 then
				self.pic = soldierpics.right
			else
				self.pic = soldierpics.left
			end
		end
	end
	
	for i,self in pairs(l.allwizards) do
		if type(self) == 'table' then
			if self.xspeed > 0 then
				self.pic = wizardpics.right
			else
				self.pic = wizardpics.left
			end
		end
	end
		
	return l
end

function level.setmetatables(leveltable)
	local m = {[leveltable.enemySpawnPoints] = 'enemySpawnPoint',
		[leveltable.allsoldiers]='return enemy.soldier',
		[leveltable.allpawns] = {'return enemy.pawn',picanim='return animation'} ,
		[leveltable.allwizards] = {'return enemy.wizard',missiles={meta="return iceMissile"}},
		[leveltable.allmonkeys] = 'return enemy.monkey',
		[player.arrows] = 'return weapons.arrow',
		[enemydroplist] = 'enemydrop',
			}
	setmetatables(m)
	
	for i,v in pairs(player.weapons) do
		setmetatable(v,weapons[v.type])		
	end

	for i,v in pairs(player.weapons.bow.arrows) do
		if v.stuckTo then
			v.stuckTo = leveltable['all' .. v.stuckTo.type .. 's'][v.stuckTo.allindex]
		end
	end

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
				if type(metathing)=='table' then
					for i,v in pairs(obj[key]) do
						--print(metathing)
						setmetatable(v,loadstring(metathing.meta)())
					end
				elseif type(metathing)=='string' then
					setmetatable(obj[key],loadstring(metathing)())
				end
			else
				setmetatable(obj[key],_G[metathing])
			end
		end
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
	love.graphics.setColor(unpack(watercolor))
	for i,rect in ipairs(currentLevel.blocks) do
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
	local leveldraworder = {'water', 'grassydirt', 'dirt', 'sign'}
	local i = 1
	while i <= #leveldraworder do
		if a.type == leveldraworder[i] then
			break
		elseif b.type == leveldraworder[i] then
			return false
		end
		i = i + 1
	end

	return true 
end

function level.drawLevel()
	
	for i,rect in pairs(currentLevel.doors) do
		if collision.rectangles(rect.x,rect.y,rect.width,rect.height, getWorldScreenRect()) then
			love.graphics.setColor(255,255,255)
			if rect.double then
				love.graphics.draw(door.pic, rect.x, rect.y,0, rect.width/door.width/2, rect.height/door.height)
				love.graphics.draw(door.pic, rect.x+rect.width, rect.y,0, -rect.width/door.width/2, rect.height/door.height)
			else
				if rect.goesto == 'levelend' then
						drawBlur.rectangleInversePower(rect.x,rect.y,rect.width,rect.height,25,colors.getPulsingColors({255,255,0},{0,255,0},5),colors.getPulsingColors({255,255,0,0},{255,0,0,0},5),0.5,2)
				end
				love.graphics.setColor(255,255,255)
				love.graphics.draw(door.pic, rect.x, rect.y,0, rect.width/door.width, rect.height/door.height)
				
			end
		end
	end
	
	local l,t,w,h = getWorldScreenRect()
	if t + h > -64 then --Tile-draws a darker earth under y=-64
		local tilesize = 46		
		local left = math.floor( l /tilesize )  * tilesize
		local x = left
		local right = left + camera.width + tilesize
		local top = math.max(192,math.floor( t /tilesize )  * tilesize)
		local bottom = top + camera.height + tilesize
		local y = top
		love.graphics.setColor(128,128,128)
		while y < bottom  do
			while x < right do
				--love.graphics.draw(dirt.pic, x,y, 0, tilesize/dirt.width,tilesize/dirt.height)
				x = x + tilesize
			end
			y = y + tilesize
			x = left
		end
	end
	
	local sorted = {currentLevel.blocks[1]}
	local i = 2
	while i <= #currentLevel.blocks do
		local placed = false
		for x,y in ipairs(sorted) do
			if currentLevel.blocks[i] == nil then
				break
			end
			if not placed and level.drawOrderSort(currentLevel.blocks[i],y) then
				table.insert(sorted,x,currentLevel.blocks[i])
				placed = true
			end
		end
		if not placed then
			table.insert(sorted, i,currentLevel.blocks[i])
		end
		i = i + 1
	end
	currentLevel.blocks = sorted

	for i,rect in ipairs(currentLevel.blocks) do
		if collision.rectangles(rect.x,rect.y,rect.width,rect.height, getWorldScreenRect()) then
			if rect.type == 'dirt' or rect.type == "grassydirt" then
				if rect.color then 
					love.graphics.setColor(unpack(rect.color))
				else
					love.graphics.setColor(205,205,205)
				end
				local nx = math.ceil(rect.width/grassydirt.width)
				local ny = math.ceil(rect.height/grassydirt.height)
				for x = 0,nx-1 do
					if rect.type == 'grassydirt' then
						love.graphics.draw(grassydirt.pic,rect.x + x*rect.width/nx, rect.y)
					else
						love.graphics.draw(dirt.pic,rect.x + x*rect.width/nx, rect.y)
					end
					for y = 1,ny-1 do
						love.graphics.draw(dirt.pic,rect.x + x*rect.width/nx, rect.y + y*rect.height/ny)
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
				if rect.color then 
					love.graphics.setColor(unpack(rect.color))
				else
					love.graphics.setColor(255,255,255)
				end
				local nx = math.ceil(rect.width/stonebrick.width)
				local ny = math.ceil(rect.height/stonebrick.height)
				for x = 0,nx-1 do
					for y = 0,ny-1 do
						love.graphics.draw(stonebrick.pic,rect.x + x*rect.width/nx, rect.y + y*rect.height/ny)
					end
				end
			elseif rect.type ~= 'water' then
				love.graphics.setColor(127,30,200)
				love.graphics.rectangle('fill', rect.x, rect.y, rect.width, rect.height)
			end
			--love.graphics.setColor(0,0,0)
			--love.graphics.rectangle('line', rect.x,rect.y,rect.width,rect.height)
		end
	end

	
end

