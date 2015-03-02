playerfunctions = {}
--player._index = player

function playerfunctions.load()
	local newfile
	if love.filesystem.isFile("Save " .. selectedfile .. "/file " .. selectedfile .. ' player.lua') and love.filesystem.isFile("Save " .. selectedfile .. "/file " .. selectedfile .. " header.lua") and fileheaders[selectedfile] then
		--player = stringtotable(grant.table.load("file " .. selectedfile .. '.txt'))
		love.filesystem.load("Save " .. selectedfile .. "/file " .. selectedfile .. ' player.lua')()
		--player.arrows = {}
		newfile = false
		player.equippedWeapon = player.weapons.bow
	else
		newfile = true
		--------Get Character Name-----------
		local alphabet = {'q','w','e','r','t','y','u','i','o','p','a','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m'}
		oldkeypressed = love.keypressed
		oldmousepressed = love.mousepressed

		function love.keypressed(key)
			if key == 'escape' then
				love.event.quit()
			elseif key == 'backspace' then
				name = string.sub(name,1,string.len(name)-1)
				back = love.timer.getTime()
			elseif key == 'return' and string.len(name) > 0 then
				name = string.upper(string.sub(name,1,1)) .. string.lower(string.sub(name,2))
				done = true
			else
				for i,v in ipairs(alphabet) do
					if key == v then 
						if string.len(name) < 10 then
							name = name .. key:upper()
						end
						return
					end
				end
			end
		end
		function love.mousepressed(x,y,button)
		end
		love.graphics.setColor(200,200,200,100)
		love.graphics.rectangle("fill", 0,0,window.width,window.height)
		love.graphics.present()
		love.graphics.setColor(200,200,200,100)
		love.graphics.rectangle("fill", 0,0,window.width,window.height)
		
		done = false

		local rectwidth = 600
		local rectheight = 300
		
		local lineon = false
		back = true

		name = ""
		while not done and not QUIT do
			next_time = next_time + min_dt

			
			love.processEvents()
			love.timer.step()
			dt = love.timer.getDelta()
			
			love.window.setTitle(love.timer.getFPS())
			love.graphics.setColor(220,220,220)
			love.graphics.draw(greenrect.pic,window.width/2-rectwidth/2, window.height*0.4-rectheight/2, 0,rectwidth/greenrect.width,rectheight/greenrect.height)
			
			love.graphics.setColor(0,0,0)
			love.graphics.setFont(impactfont[36])
			love.graphics.print("Type your name and press Enter.",window.width/2 - impactfont[36]:getWidth("Type your name and press Enter.")/2,window.height*0.4-rectheight/2 + 54)
			
			
			love.graphics.setColor(255,255,255)
			love.graphics.rectangle("fill", window.width/2 - rectwidth*0.8/2, window.height*0.4-10, rectwidth*0.8, 40)
			
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle("line", window.width/2 - rectwidth*0.8/2, window.height*0.4-10, rectwidth*0.8, 40)
			
			love.graphics.setFont(neographfont[36])
			if lineon then
				love.graphics.print(name .. "|", window.width/2-neographfont[36]:getWidth(name)/2, window.height*0.4-10-6)
				if love.timer.getTime() - 0.5 > math.floor(love.timer.getTime()) then
					lineon = false
				end
			else
				love.graphics.print(name, window.width/2-neographfont[36]:getWidth(name)/2, window.height*0.4-10-6)
				if love.timer.getTime() - 0.5 <= math.floor(love.timer.getTime()) then
					lineon = true
				end
			end
			
			if back ~= true then
				if love.timer.getTime()-back > 0.3 then
					back = true
				end
			end
			
			if love.keyboard.isDown('backspace') then
				if back == true then
					name = string.sub(name,1,string.len(name)-1)
					back = love.timer.getTime()
				end
			end
			
			
			if not done then
				love.graphics.present()
			end
			
			-- FPS cap
			local cur_time = love.timer.getTime()
			if next_time <= cur_time then
				next_time = cur_time
			end
			love.timer.sleep(1*(next_time - cur_time))
		end

		love.mousepressed = oldmousepressed
		love.keypressed = oldkeypressed
		--------------------------------------------------
		
		
		player = playerfunctions.make(name)
				
	end
	
	
	formerplayer = player

	return newfile
end

function playerfunctions.make(name)
	local player = {}
	
	local playerobject = createObject({x = 0, y = 0, ygrav = 9.8, mass = 60, airdamping = 0})
	for i,v in pairs(playerobject) do -- -300 -150
		player[i] = v
	end
	player.name = name or "No Name"
	player.metadata = true
	
	player.width = 38--36--45
	player.height = 119--140
	player.drawwidth, player.drawheight = 38,119 --45,140
	
	player.speed = 30
	player.quick = {delay = 0.5,count = -1, speed = 1}
	player.runspeed = 2
	
	player.maxoxygenlevel = 10
	player.oxygenlevel = player.maxoxygenlevel
	player.breatherate = 2
	player.maxhp = 10
	player.hp = player.maxhp
	player.hurttime = 0
	player.maxhurttime = 2
	player.defaultxspeed = 0

	player.lastmoving = 'd'
	
	player.hurttext = {}
	player.hurttext.speed = 5
	player.hurttext.life = 3
	
	player.level = 1
	player.upoints = 0
	player.xp = 0
	player.gold = 0
	
	player.jumpability = 1
	player.maxjumps = 1
	player.jumps = 0
	
	player.location = "Birthing Place"
	player.visited = {}
	player.visited[player.location] = true
	player.door = false

	player.inwater = false

	player.minbuoyancy = 4
	player.maxbuoyancy = 20
	player.buoyancy = player.minbuoyancy

	player.wateragility = 1
	player.maxwateragility = 50

	player.mouthx = 36 * player.drawwidth/playerimages.picwidth

	player.mouthy = 162 * player.drawheight/playerimages.picheight
	player.mouthwidth = (68-36) * player.drawwidth/playerimages.picwidth
	player.mouthheight = (186-162) * player.drawheight/playerimages.picheight

	player.mouthinwater = false
	
	player.curanim = {}
	player.curanim.frame = false
	player.curanim.type = false
	player.curanim.delay = 0
	
	player.weapons = {bow = weapons.bow.make(50)}
	player.equippedWeapon = player.weapons.bow
	
	return player
end


function playerfunctions.update(dt)
	
	player.collide = false
	formerplayer = {}
	formerplayer.x = player.x
	formerplayer.y = player.y
	formerplayer.width, formerplayer.height = player.width, player.height
	
	if love.keyboard.isDown('[') then
		player.ygravity = 0 
	else
		player.ygravity = 9.8
	end

	if love.keyboard.isDown('u') then
		player.yspeed = 0
	end

	updateObject(player,dt)
	player.mouthinwater = false
	player.inlevel = false
	player.inwaterwidth = 0
	player.inwaterheight = 0
	player.inwater = false
	player.defaultxspeed = 0
	player.door = false

	
	player.indeathtrap = false
	if player.hp > 0 then
		-----Collide With Level----------
		for i,rect in pairs(level[player.location].blocks) do
			if rect.x == nil then
				error("Number " .. i .. ": " .. tabletostring(rect))
			end
			if collision.rectangles(rect.x, rect.y, rect.width,rect.height, player.x - player.width/2, player.y - player.height/2 , player.width , player.height, false) then
				player.collide = true
				rect.collide = true
				if not rect.permeable then
					--local direction = collision.direction.rectangles1(formerplayer.x-formerplayer.width/2, formerplayer.y-formerplayer.height/2, formerplayer.width, formerplayer.height,player.xspeed,player.yspeed, rect.x, rect.y, rect.width, rect.height,0,0)
					local direction = collision.direction.rectangles2(player.x-player.width/2, player.y-player.height/2, player.width, player.height,player.xspeed,player.yspeed, rect.x, rect.y, rect.width, rect.height,0,0)
					if direction == "right" or rect.direction == "right" then
						player.x = rect.x + rect.width + player.width/2
						player.xspeed = 0
						rect.direction = "right"
					elseif direction == "left" or rect.direction=="left" then
						player.x = rect.x - player.width/2
						player.xspeed = 0
						rect.direction = "left"
					elseif direction == "top" or rect.direction=="top" then
						if player.yspeed > 250 then
							playerfunctions.damage(math.max(1,math.floor(((player.yspeed-250)^0.5))))
							playerhurt = player.yspeed
						end
						player.y = rect.y - player.height/2
						player.yspeed = 0
						rect.direction = "top"
						player.jumps = 0
					elseif direction == "bottom" or rect.direction=="bottom" then
						rect.direction = "bottom" 
						player.yspeed = 0
						player.y = rect.y + rect.height + player.height/2
					end
					player.inlevel = true
				elseif rect.type == 'water' then
					if player.lastmoving == 'a' then
						if collision.rectangles(rect.x,rect.y,rect.width,rect.height, player.mouthx + player.x-player.drawwidth/2, player.mouthy + player.y-player.drawheight/2, player.mouthwidth,player.mouthheight) then
							player.mouthinwater = true
						end
					else
						if collision.rectangles(rect.x,rect.y,rect.width,rect.height, -player.mouthx + player.x+player.drawwidth/2, player.mouthy + player.y-player.drawheight/2, player.mouthwidth,player.mouthheight) then
							player.mouthinwater = true
						end
					end
					--[[
					local inwaterheight = 0
					if player.y-player.height/2 < rect.y then
						if player.y + player.height/2 > rect.y + rect.height then
							inwaterheight = inwaterheight + rect.height
						else
							inwaterheight = inwaterheight + (player.y+player.height/2)-rect.y
						end
					else
						if player.y + player.height/2 > rect.y + rect.height then
							inwaterheight = inwaterheight + rect.y+rect.height - (player.y-player.height/2)
						else
							inwaterheight = inwaterheight + player.height
						end
					end]]
					local xo, yo = collision.rectanglesOverlap(player.x-player.width/2, player.y-player.height/2, player.width, player.height, rect.x,rect.y,rect.width, rect.height)
					player.inwaterwidth = player.inwaterwidth + xo
					player.inwaterheight = player.inwaterheight + yo
					player.inwater = true
				elseif rect.type == 'deathtrap' then
					player.ygravity = math.getSign(rect.centery - player.y)*5
					player.xgravity = math.getSign(rect.centerx - player.x)*100
					player.indeathtrap = true
					if collision.rectangles(rect.x,rect.y,rect.width,rect.height, player.mouthx + player.x-player.drawwidth/2, player.mouthy + player.y-player.drawheight/2, player.mouthwidth,player.mouthheight) then
						player.mouthinwater = true
					end
					player.jumps = 0
				end
			else
				rect.direction = ""
				rect.collide = false
			end
		end

		for i,rect in pairs(level[player.location].doors) do
			if collision.rectangles(rect.x,rect.y,rect.width,rect.height, player.x-player.width/2, player.y-player.height, player.width, player.height) then
				local xo, yo = collision.rectanglesOverlap(rect.x,rect.y,rect.width,rect.height, player.x-player.width/2, player.y-player.height/2, player.width, player.height)
				if yo > 3/4*player.height and xo > player.width*2/3 then
					player.door = rect
				end
			end
		end
		-----------------------------
	
		------Collision With Enemies------
		for i,v in pairs(level[player.location].allpawns) do
			if not v.killed.type then
				if collision.rectangles(player.x - player.width/2, player.y-player.height/2, player.width,player.height, v:getCollisionBox()) then
					
					local direction = collision.direction.rectangles1(formerplayer.x - player.width/2, formerplayer.y-player.height/2, player.width, player.height,player.xspeed,player.yspeed,v.former.x - v.actualwidth/2,v.former.y-v.actualheight/2, v.actualwidth, v.actualheight,v.xspeed,v.yspeed)
					--local direction = collision.direction.rectangles2(player.x - player.width/2, player.y-player.height/2, player.width, player.height, player.xspeed,player.yspeed,v.x - v.actualwidth/2,v.y-v.actualheight/2, v.actualwidth, v.actualheight,v.xspeed,v.yspeed)
					if direction == "right" then
						--v.x = player.x  - player.width/2 - pawn.actualwidth/2
						v.xspeed = -math.abs(v.xspeed)
						playerfunctions.damage(math.random(3,5),"pawn")
					elseif direction == "left" then
						--v.x = player.x + player.width/2 + pawn.actualwidth/2
						v.xspeed = math.abs(v.xspeed)
						playerfunctions.damage(math.random(3,5),"pawn")
					elseif direction=="top"  then
						if not v.killed.type then
							v:die('squashed',0.5,{xspeed=0,yspeed=0,ygravity=0})
							player.xp = player.xp + v.xp
							player.yspeed = -100
							player.y = v.y - v.actualheight/2 - player.height/2
							player.jumps = 0
							print("Killed Pawn # " .. v.allindex)
							break
						end
					elseif direction == "bottom"  then
						v.y = player.y - player.height/2 - v.actualheight/2
						v.yspeed = 0
						playerfunctions.damage(math.random(7,11),"pawn")
					end
					
					print("Collide Dir: " .. tostring(direction))
				end
			end
		
		end
	
		--[[
		if player.hurttime <= 0 then
			for i,v in pairs(foe.foes) do
				if not v.killed.type then
					local left
					if v.xspeed > 0 then
						left = v.x - v.drawwidth/2 + 4*v.drawwidth/foe.picwidth
					else
						left = v.x + v.drawwidth/2 - 16*v.drawwidth/foe.picwidth
					end
					
					if collision.rectangles(player.x - player.width/2, player.y-player.height/2, player.width,player.height, left, v.y - v.drawheight*0.95 , 12*v.drawwidth/foe.picwidth , 16*v.drawwidth/foe.picwidth) then
						
						local direction = collision.direction.rectangles(formerplayer.x - player.width/2, formerplayer.y-player.height/2, player.width, player.height, left, v.y - v.drawheight*0.95 , 12*v.drawwidth/foe.picwidth , 16*v.drawwidth/foe.picwidth)
						if direction == "right" then
							--v.x = player.x  - player.width/2 - pawn.actualwidth/2
							--v.speed = -math.abs(v.speed)
						elseif direction == "left" then
							--v.x = player.x + player.width/2 + pawn.actualwidth/2
							--v.speed = math.abs(v.speed)
						elseif direction=="top"  then
							player.yspeed = -50
							playerfunctions.damage(math.random(3,5),"foe")							
						elseif direction == "bottom"  then
							--v.y = player.y - player.height/2 - pawn.actualheight/2
							--v.yspeed = 0
						end
					end
				end
			
			end
		end--if player.hurttime <= 0
		--]]
		----Move Player----

		if love.keyboard.isDown("a") then
			player.xspeed = -player.speed * player.quick.speed
			player.lastmoving = 'a'
		end
		if love.keyboard.isDown("d") then
			player.xspeed = player.speed * player.quick.speed
			player.lastmoving = 'd'
		end
	
		if not love.keyboard.isDown("a") and not love.keyboard.isDown("d") and player.xgravity == 0 or player.hp<= 0 then
			player.xspeed =  0
		end
		
		
		
		if love.keyboard.isDown("s") then
			if player.inwater then
				applyForce(player, 0, 100*player.mass*player.wateragility/player.maxwateragility,dt)
			else
				applyForce(player, 0, player.speed * player.mass,dt)
			end
		end

		if love.keyboard.isDown("w") then
			if player.inwater then
				applyForce(player, 0, -100* player.mass*player.wateragility/player.maxwateragility,dt)
			end
		end
		player.oxygenlevel = player.oxygenlevel - (math.abs(player.xspeed)/1--[[player.inwater]] * dt)*0.02


		if player.inwaterheight > player.height then
			player.inwaterheight = player.height
			player.jumps = 0
		elseif player.inwaterheight > player.height/3 then 
			player.jumps = 0
		end

		if player.inwaterwidth > player.width then
			player.inwaterwidth = player.width
		end

		if player.inwater then
			applyForce(player,0, -player.ygravity/200*(player.inwaterwidth*player.width/3*player.inwaterheight),dt)
			applyForce(player,-0.5/200*player.height*player.width/3*player.xspeed*math.abs(player.xspeed), -0.5/200*player.width*player.width/3*player.yspeed*math.abs(player.yspeed),dt)
		end
		player.xspeed = player.xspeed + player.defaultxspeed
	end -- if player.hp > 0
	
	
	if player.curanim.type then
		player.curanim.delay = player.curanim.delay + dt
		if player.curanim.delay > player.animation[player.curanim.type].delay then
			player.curanim.delay = 0
			player.curanim.frame = player.curanim.frame + 1
			if player.curanim.frame > player.animation[player.curanim.type].frames then
				player.curanim.frame = false
				player.curanim.type = false
			end
		end
	end
	
	if player.mouthinwater then
		player.oxygenlevel = player.oxygenlevel - dt
	elseif player.hp > 0 then
		player.oxygenlevel = player.oxygenlevel + dt * player.breatherate
	end
	
	if player.oxygenlevel > player.maxoxygenlevel then
		player.oxygenlevel = player.maxoxygenlevel
	elseif player.oxygenlevel < 0 then
		player.oxygenlevel = 0
		if player.hurttime <= 0 then
			playerfunctions.damage(math.random(3,5),"water")
		end
	end
	
	if player.hp <= 0 then
		player.hp = 0
		slowmotion = slowmotion - slowmotion*0.75 * dt
		camera.lock = false
		if player.hurttime/player.maxhurttime < 0.6 then
			states.gameover.load()
		end
	end	
	
	
	player.hurttime = player.hurttime - dt
	if player.hurttime < 0 then
		player.hurttime = 0
	end
	
	if slowmotion < 1 then
		slowmotion = slowmotion + (slowmotion)*dt*10
	elseif slowmotion > 1 then
		slowmotion = 1
	end
	
	
	if player.quick.count >= 0 and player.quick.count < player.quick.delay then
		player.quick.count = player.quick.count + dt
	else
		player.quick.count = -1
	end

	for i,v in ipairs(player.hurttext) do
		v.y = v.y - 10*dt
		v.life = v.life - dt
		if v.life <= 0 then
			table.remove(player.hurttext,i)
		end
	end
	
	for i,v in pairs(enemydroplist) do
		if v.wait <= 0 and collision.rectangles(player.x-player.width/2,player.y-player.height/2,player.width,player.height, v.x-v.width/2,v.y-v.height/2,v.width,v.height) then
			if v.type == 'arrow' then
				if player.weapons.bow.quiverSize-player.weapons.bow.arrowsLeft >= v.value then
					player.weapons.bow.arrowsLeft = player.weapons.bow.arrowsLeft + v.value
					enemydroplist[i] = nil
				else
					player.weapons.bow.arrowsLeft = player.weapons.bow.arrowsLeft + v.value
					enemydroplist[i] = nil
				end
			elseif v.type == 'health' and player.maxhp > player.hp then
				player.hp = math.min(player.hp+v.value,player.maxhp)
				enemydroplist[i] = nil
			end

		end
	end
end


function playerfunctions.draw()
	love.graphics.setColor(255,255,255)
	if player.curanim.type then
		love.graphics.draw(player.animationd[player.curanim.type][player.curanim.frame], player.x-player.drawwidth/2, player.y-player.drawheight/2,0 ,player.drawwidth/player.picwidth, player.drawheight/player.picheight)
	else
		if player.shooting == "aiming" then
			local x,y = getWorldPoint(love.mouse.getPosition())
			if  x > player.x then
				love.graphics.draw(playerimages.right, player.x-player.drawwidth/2, player.y-player.drawheight/2,0 ,player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
			else
				love.graphics.draw(playerimages.left, player.x-player.drawwidth/2, player.y-player.drawheight/2,0 ,player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
			end
		else
			if player.lastmoving == 'away' then
				love.graphics.draw(playerimages.away, player.x-player.drawwidth/2, player.y-player.drawheight/2,0, player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
				return
			elseif player.lastmoving == 'towards' then
				love.graphics.draw(playerimages.towards, player.x-player.drawwidth/2, player.y-player.drawheight/2,0, player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
				return
			elseif player.hurttime > 0 then
				if player.hp > 0 then
					love.graphics.setColor(255,200,200,135 + math.random(1,15)*6)
				else
					love.graphics.setColor(255,100,100,player.hurttime/player.maxhurttime*200)
					width = player.drawwidth*(player.hurttime/player.maxhurttime)^((player.maxhurttime-player.hurttime)^2*1000)
					height = player.drawheight*(player.hurttime/player.maxhurttime)^((player.maxhurttime-player.hurttime)^2*1000)
					if player.lastmoving == 'd' then
						love.graphics.draw(playerimages.right, player.x-width/2, player.y-height/2,0, width/playerimages.picwidth,height/playerimages.picheight)
					elseif player.lastmoving == 'a' then
						love.graphics.draw(playerimages.left,player.x-width/2, player.y-height/2,0, width/playerimages.picwidth,height/playerimages.picheight)
					end
					
					return
				end
			end
			if love.keyboard.isDown('d') or player.lastmoving == 'd' then
				love.graphics.draw(playerimages.right, player.x-player.drawwidth/2, player.y-player.drawheight/2,0 ,player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
			elseif love.keyboard.isDown('a') or player.lastmoving == 'a' then
				love.graphics.draw(playerimages.left, player.x-player.drawwidth/2, player.y-player.drawheight/2,0 ,player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
			end
			--[[
			elseif playerimages.front then
				love.graphics.draw(playerimages.front, player.x-player.drawwidth/2, player.y-player.drawheight/2,0 ,player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
			elseif playerimages.original then
				love.graphics.draw(playerimages.original, player.x-player.drawwidth/2, player.y-player.drawheight/2,0 ,player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
			end
			--]]
		end
		
	end

end

function playerfunctions.damage(damage,enemytype,x,y)
	if player.hurttime <= 0 and player.hp > 0 then
		local damage = damage or 1
		player.hp = player.hp - damage
		player.hurttime = player.maxhurttime
		--slowmotion = 0.05
		if player.hp <= 0 then
			slowmotion = 0.02
			player.yspeed = 0
			player.xspeed = 0
			
			love.audio.pause()
			music.dying.music:play()
		end
		local x = x or player.x
		local y = y or player.y
		table.insert(player.hurttext,{damage=damage,x=x,y=y,life=player.hurttext.life})
	end
end
