io.stdout:setvbuf("no")
require('bone')
require('animation')
function love.load()
	bones = {}
	bones.headBone = bone.make{id='head',startPoint={225,170},endPoint={225,130},adamp=3,lowerConstraint=-math.pi*0.75,upperConstraint=-math.pi*0.25}
	bones.backarmBone = bone.make{id='backarm',startPoint={220,202}, aspeed=0,length=82,absAngle=70.3*math.pi/180,adamp=2.5,upperConstraint=math.pi*0.75,lowerConstraint=-math.pi/2}
	bones.forearmBone = bone.make{id='forearm',parent=bones.backarmBone, aspeed=0,length=94,relAngle=-30*math.pi/180,adamp=2.5,lowerConstraint=-math.pi*0.7,upperConstraint=-15*math.pi/180}
	---89.3*math.pi/180
	bones.fistBone = bone.make{id='fist',parent=bones.forearmBone, aspeed=0,length=12,relAngle=0,adamp=2.5,upperConstraint=20/180*math.pi,lowerConstraint=-30/180*math.pi}
	bones.backbackarmBone=bone.make{id='backba',startPoint={230,196},aspeed=0,length=82,absAngle=-10.3*math.pi/180,adamp=1.5,upperConstraint=math.pi*0.75,lowerConstraint=-math.pi/2}
	bones.backforearmBone=bone.make{id='backfa',parent=bones.backbackarmBone,aspeed=0,length=94,relAngle=-15*math.pi/180,adamp=1.5, lowerConstraint=-math.pi*0.7,upperConstraint=-15*math.pi/180}
	
	bones.swordBone = bone.make{id='sword',parent=bones.fistBone, length=100, relAngle=-math.pi/2,adamp=4}
	bones.wheelAttachmentBone = bone.make{id='wheelattach',startPoint={225,342},length=120,absAngle=math.pi/2}
	bones.wheelBone = bone.make{id='wheel',parent=bones.wheelAttachmentBone,length=67,relAngle=-math.pi/2,adamp=10}
	
	bones.spineBone = bone.make{id='spine',startPoint={225,492},length=259,absAngle=-math.pi/2,adamp=4, children={bones.backarmBone,bones.backbackarmBone,bones.headBone}, noConnection=true,lowerConstraint=-math.pi/2-20/180*math.pi,upperConstraint=-math.pi/2+30/180*math.pi}
	
	torsoPic = bonePicture.make(love.graphics.newImage('torso.png'),{relPivotPoint={54,326},bonePicAngle=math.pi/2, bone=bones.spineBone})
	
	fistPic = bonePicture.make(love.graphics.newImage('fist.png'),{relPivotPoint={15,8}, bonePicAngle=-52*math.pi/180, bone=bones.fistBone})
	
	headPic = bonePicture.make(love.graphics.newImage('head.png'),{relPivotPoint={70,184},bonePicAngle=math.pi/2,bone=bones.headBone})
	forearmPic = bonePicture.make(love.graphics.newImage('forearm.png'),{relPivotPoint={20,13},bonePicAngle=-61.8/180*math.pi,bone=bones.forearmBone})
	backarmPic = bonePicture.make(love.graphics.newImage('backarm.png'),{relPivotPoint={20,15},bonePicAngle=-88/180*math.pi,bone=bones.backarmBone})
	
	backforearmPic = bonePicture.make(love.graphics.newImage('back forearm.png'),{relPivotPoint={20,13},bonePicAngle=-61.8/180*math.pi,bone=bones.backforearmBone,color={160,160,160}})
	
	backbackarmPic = bonePicture.make(love.graphics.newImage('back backarm.png'),{relPivotPoint={20,15},bonePicAngle=-88/180*math.pi,bone=bones.backbackarmBone,color={160,160,160}})
	
	swordPic = bonePicture.make(love.graphics.newImage('sword.png'),{relPivotPoint={100,494},bonePicAngle=math.pi/2,bone=bones.swordBone,drawheight=200,scale=true})
	
	wheelPic = bonePicture.make(love.graphics.newImage('wheel.png'),{relPivotPoint={67,67}, bone=bones.wheelBone})
	
	
	theBody = body.make{loneBones={bones.wheelAttachmentBone},bonePics={backbackarmPic, backforearmPic,torsoPic,wheelPic,headPic,swordPic,backarmPic,forearmPic,fistPic},x=225,y=320,adamp=1,airdamping=1}
	theBody:setScale(38/45,119/140)
	
	s = 4.4
	walkSpeed = 1
	
	t = 0.8
	keyFrames = {backarmBone={bodyRelAngle={60,93,60},time={t,t},bounce=true},forearmBone={relAngle={-50,-10,-50},time={t,t}, bounce=true},
	backbackarmBone={bodyRelAngle={93,60,93},time={t,t},bounce=true},backforearmBone={relAngle={-10,-50,-10},time={t,t}, bounce=true},
	wheelBone={relAngle={0,360},loop=true,time={3}}
	 }
	
	setupAnimation()
	
	shrinkAnim = animation.make(0.7,1.5,1,false,true)
	love.graphics.setBackgroundColor(20,100,150)
	
	update = true
end

function setupAnimation()
	bodyAnimations = {}
	for i,bodypart in pairs(keyFrames) do
		bodyAnimations[i] = {}
		for valuename,b in pairs(bodypart) do
			if valuename ~= 'time' and valuename ~= 'bounce' and valuename~= 'loop' then
				bodyAnimations[i][valuename] = {}
				local n = 1
				while n < #b do
					if b[n] and b[n+1] then
						bodyAnimations[i][valuename][n] = animation.make(b[n]/180*math.pi,b[n+1]/180*math.pi,bodypart.time[n],bodypart.loop)
					end
					n = n+1
				end
			end
		end
	end
end

function setupSpecificBoneAnimation(boneName, infoTable)
	bodyAnimations[boneName] = {}
	for valuename,b in pairs(infoTable) do
		if valuename ~= 'time' and valuename ~= 'bounce' then
			bodyAnimations[boneName][valuename] = {}
			local n = 1
			while n < #b do
				if b[n] and b[n+1] then
					bodyAnimations[boneName][valuename][n] = animation.make(b[n]/180*math.pi,b[n+1]/180*math.pi,infoTable.time[n],false)
				end
				n = n+1
			end
		end
	end
end

function updateAnimation(dt)
	for bodypartname,v in pairs(bodyAnimations) do
		for valuename,animationlist in pairs(v) do
			if animationlist[1] then
				animationlist[1]:update(dt)
				if valuename == 'bodyRelAngle' then
					bones[bodypartname]:setBodyRelAngle(animationlist[1].value)
				else
					bones[bodypartname][valuename] = animationlist[1].value
				end
				if animationlist[1].numloops > 0 and not animationlist[1].loop then
					table.remove(animationlist,1)
					if #animationlist == 0 and keyFrames[bodypartname].bounce then
						playerfunctions.setupSpecificBoneAnimation(bodypartname,keyFrames[bodypartname])
					end
				end
			end
		end
	end
	
	print('\n\n\n')
end

function love.update(dt)
	dt = dt
	if love.keyboard.isDown('a') then
		walkSpeed = walkSpeed*0.99
	elseif love.keyboard.isDown('d') then
		walkSpeed = walkSpeed*1.01
	end
	
	updateAnimation(dt*walkSpeed)
	
	--[[armPic:update(dt)
	swordPic:update(dt)
	torsoBone:update(dt)
	wheelPic:update(dt)]]
	
	theBody.aspeed = 0
	
	theBody:update(dt)
	--shrinkAnim:update(dt)
	--theBody:setScale(shrinkAnim.value,shrinkAnim.value)
end


function love.draw()
	first = true
	--[[armPic:draw(true,nil,nil,1)
	swordPic:draw(true,nil,nil,1)
	torsoBone:draw()
	wheelPic:draw(true)]]
	
	love.graphics.setColor(0,0,0)
	love.graphics.setLineWidth(14*theBody.xscale)
	love.graphics.line(bones.spineBone.startPoint[1],bones.spineBone.startPoint[2],bones.spineBone.endPoint[1],bones.spineBone.endPoint[2])
	
	theBody:draw(false)
	
	love.graphics.setColor(255,255,255)
	love.graphics.print("BA absA: " .. bones.backarmBone.absAngle*180/math.pi)
	love.graphics.print("BA bodyRelA: " .. bones.backarmBone.bodyRelAngle*180/math.pi,0,14)
	
	love.graphics.print("FA absA: " .. bones.forearmBone.absAngle*180/math.pi,0,32)
	love.graphics.print("FA bodyRelA: " .. bones.forearmBone.bodyRelAngle*180/math.pi,0,46)
	love.graphics.setColor(0,255,0)
	--love.graphics.circle("fill",theBody.x,theBody.y,4)
end


function love.keypressed(k)
	if k =='escape' then
		love.event.quit()
	elseif k == 'r' then
		love.load()		
	elseif k =='x' then
		love.update(1/100)
	elseif k =='z' then
		update = not update
	elseif k == 'o' then
		theBody:scale(0.5,0.5)
	elseif k =='p' then
		theBody:scale(2,2)
	end
end


function love.run()

    if love.math then
        love.math.setRandomSeed(os.time())
    end

    if love.event then
        love.event.pump()
    end

    if love.load then love.load(arg) end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local dt = 0

    -- Main loop time.
    while true do
        -- Process events.
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

        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        -- Call update and draw
        if love.update and update then love.update(dt) end -- will pass 0 if love.timer is disabled
		
        if love.window and love.graphics and love.window.isCreated() then
            love.graphics.clear()
            love.graphics.origin()
            if love.draw then love.draw() end
            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end

end
