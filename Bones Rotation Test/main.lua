io.stdout:setvbuf("no")
require('bone')
function love.load()
	local xscale = 1 or 38/45
	local yscale = 1 or 119/140
	
	headBone = bone.make{id='head',startPoint={225,170},endPoint={225,130},adamp=3,lowerConstraint=-math.pi*0.75,upperConstraint=-math.pi*0.25}
	backarmBone = bone.make{id='backarm',startPoint={220,232}, aspeed=0,length=82,absAngle=70.3*math.pi/180,adamp=2.5,upperConstraint=math.pi*0.75,lowerConstraint=-math.pi/2}
	forearmBone = bone.make{id='forearm',parent=backarmBone, aspeed=0,length=94,relAngle=-30*math.pi/180,adamp=2.5,lowerConstraint=-math.pi*0.7,upperConstraint=-15*math.pi/180}
	---89.3*math.pi/180
	fistBone = bone.make{id='fist',parent=forearmBone, aspeed=0,length=12,relAngle=0,adamp=2.5,upperConstraint=20/180*math.pi,lowerConstraint=-30/180*math.pi}
	backbackarmBone=bone.make{id='backba',startPoint={230,224},aspeed=0,length=82,absAngle=-10.3*math.pi/180,adamp=1.5,upperConstraint=math.pi*0.75,lowerConstraint=-math.pi/2}
	backforearmBone=bone.make{id='backfa',parent=backbackarmBone,aspeed=0,length=94,relAngle=-15*math.pi/180,adamp=1.5, lowerConstraint=-math.pi*0.7,upperConstraint=-15*math.pi/180}
	
	swordBone = bone.make{id='sword',parent=fistBone, length=100, relAngle=-math.pi/2,adamp=4}
	wheelAttachmentBone = bone.make{id='wheelattach',startPoint={225,357},length=135,absAngle=math.pi/2}
	wheelBone = bone.make{id='wheel',parent=wheelAttachmentBone,length=67,relAngle=-math.pi/2,adamp=10}
	
	spineBone = bone.make{id='spine',startPoint={225,492},length=259,absAngle=-math.pi/2,adamp=4, children={backarmBone,backbackarmBone,headBone}, noConnection=true,lowerConstraint=-math.pi/2-20/180*math.pi,upperConstraint=-math.pi/2+30/180*math.pi}
	
	torsoPic = bonePicture.make(love.graphics.newImage('torso.png'),{relPivotPoint={54,326},bonePicAngle=math.pi/2, bone=spineBone,xscale=xscale,yscale=yscale})
	
	fistPic = bonePicture.make(love.graphics.newImage('fist.png'),{relPivotPoint={15,8}, bonePicAngle=-52*math.pi/180, bone=fistBone,xscale=xscale,yscale=yscale})
	
	headPic = bonePicture.make(love.graphics.newImage('head.png'),{relPivotPoint={70,184},bonePicAngle=math.pi/2,bone=headBone,xscale=xscale,yscale=yscale})
	forearmPic = bonePicture.make(love.graphics.newImage('forearm.png'),{relPivotPoint={20,13},bonePicAngle=-61.8/180*math.pi,bone=forearmBone,xscale=xscale,yscale=yscale})
	backarmPic = bonePicture.make(love.graphics.newImage('backarm.png'),{relPivotPoint={20,15},bonePicAngle=-88/180*math.pi,bone=backarmBone,xscale=xscale,yscale=yscale})
	
	backforearmPic = bonePicture.make(love.graphics.newImage('back forearm.png'),{relPivotPoint={20,13},bonePicAngle=-61.8/180*math.pi,bone=backforearmBone,color={160,160,160},xscale=xscale,yscale=yscale})
	
	backbackarmPic = bonePicture.make(love.graphics.newImage('back backarm.png'),{relPivotPoint={20,15},bonePicAngle=-88/180*math.pi,bone=backbackarmBone,color={160,160,160},xscale=xscale,yscale=yscale})
	
	swordPic = bonePicture.make(love.graphics.newImage('sword.png'),{relPivotPoint={100,494},bonePicAngle=math.pi/2,bone=swordBone,drawheight=200,scale=true})
	
	wheelPic = bonePicture.make(love.graphics.newImage('wheel.png'),{relPivotPoint={67,67}, bone=wheelBone,xscale=xscale,yscale=yscale})
	
	
	theBody = body.make{loneBones={wheelAttachmentBone},bonePics={backbackarmPic, backforearmPic,torsoPic,wheelPic,headPic,swordPic,backarmPic,forearmPic,fistPic},x=225,y=320,adamp=1,airdamping=1}
	s = 84.4
	love.graphics.setBackgroundColor(20,100,150)
	
	update = true
end


function love.update(dt)

	if love.keyboard.isDown('a') then
		forearmBone.aspeed = forearmBone.aspeed - s/forearmBone.length
	elseif love.keyboard.isDown('d') then
		forearmBone.aspeed = forearmBone.aspeed + s/forearmBone.length
	end
	
	if love.keyboard.isDown('w') then
		backarmBone.aspeed = backarmBone.aspeed - s/backarmBone.length
	elseif love.keyboard.isDown('s') then
		backarmBone.aspeed = backarmBone.aspeed + s/backarmBone.length
	end
	
	if love.keyboard.isDown('left') then
		fistBone.aspeed = fistBone.aspeed - s/100
	elseif love.keyboard.isDown('right') then
		fistBone.aspeed = fistBone.aspeed + s/100
	end
	
	if love.keyboard.isDown('up') then
		wheelBone.aspeed = wheelBone.aspeed - s/wheelBone.length
	elseif love.keyboard.isDown('down') then
		wheelBone.aspeed = wheelBone.aspeed + s/wheelBone.length
	end
	
	if love.keyboard.isDown('y') then
		theBody.aspeed = theBody.aspeed - s/160
	elseif love.keyboard.isDown('h') then
		theBody.aspeed = theBody.aspeed + s/160
	end
	
	if love.keyboard.isDown('n') then
		theBody.xspeed = theBody.xspeed - s
	elseif love.keyboard.isDown('m') then
		theBody.xspeed = theBody.xspeed + s
	end
	
	if love.keyboard.isDown('u') then
		spineBone.aspeed = spineBone.aspeed - s/160
	elseif love.keyboard.isDown('j') then
		spineBone.aspeed = spineBone.aspeed + s/160
	end
	
	if love.keyboard.isDown('i') then
		headBone.aspeed = headBone.aspeed - s/160
	elseif love.keyboard.isDown('k') then
		headBone.aspeed = headBone.aspeed + s/160
	end
	
	if love.keyboard.isDown('o') then
		backbackarmBone.aspeed = backbackarmBone.aspeed - s/160
	elseif love.keyboard.isDown('l') then
		backbackarmBone.aspeed = backbackarmBone.aspeed + s/160
	end
	
	if love.keyboard.isDown('v') then
		forearmBone:setBodyRelAngle(0)
	elseif love.keyboard.isDown('b') then
		forearmBone:setBodyRelAngle(-math.pi/2)
	end
	
	--[[armPic:update(dt)
	swordPic:update(dt)
	torsoBone:update(dt)
	wheelPic:update(dt)]]
	theBody:update(dt)
end


function love.draw()
	first = true
	--[[armPic:draw(true,nil,nil,1)
	swordPic:draw(true,nil,nil,1)
	torsoBone:draw()
	wheelPic:draw(true)]]
	
	love.graphics.setColor(0,0,0)
	love.graphics.setLineWidth(14)
	love.graphics.line(spineBone.startPoint[1],spineBone.startPoint[2],spineBone.endPoint[1],spineBone.endPoint[2])
	
	theBody:draw(false)
	
	
	love.graphics.setColor(255,255,255)
	love.graphics.print("BA absA: " .. backarmBone.absAngle*180/math.pi)
	love.graphics.print("BA relA: " .. backarmBone.relAngle*180/math.pi,0,14)
	love.graphics.print("BA bodyRelA: " .. backarmBone.bodyRelAngle*180/math.pi,0,28)
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
