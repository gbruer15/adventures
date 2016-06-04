


function savegame(savefile)
	if type(savefile) == "boolean" then
		error("savefile == " .. tostring(savefile))
	end
	--]]

	if not love.filesystem.isDirectory("Save " .. savefile) then
		love.filesystem.createDirectory("Save " .. savefile)
	end
	local basename = "Save " .. savefile .. "/file " .. savefile .. " "

	local ignoredKeys = {'bones', 'bonePics', 'body', 'keyFrames', 'bodyAnimations'}

	love.filesystem.write(basename .. 'player.lua', 'return ' .. tableUtilities.tabletostring(player,true,ignoredKeys))

	local head = {}
	for i,v in ipairs(headerkeys) do
		head[v] = player[v]
	end
	love.filesystem.write(basename .. 'header.lua','return ' .. tableUtilities.tabletostring(head))

	if not love.filesystem.isDirectory("Save " .. savefile .. "/Levels") then
		love.filesystem.createDirectory("Save " .. savefile .. "/Levels")
	end
	
	print(tableUtilities.tabletostring(player.visited))
	for location in pairs(player.visited) do
		local levelstring = "local level = {}\nlevel.levelname = '" .. location .. "'\n"
		local l = level.loadSecondary(location)
		for i,v in pairs(level.mustdefine) do
			local startstring = "\n\nlevel." .. i .. " = "
			local newitem = l[i]--level.getLevel(player.levelNumber,location)[i]
			if type(newitem) == 'table' then
				if i == 'enemySpawnPoints' then
					print(tableUtilities.tabletostring(newitem))
					levelstring = levelstring .. startstring .. tableUtilities.tabletostring(newitem,true,{'enemies'})
				else
					levelstring = levelstring .. startstring .. tableUtilities.tabletostring(newitem,true)
				end
			else
				levelstring = levelstring .. startstring .. tostring(newitem)
			end
		end
		
		for i,v in pairs(level.mainLevelNames) do
			if location == v then
				levelstring = levelstring.."\n\nlevel.startingPlayer = " .. tableUtilities.tabletostring(l.startingPlayer)
				break
			end
		end
		
		levelstring = levelstring .. "\nreturn level"
		love.filesystem.write("Save " .. savefile .. "/Levels/".. location .. '.lua',levelstring)
	end

	--[[
	grant.table.save(player,"Save" .. savefile .. "/file " .. savefile .. 'player.txt')

	grant.table.save(level[player.location], "Save " .. savefile .. "/file " .. savefile .. ' level.txt')
	local head = {}
	for i,v in ipairs(headerkeys) do
		head[v] = player[v]
	end
	grant.table.save(head,"Save " .. savefile .. "/file " .. savefile .. ' header.txt')
	--]]
end
