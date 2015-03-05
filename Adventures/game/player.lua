playerfunctions = {}
--player._index = player

function playerfunctions.load()
	local newfile
	if love.filesystem.isFile("Save " .. selectedfile .. "/file " .. selectedfile .. ' player.lua') and love.filesystem.isFile("Save " .. selectedfile .. "/file " .. selectedfile .. " header.lua") then --and fileheaders[selectedfile] then
		--player = stringtotable(grant.table.load("file " .. selectedfile .. '.txt'))
		player = love.filesystem.load("Save " .. selectedfile .. "/file " .. selectedfile .. ' player.lua')()
		--player.arrows = {}
		newfile = false
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

	playerfunctions.makeBody()

	if selectedfile == 'one' then
		player.color = {254,63,3}
	elseif selectedfile == 'two' then
		player.color = {63,254,3}
	else
		player.color = {3,63,254}
	end
	
	formerplayer = player

	return newfile
end

	--[[Defined awhile down: playerfunctions.armPivotx = 92
						 playerfunctions.armPivoty = 232
						 playerfunctions.armAngle = math.atan(232/92)]]
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
	
	player.armOffsetX = (playerfunctions.armPivotXRelPerson - playerimages.picwidth/2) * player.drawwidth/playerimages.picwidth
	player.armOffsetY = (playerfunctions.armPivotYRelPerson - playerimages.picheight/2) * player.drawheight/playerimages.picheight
	--player.armMag = ((playerfunctions.armPivotx* player.width/playerimages.picwidth)^2 + (playerfunctions.armPivoty* player.height/playerimages.picheight)^2)^0.5
	player.armMagFromPCenter = ((player.armOffsetX)^2 + (player.armOffsetY)^2)^0.5
	
	player.armLength = ((playerfunctions.armXLength*player.drawwidth/playerimages.picwidth)^2 + (playerfunctions.armYLength*player.drawheight/playerimages.picheight)^2)^0.5
	--player.armLengthAngle = math.atan(playerfunctions.armYLength/playerfunctions.armXLength)
	player.armMagFromArmPic= ((playerfunctions.armPivotXRelArm*player.drawwidth/playerimages.picwidth)^2 + (playerfunctions.armPivotYRelArm*player.drawheight/playerimages.picheight)^2)^0.5
	
	player.armAngle = 0
	
	player.wheelOffsetX = -3*player.drawwidth/playerimages.picwidth
	player.wheelOffsetY = 214*player.drawheight/playerimages.picheight
	player.wheelCenterX = player.x+player.wheelOffsetX
	player.wheelCenterY = player.y+player.wheelOffsetY
	player.wheelRadius = 134*player.drawwidth/playerimages.picwidth
	player.wheelPicDiag = player.wheelRadius*math.sqrt(2)
	player.wheelAngle = 0
	player.wheelAspeed = player.xspeed/player.wheelRadius
	
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
	player.facing = 'right'
	
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
	
	player.location = "Level Select"--"Birthing Place"
	player.levelNumber = 0
	player.visited = {}
	--player.visited[player.location] = true
	player.door = false

	player.frozen = 0
	player.maxFrozen = 2.5
	
	player.inwater = false
	player.onground = false

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
	
	player.weapons = {
					bow = weapons.bow.make(50)
					,sword = weapons.sword.make()
					,none = weapons.none.make()
				}
	player.arrows = {}
	player.equippedWeapon = 'none'
	
	return player
end

function playerfunctions.makeBody()
	player.bones = {}

	player.bones.headBone = bone.make{id='head',startPoint={225,170},endPoint={225,130},adamp=3,lowerConstraint=-math.pi*0.75,upperConstraint=-math.pi*0.25}
	player.bones.backarmBone = bone.make{id='backarm',startPoint={220,202}, aspeed=0,length=82,absAngle=70.3*math.pi/180,adamp=2.5,upperConstraint=math.pi*0.75,lowerConstraint=-math.pi/2}
	player.bones.forearmBone = bone.make{id='forearm',parent=player.bones.backarmBone, aspeed=0,length=94,relAngle=-30*math.pi/180,adamp=2.5,lowerConstraint=-math.pi*0.7,upperConstraint=-15*math.pi/180}
	---89.3*math.pi/180
	player.bones.fistBone = bone.make{id='fist',parent=player.bones.forearmBone, aspeed=0,length=12,relAngle=0,adamp=2.5,upperConstraint=20/180*math.pi,lowerConstraint=-30/180*math.pi}
	player.bones.backbackarmBone=bone.make{id='backba',startPoint={230,196},aspeed=0,length=82,absAngle=-10.3*math.pi/180,adamp=1.5,upperConstraint=math.pi*0.75,lowerConstraint=-math.pi/2}
	player.bones.backforearmBone=bone.make{id='backfa',parent=player.bones.backbackarmBone,aspeed=0,length=94,relAngle=-15*math.pi/180,adamp=1.5, lowerConstraint=-math.pi*0.7,upperConstraint=-15*math.pi/180}
	
	player.bones.swordBone = bone.make{id='sword',parent=player.bones.fistBone, length=100, relAngle=-math.pi/2,adamp=4}
	player.bones.wheelAttachmentBone = bone.make{id='wheelattach',startPoint={225,342},length=120,absAngle=math.pi/2}
	player.bones.wheelBone = bone.make{id='wheel',parent=player.bones.wheelAttachmentBone,length=67,relAngle=-math.pi/2,adamp=1}
	
	player.bones.spineBone = bone.make{id='spine',startPoint={225,492},length=259,absAngle=-math.pi/2,adamp=4, children={player.bones.backarmBone,player.bones.backbackarmBone,player.bones.headBone}, noConnection=true,lowerConstraint=-math.pi/2-20/180*math.pi,upperConstraint=-math.pi/2+30/180*math.pi}
	
	for i,b in pairs(player.bones) do
		b.upperConstraint = false
		b.lowerConstraint = false
	end
	player.bonePics = {}
	player.bonePics.torsoPic = bonePicture.make(love.graphics.newImage('Art/PlayerParts/torso.png'),{relPivotPoint={54,326},bonePicAngle=math.pi/2, bone=player.bones.spineBone})
	
	player.bonePics.fistPic = bonePicture.make(love.graphics.newImage('Art/PlayerParts/fist.png'),{relPivotPoint={15,8}, bonePicAngle=-52*math.pi/180, bone=player.bones.fistBone})
	
	player.bonePics.headPic = bonePicture.make(love.graphics.newImage('Art/PlayerParts/head.png'),{relPivotPoint={70,184},bonePicAngle=math.pi/2,bone=player.bones.headBone})
	player.bonePics.forearmPic = bonePicture.make(love.graphics.newImage('Art/PlayerParts/forearm.png'),{relPivotPoint={20,13},bonePicAngle=-61.8/180*math.pi,bone=player.bones.forearmBone})
	player.bonePics.backarmPic = bonePicture.make(love.graphics.newImage('Art/PlayerParts/backarm.png'),{relPivotPoint={20,15},bonePicAngle=-88/180*math.pi,bone=player.bones.backarmBone})
	
	player.bonePics.backforearmPic = bonePicture.make(love.graphics.newImage('Art/PlayerParts/back forearm.png'),{relPivotPoint={20,13},bonePicAngle=-61.8/180*math.pi,bone=player.bones.backforearmBone,color={160,160,160}})
	
	player.bonePics.backbackarmPic = bonePicture.make(love.graphics.newImage('Art/PlayerParts/back backarm.png'),{relPivotPoint={20,15},bonePicAngle=-88/180*math.pi,bone=player.bones.backbackarmBone,color={160,160,160}})
	
	player.bonePics.swordPic = bonePicture.make(love.graphics.newImage('Art/PlayerParts/sword.png'),{relPivotPoint={100,494},bonePicAngle=math.pi/2,bone=player.bones.swordBone,drawheight=200,scale=true})
	
	player.bonePics.wheelPic = bonePicture.make(love.graphics.newImage('Art/PlayerParts/wheel.png'),{relPivotPoint={67,67}, bone=player.bones.wheelBone})
	
	
	player.body = body.make{loneBones={player.bones.wheelAttachmentBone}
																	,bonePics={
																		player.bonePics.backbackarmPic
																		,player.bonePics.backforearmPic
																		,player.bonePics.torsoPic
																		,player.bonePics.wheelPic
																		,player.bonePics.headPic
																		,player.bonePics.swordPic
																		,player.bonePics.backarmPic
																		,player.bonePics.forearmPic
																		,player.bonePics.fistPic
																	}
																	,x=225
																	,y=235
																	,adamp=1
																	,airdamping=1}
	player.body:setScale(player.width/45,player.height/140)


	walkSpeed = 1
	
	local t = 0.8
	player.keyFrames = {
		backarmBone={bodyRelAngle={60,93,60},time={t,t},bounce=true}
		,forearmBone={relAngle={-50,-10,-50},time={t,t}, bounce=true}
		,backbackarmBone={bodyRelAngle={93,60,93},time={t,t},bounce=true}
		,backforearmBone={relAngle={-10,-50,-10},time={t,t}, bounce=true}
	 }
	
	playerfunctions.setupAnimation()
	
	--shrinkAnim = animation.make(0.7,1.5,1,false,true)


end

function playerfunctions.setupAnimation()
	player.bodyAnimations = {}
	for i,bodypart in pairs(player.keyFrames) do
		player.bodyAnimations[i] = {}
		for valuename,b in pairs(bodypart) do
			if valuename ~= 'time' and valuename ~= 'bounce' and valuename~= 'loop' then
				player.bodyAnimations[i][valuename] = {}
				local n = 1
				while n < #b do
					if b[n] and b[n+1] then
						player.bodyAnimations[i][valuename][n] = animation.make(b[n]/180*math.pi,b[n+1]/180*math.pi,bodypart.time[n],bodypart.loop)
					end
					n = n+1
				end
			end
		end
	end
end

function playerfunctions.setupSpecificBoneAnimation(boneName, infoTable)
	player.bodyAnimations[boneName] = {}
	for valuename,b in pairs(infoTable) do
		if valuename ~= 'time' and valuename ~= 'bounce' then
			player.bodyAnimations[boneName][valuename] = {}
			local n = 1
			while n < #b do
				if b[n] and b[n+1] then
					player.bodyAnimations[boneName][valuename][n] = animation.make(b[n]/180*math.pi,b[n+1]/180*math.pi,infoTable.time[n],false)
				end
				n = n+1
			end
		end
	end
end

function playerfunctions.updateAnimation(dt)
	for bodypartname,v in pairs(player.bodyAnimations) do
		for valuename,animationlist in pairs(v) do
			if animationlist[1] then
				animationlist[1]:update(dt)
				if valuename == 'bodyRelAngle' then
					player.bones[bodypartname]:setBodyRelAngle(animationlist[1].value)
				else
					player.bones[bodypartname][valuename] = animationlist[1].value
				end
				if animationlist[1].numloops > 0 and not animationlist[1].loop then
					table.remove(animationlist,1)
					if #animationlist == 0 and player.keyFrames[bodypartname].bounce then
						playerfunctions.setupSpecificBoneAnimation(bodypartname,player.keyFrames[bodypartname])
					end
				end
			end
		end
	end
	
	--print('\n\n\n')
end


function playerfunctions.update(dt)
	for i,b in ipairs(player.arrows) do
		if b:update(dt)	then
			table.remove(player.arrows,i)
		end
	end
	
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
	
	if player.onground then
		player.wheelAngle = player.wheelAngle + player.xspeed/player.wheelRadius*dt
	end
	
	player.mouthinwater = false
	player.inlevel = false
	player.inwaterwidth = 0
	player.inwaterheight = 0
	player.inwater = false
	player.defaultxspeed = 0
	player.door = false
	player.onground = false
	
	player.indeathtrap = false
	if player.hp > 0 then
		-----Collide With Level----------
		for i,rect in pairs(currentLevel.blocks) do
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
						player.onground = true
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
		
		
		for i,rect in pairs(currentLevel.doors) do
			if collision.rectangles(rect.x,rect.y,rect.width,rect.height, player.x-player.width/2, player.y-player.height, player.width, player.height) then
				local xo, yo = collision.rectanglesOverlap(rect.x,rect.y,rect.width,rect.height, player.x-player.width/2, player.y-player.height/2, player.width, player.height)
				if yo > 3/4*player.height and xo > player.width*2/3 then
					player.door = rect
				end
			end
		end
		-----------------------------
	
		------Collision With Enemies------
		for i,v in pairs(currentLevel.allpawns) do
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
						v:die('squashed',0.5,{xspeed=0,yspeed=0,ygravity=0})
						player.xp = player.xp + v.xp
						player.yspeed = -100
						player.y = v.y - v.actualheight/2 - player.height/2
						player.jumps = 0
						--print("Killed Pawn # " .. v.allindex)
						break
					elseif direction == "bottom"  then
						v.y = player.y - player.height/2 - v.actualheight/2
						v.yspeed = 0
						playerfunctions.damage(math.random(7,11),"pawn")
					end
					
					--print("Collide Dir: " .. tostring(direction))
				end
			end
		
		end
		
		for i,v in pairs(currentLevel.allsoldiers) do
			if not v.killed.type then
				if collision.rectangles(player.x - player.width/2, player.y-player.height/2, player.width,player.height, v:getSpearHeadBox()) then
					
					local direction = collision.direction.rectangles1(formerplayer.x - player.width/2, formerplayer.y-player.height/2, player.width, player.height,player.xspeed,player.yspeed,v:getSpearHeadBox(v.former.x,v.former.y))
					--local direction = collision.direction.rectangles2(player.x - player.width/2, player.y-player.height/2, player.width, player.height, player.xspeed,player.yspeed,v.x - v.actualwidth/2,v.y-v.actualheight/2, v.actualwidth, v.actualheight,v.xspeed,v.yspeed)
					if direction == "right" then
						
					elseif direction == "left" then
						
					elseif direction=="top"  then
						playerfunctions.damage(math.abs(math.ceil(math.random(1,2)*player.yspeed/10)),"soldier")
						player.yspeed = -50
					elseif direction == "bottom"  then
						
					end
					
				end
			end
		
		end
		
		for i,v in pairs(currentLevel.allwizards) do
			if not v.killed.type then
				for n,m in ipairs(v.missiles) do
					if collision.rectangleCircle(player.x - player.width/2, player.y-player.height/2, player.width,player.height, m:getSnowball()) then
						player.frozen = player.frozen + m.icePower
						if player.frozen > player.maxFrozen then
							player.frozen = player.maxFrozen
						end
						m.destroy = true
					end
				end
			end
		
		end

		----Move Player----
	
		local lastLastmoving = player.lastmoving
		
		if love.keyboard.isDown("a") then
			player.xspeed = -player.speed * player.quick.speed
			player.lastmoving = 'a'
		end
		if love.keyboard.isDown("d") then
			player.xspeed = player.speed * player.quick.speed
			player.lastmoving = 'd'
		end
		if player.lastmoving ~= lastLastmoving then
			--playerfunctions.changeDirection()
		end
		
		local lastFacing = player.facing
		local x,y = getWorldPoint(love.mouse.getPosition())
		if player.equippedWeapon == 'sword' then
			if player.weapons.sword.state == 'ready' then
				if x < player.x then
					player.facing = 'left'
				else
					player.facing = 'right'
				end
			end
		elseif player.equippedWeapon == 'bow' then
			if true then --player.weapons.bow.state == 'aiming' then
				if x < player.x  then
					player.facing = 'left'
				else
					player.facing = 'right'
				end
			end
		elseif player.equippedWeapon == 'none' then
			if true then
				if player.lastmoving == 'a'  then
					player.facing = 'left'
				else
					player.facing = 'right'
				end
			end
		end
		
		if player.facing ~= lastFacing then
			playerfunctions.changeDirection()
		end
		

		if player.frozen > 0 then
			player.xspeed = player.xspeed/(2^player.frozen)
			--print(player.frozen)
			player.frozen = player.frozen - dt
		
			if player.frozen < 0 then
				player.frozen = 0
			end
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
	
	player.body.x = player.x
	player.body.y = player.y
	--player.body:setScale(player.width/45,player.height/140)
	player.body:setScale(1,1)

	player.body:scale(player.drawwidth/playerimages.picwidth,player.drawheight/playerimages.picheight)
	
	--playerfunctions.updateAnimation(dt*math.abs(player.xspeed)/player.speed)
	if player.onground then
		player.bones.wheelBone.aspeed = player.xspeed/player.bones.wheelBone.length
	end

	player.body:update(dt)
	
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
	love.graphics.setFont(impactfont[20])
	love.graphics.setColor(0,0,0)
	love.graphics.print("backarm Angle: " .. player.bones.backarmBone.relAngle,0,0)
	love.graphics.print("backarm lower: " .. tostring(player.bones.backarmBone.lowerConstraint),0,25)
	love.graphics.print("backarm upper: " .. tostring(player.bones.backarmBone.upperConstraint),0,50)
	if true then
		love.graphics.setColor(0,0,0)
		love.graphics.setLineWidth(14*player.body.xscale)
		love.graphics.line(player.bones.spineBone.startPoint[1],player.bones.spineBone.startPoint[2],player.bones.spineBone.endPoint[1],player.bones.spineBone.endPoint[2])
	
		player.body:draw(false,false)
		return 
	end

	if player.curanim.type then
		love.graphics.draw(player.animationd[player.curanim.type][player.curanim.frame], player.x-player.drawwidth/2, player.y-player.drawheight/2,0 ,player.drawwidth/player.picwidth, player.drawheight/player.picheight)
	else
		local frozenProp = player.frozen/player.maxFrozen
		local torsoColor = {player.color[1] * (1-frozenProp), (140-player.color[2])*(frozenProp)+player.color[2], (255-player.color[3])*(frozenProp)+player.color[3],255} --(0,140,255)
		local otherColor = {255 * (1-frozenProp), (140-255)*(frozenProp)+255, 255,255}
		if player.hurttime > 0 then
			if player.hp > 0 then
				torsoColor[4] = 135 + math.random(1,15)*6
				otherColor[4] = torsoColor[4]
			else
				torsoColor[4] = player.hurttime/player.maxhurttime*200
				otherColor[4] = torsoColor[4]
				love.graphics.setColor(torsoColor)
				local scale = (player.hurttime/player.maxhurttime)^((player.maxhurttime-player.hurttime)^2*1000)
				width = player.drawwidth*scale
				height = player.drawheight*scale
				if player.facing == 'right' then--player.lastmoving == 'd' then
					love.graphics.draw(playerimages.right, player.x-width/2, player.y-height/2,0, width/playerimages.picwidth,height/playerimages.picheight)
					
					love.graphics.setColor(255,255,255)
					playerfunctions.drawWheel(scale)
					
					love.graphics.setColor(torsoColor)
					love.graphics.draw(playerimages.rightTorso, player.x-width/2, player.y-height/2,0 ,width/playerimages.picwidth, height/playerimages.picheight)
				else--if player.lastmoving == 'a' then
					love.graphics.draw(playerimages.left,player.x-width/2, player.y-height/2,0, width/playerimages.picwidth,height/playerimages.picheight)
					
					love.graphics.setColor(255,255,255)
					playerfunctions.drawWheel(scale)
					
					love.graphics.setColor(torsoColor)
					love.graphics.draw(playerimages.leftTorso, player.x-width/2, player.y-height/2,0 ,width/playerimages.picwidth, height/playerimages.picheight)
				end
				
				if player.equippedWeapon == 'sword' then
					player.weapons[player.equippedWeapon]:draw()
				end
						
				love.graphics.setColor(torsoColor)
				playerfunctions.drawArm(width,height,scale)
			
				if player.equippedWeapon == 'bow' then
					player.weapons[player.equippedWeapon]:draw()
				end
				
				return
			end
		end
		
		if player.lastmoving == 'away' then
			love.graphics.setColor(otherColor)
			love.graphics.draw(playerimages.away, player.x-player.drawwidth/2, player.y-player.drawheight/2,0, player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
		elseif player.lastmoving == 'towards' then
			love.graphics.setColor(otherColor)
			love.graphics.draw(playerimages.towards, player.x-player.drawwidth/2, player.y-player.drawheight/2,0, player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
		elseif player.facing == 'right' then
			love.graphics.setColor(otherColor)
			love.graphics.draw(playerimages.right, player.x-player.drawwidth/2, player.y-player.drawheight/2,0 ,player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
			
			love.graphics.setColor(255,255,255)
			playerfunctions.drawWheel()
			
			love.graphics.setColor(torsoColor)
			love.graphics.draw(playerimages.rightTorso, player.x-player.drawwidth/2, player.y-player.drawheight/2,0 ,player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
			
			if player.equippedWeapon == 'sword' then
				player.weapons[player.equippedWeapon]:draw()
			end
						
			love.graphics.setColor(torsoColor)
			playerfunctions.drawArm()
			
			if player.equippedWeapon == 'bow' then
				player.weapons[player.equippedWeapon]:draw()
			end
		else
			love.graphics.setColor(otherColor)
			love.graphics.draw(playerimages.left, player.x-player.drawwidth/2, player.y-player.drawheight/2,0 ,player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
			
			love.graphics.setColor(255,255,255)
			playerfunctions.drawWheel()
			
			love.graphics.setColor(torsoColor)
			love.graphics.draw(playerimages.leftTorso, player.x-player.drawwidth/2, player.y-player.drawheight/2,0 ,player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
			
			if player.equippedWeapon == 'sword' then
				player.weapons[player.equippedWeapon]:draw()
			end
			
			love.graphics.setColor(torsoColor)
			playerfunctions.drawArm()
			
			
			if player.equippedWeapon == 'bow' then
				player.weapons[player.equippedWeapon]:draw()
			end
		end
		--[[
		elseif playerimages.front then
			love.graphics.draw(playerimages.front, player.x-player.drawwidth/2, player.y-player.drawheight/2,0 ,player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
		elseif playerimages.original then
			love.graphics.draw(playerimages.original, player.x-player.drawwidth/2, player.y-player.drawheight/2,0 ,player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
		end
		--]]
		
	end
	
	for i,v in ipairs(player.arrows) do
		v:draw()
	end
	
	love.graphics.setFont(impactfont[20])
	--local t = love.timer.getTime()
	for i,v in ipairs(player.hurttext) do
		love.graphics.setColor(200,10,10, 255*v.life/player.hurttext.life)
		love.graphics.print("-" .. v.damage, v.x,v.y)
	end
			
end

playerfunctions.armPivotXRelPerson = 92
playerfunctions.armPivotYRelPerson = 232
playerfunctions.armAngle = math.atan(playerfunctions.armPivotYRelPerson/playerfunctions.armPivotXRelPerson)
playerfunctions.armXLength = (45-26)
playerfunctions.armYLength = (145-19)
playerfunctions.armLengthAngle = math.atan(playerfunctions.armYLength/playerfunctions.armXLength)

playerfunctions.armPivotXRelArm = 27
playerfunctions.armPivotYRelArm = 20
playerfunctions.armPivotRelArmAngle = math.atan(playerfunctions.armPivotYRelArm /playerfunctions.armPivotXRelArm)
function playerfunctions.drawArm(width,height,scale)
	width = width or player.drawwidth
	height = height or player.drawheight
	scale = scale or 1
	--player.armAngle = math.round(love.timer.getTime(),math.pi/12) 
	--player.armAngle = player.armAngle - 2*math.pi*math.floor(player.armAngle/math.pi/2)-math.pi
	--love.graphics.print(player.armAngle/math.pi .. " pi",camera.x, camera.y)
	
	--[local drawx
	local drawy = player.y+player.armOffsetY*scale - math.sin(playerfunctions.armPivotRelArmAngle  + player.armAngle)*player.armMagFromArmPic*scale
	if player.facing == 'left' then
		drawx = player.x-player.armOffsetX*scale - math.cos(playerfunctions.armPivotRelArmAngle  + player.armAngle)*player.armMagFromArmPic*scale
		love.graphics.draw(playerarm.leftpic,drawx,drawy, player.armAngle,width/playerimages.picwidth, height/playerimages.picheight)
	else
		drawx = player.x+player.armOffsetX*scale - math.cos(playerfunctions.armPivotRelArmAngle  + player.armAngle)*player.armMagFromArmPic*scale
		love.graphics.draw(playerarm.rightpic,drawx,drawy, player.armAngle,width/playerimages.picwidth, height/playerimages.picheight)
	end
	--]]
	
	--[[
	love.graphics.push()
	love.graphics.translate(player.x+player.armOffsetX,player.y+player.armOffsetY)
	--love.graphics.rotate(player.armAngle)
	love.graphics.draw(playerarm.pic,-math.cos(playerfunctions.armAngle+player.armAngle)*player.armMag,-math.sin(playerfunctions.armAngle + player.armAngle)*player.armMag,player.armAngle,player.drawwidth/playerimages.picwidth, player.drawheight/playerimages.picheight)
	love.graphics.pop()
	--]]
	
	
	if player.facing == 'left' then
		love.graphics.setColor(0,255,0)
		--love.graphics.circle('fill',player.x+player.armOffsetX,player.y+player.armOffsetY,2)
	else
		love.graphics.setColor(0,255,0)
		--love.graphics.circle('fill',player.x-player.armOffsetX,player.y+player.armOffsetY,2)
	end
	
end

function playerfunctions.changeDirection()
	--player.armAngle = -player.armAngle
	--player.wheelOffsetX = -player.wheelOffsetX
--[[
	player.bones.backarmBone.upperConstraint,player.bones.backarmBone.lowerConstraint = -player.bones.backarmBone.lowerConstraint,-player.bones.backarmBone.upperConstraint
	player.bones.backbackarmBone.upperConstraint,player.bones.backbackarmBone.lowerConstraint = -player.bones.backbackarmBone.lowerConstraint,-player.bones.backbackarmBone.upperConstraint

	print("change\n")
	player.bones.backarmBone:setRelAngle(-player.bones.backarmBone.relAngle)
	player.bones.backbackarmBone:setRelAngle(-player.bones.backbackarmBone.relAngle)

	player.body:scale(-1,1)
--]]
	player.body:flipX()

end

function playerfunctions.drawWheel(scale)
	scale = scale or 1
	player.wheelCenterX = player.x+player.wheelOffsetX*scale
	player.wheelCenterY = player.y+player.wheelOffsetY*scale
	
	love.graphics.setColor(0,0,0)
	love.graphics.setLineWidth(5)
	love.graphics.line(player.wheelCenterX,player.wheelCenterY, player.x,player.y)
	
	local left = player.wheelCenterX - player.wheelPicDiag*math.cos(player.wheelAngle+math.pi/4)*scale
	local top = player.wheelCenterY - player.wheelPicDiag*math.sin(player.wheelAngle+math.pi/4)*scale
	
	love.graphics.setColor(255,255,255)
	love.graphics.draw(playerwheel.pic,left,top,player.wheelAngle,scale*player.drawwidth/playerimages.picwidth,scale*player.drawheight/playerimages.picheight)
	
end

function playerfunctions.changeWeapon()
	if table.length(player.weapons) > 1 then
		player.armAngle = 0
		player.weapons[player.equippedWeapon].state = 'ready'
		player.weapons[player.equippedWeapon]:update(0)
		player.equippedWeapon = next(player.weapons,player.equippedWeapon)
		if player.equippedWeapon == nil then
			player.equippedWeapon = next(player.weapons,player.equippedWeapon)
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


function playerfunctions.goThroughDoor()
	player.goingthroughdoor = true
	local alpha = 0
	if player.x<player.door.x + player.door.width/2 then
		player.lastmoving = 'd'
	elseif player.x>player.door.x + player.door.width/2 then
		player.lastmoving = 'a'
	else
		player.lastmoving = 'away'
	end
	local speed = math.max(math.min(math.abs(player.door.x + player.door.width/2-player.x)/0.7,80), 30)
	local time = math.abs(player.door.x + player.door.width/2-player.x)/speed
	while not QUIT do	
		love.processEvents()

		-- Update dt, as we'll be passing it to update
		love.timer.step()
		dt = love.timer.getDelta()

		-- Call update and draw
		alpha = alpha + 235/(time+0.5)*dt
		if alpha >= 235 then
			break
		end
		if player.lastmoving == 'd' and player.x < player.door.x + player.door.width/2 then
			player.x = player.x + speed*dt
			if player.x > player.door.x + player.door.width/2 then
				player.lastmoving = 'away'
				player.x = player.door.x + player.door.width/2
			end
		elseif player.lastmoving == 'a' and player.x > player.door.x + player.door.width/2 then
			player.x = player.x -speed*dt
			if player.x < player.door.x + player.door.width/2 then
				player.lastmoving = 'away'
				player.x = player.door.x + player.door.width/2
			end
		end
		--(player.door.x+player.door.width/2+3-player.x)*(alpha/140)
		love.graphics.clear()

		states.game.draw()
		love.graphics.setColor(0,0,0,alpha)
		love.graphics.rectangle('fill', 0,0, window.width, window.height)

		love.graphics.present()
	end
	
	if player.door.goesto == 'levelend' then
		states.levelwon.load()
		player.goingthroughdoor = false
		return true
	else
		print(player.door.goesto)
		currentLevel = level.loadSecondary(player.door.goesto)
		print(currentLevel.levelname)
		player.location = player.door.goesto
	  	player.visited[player.location] = true
	end

	for i,rect in ipairs(currentLevel.doors) do
		if rect.id == player.door.id then
			player.x = rect.x + rect.width/2
			player.y = rect.y+rect.height-player.height/2
			break
		end					
	end
	camera.update(dt)

	player.lastmoving = 'towards'
	while not QUIT do	
		love.processEvents()

		-- Update dt, as we'll be passing it to update
		love.timer.step()
		dt = love.timer.getDelta()

		-- Call update and draw
		alpha = alpha - 130*dt
		if alpha <=0 then
			break
		end
		love.graphics.clear()

		states.game.draw()

		love.graphics.setColor(0,0,0,alpha)
		love.graphics.rectangle('fill', 0,0, window.width, window.height)

		love.graphics.present()
	end
	
	player.goingthroughdoor = false
	player.hurttime = 0
	for i in ipairs(player.hurttext) do
		player.hurttext[i] = nil
	end
end
