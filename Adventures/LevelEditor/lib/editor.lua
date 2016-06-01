
editor = {}

function editor.load(levelname)
	editor.x,editor.y = 0,0
	editor.state = "ready"
	editor.offsetx = 0
	editor.offsety =0
	editor.selected = nil
	editor.recttype = 1
	editor.leveltypes = {'grassydirt','dirt', 'water', 'sign','door','stonebrick'}

	editor.spawnpointradius = 10
	editor.level = levelname

	editor.hover = {}
	function editor.sortHover(a,b)
		if a[1].type == b[1].type then
			return a.index < b.index			
		end
		local i = 1
		while i <= #level.drawOrder do
			if a[1].type == level.drawOrder[i] then
				break
			elseif b[1].type == level.drawOrder[i] then
				return false
			end
			i = i + 1
		end

		return true 
	end

	editor.leveleditables = {blocks=true,doors=true,enemySpawnPoints=true,allpawns=true,allsoldiers=true}

	editor.keydisplay = false
	editor.keykey = 
	[[
	"escape"    Quit
	'q'         Abort
	'-'         Zoom Out
	'='         Zoom In
	'g'         Toggle Grid
	'k'         Toggle Key key

	'd'         Delete Mode
	'a'         Add Rectangle Mode
	'm'         Move Mode
	'n'         Add Node Mode
	'c'         Connect Node Mode
	't'         Change Rectangle Type

	Right click to bring up menu
	]]

	editor.statemenu = menu.make({'Add Mode', 'Delete Mode', 'Move Mode'},defaultfont[14])
	editor.statemenu.values = {'ready','delete','moving'}
	editor.statemenu.title = 'Change Mouse Mode'
	
	editor.blockmenu = menu.make({'Grassy Dirt', 'Dirt', 'Water', 'Sign', 'Door', 'Stone Brick'},defaultfont[14])
	editor.blockmenu.values = {'grassydirt','dirt','water', 'sign','door', 'stonebrick'}
	editor.blockmenu.title = 'Change Block Material'

	editor.spawnmenu = menu.make({'Pawn Spawn', 'Soldier Spawn','Wizard Spawn','Monkey Spawn'},defaultfont[14])
	editor.spawnmenu.values = {'pawn','soldier','wizard','monkey'}
	editor.spawnmenu.title = 'Add Spawnpoint'
	
	editor.mainmenu = menu.make({editor.statemenu,editor.blockmenu,editor.spawnmenu},defaultfont[14])

end

function editor.rounding()
 return love.keyboard.isDown('rctrl') or love.keyboard.isDown('lctrl')
end

function editor.getContextMenu(hover)  -- given an item in editor.hover of the form 
										--{theblock,index=theindex,leveltype=suchasblocks}
	local m
	if hover.leveltype == 'blocks' then
		local change = menu.make({'Grassy Dirt', 'Dirt', 'Water', 'Sign', 'Stone Brick'},defaultfont[14])
		change.title="Change Material"
		change.values = {'grassydirt','dirt','water', 'sign','door', 'stonebrick'}
		
		local grabcorner = menu.make({'Top Left','Top Right', 'Bottom Left', 'Bottom Right'})
		grabcorner.title = 'Grab Corner'
		m = menu.make({change,grabcorner,'Move','Delete','Zoom to Fit'},defaultfont[14])
	elseif hover.leveltype == 'doors' then
		m = menu.make({'Move','Delete','Zoom to Fit'},defaultfont[14])
	elseif hover.leveltype == 'enemySpawnPoints' then
		local change = menu.make({'Pawn', 'Soldier', 'Wizard', 'Monkey'},defaultfont[14])
		change.title="Change Enemy to Spawn"
		change.values = {'pawn','soldier','wizard','monkey'}
		
		m = menu.make({change,'Move','Delete','Zoom to Fit'},defaultfont[14])
	elseif hover.leveltype == 'allpawns' then
		m = menu.make({})
	elseif hover.leveltype == 'allsoldiers' then
		m = menu.make({})
	end
	return m
end

function editor.mousepressed(x,y,button)
	wx,wy = camera.getWorldPoint(x,y)

	if button == 1 then
		if menu.anyOn() then
			local hover = false
			for i=1,#menu.onmenus do
				v = menu.onmenus[i]
				if v.hover then
					if type(v.items[v.hover]) == 'table' then
						v.items[v.hover]:setPosition(v.x + v.width/8,v.y)
						v.items[v.hover]:show()
						menu.onmenus[2]:hide()
					else
						if v == editor.statemenu then
							editor.state = v.values[v.hover]
							editor.selected = nil
						elseif v == editor.blockmenu then
							editor.recttype = v.hover
							editor.state = 'ready'
						elseif v == editor.spawnmenu then
							local x
							local y
							if editor.rounding() then
								x = wx
								y = wy
							else
								x = math.round(wx,grid.spacing)
								y = math.round(wy,grid.spacing)
							end
							local t = enemySpawnPoint.make{x=x,y=y,type=v.values[v.hover],display=true,spawnrate=1}
							table.insert(level[editor.level].enemySpawnPoints,1,t)
						elseif v == editor.contextMenu then
							print(v.items[v.hover])
						elseif v.title == 'Change Material' then
							editor.selected.type = v.values[v.hover]
						elseif v.title == 'Grab Corner' then
						
						end
						v:hide()
					end
					break
				else
					v:hide()
				end
			end
		else
			if y < hud.y+hud.height then
				hud.mousepressed(x,y,button)
				return
			end
			if editor.state == 'ready' then
				table.insert(level[editor.level].blocks, 1, {})
				if editor.rounding() then
					level[editor.level].blocks[1].x,level[editor.level].blocks[1].y = wx,wy
				else
					level[editor.level].blocks[1].x,level[editor.level].blocks[1].y = math.round(wx,grid.spacing),math.round(wy,grid.spacing)
				end
				level[editor.level].blocks[1].width,level[editor.level].blocks[1].height = 0,0
				level[editor.level].blocks[1].type = editor.leveltypes[editor.recttype]
				editor.state = 'adding'
				editor.selected = level[editor.level].blocks[1]
			elseif editor.state == 'delete' then
				if editor.hover[#editor.hover] then
					local v = editor.hover[#editor.hover]
					table.remove(level[editor.level][v.leveltype],v.index)				
				end
			elseif editor.state == 'moving' then
				
				if editor.hover[#editor.hover] then
					local v = editor.hover[#editor.hover][1]
					editor.selected = v
					if editor.rounding() then
						editor.offsetx = wx - v.x
						editor.offsety = wy - v.y
					else
						editor.offsetx = math.round(wx,grid.spacing) - v.x
						editor.offsety = math.round(wy,grid.spacing) - v.y
					end
					--table.remove(level[editor.level][a],i)
					--table.insert(level[editor.level][a],v)
				end

			end
		end
	elseif button == 2 then
	
		for i,v in pairs(menus) do
			v:hide()
		end
		
		if editor.hover[#editor.hover] then
			editor.contextMenu = editor.getContextMenu(editor.hover[#editor.hover])
			editor.contextMenu:show()
			editor.contextMenu.x,editor.contextMenu.y = x,y
		else
			editor.mainmenu:show()
			editor.mainmenu.x,editor.mainmenu.y = x,y
		end
	end

end
