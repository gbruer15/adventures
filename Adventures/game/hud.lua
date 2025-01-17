

hud = {}

function hud.load()
	hud.width = window.width
	hud.height = 0.15 * window.height
	hud.x,hud.y = 0, 0
	
	hud.outline = {}
	hud.outline.color = {0,0,0}
	hud.outline.width = 6
	
	hud.buttons = {}
	hud.buttons.pause = button.make{text="P",textcolor={255,255,255}, font=defaultfont[20],x=730,y=10, width=60,height=30}
	
	hpbar = {}
	hpbar.x = 39
	hpbar.y = 60
	hpbar.width = 200
	hpbar.height = 18
	hpbar.text = "200/200"
	hpbar.textx = hpbar.x+hpbar.width/2-impactfont[14]:getWidth(hpbar.text)/2
	hpbar.texty = hpbar.y + hpbar.height/2 - impactfont[14]:getHeight()/2
	
	xpbar = {}
	xpbar.y = 38
	xpbar.x = hpbar.x
	xpbar.width = hpbar.width
	xpbar.height = hpbar.height 
	xpbar.textx = hpbar.textx
	xpbar.texty = hpbar.texty + (xpbar.y-hpbar.y)
	
	airbar = {}
	airbar.x = hpbar.x+hpbar.width+40
	airbar.width = 150
	airbar.height = 18
	airbar.y = hpbar.y
	airbar.texty = airbar.y+airbar.height/2 - impactfont[14]:getHeight()/2
	
	gold = {}
	gold.y = xpbar.y-5
	gold.x = hpbar.x + hpbar.width+15
	gold.textwidth = neographfont[20]:getWidth("Arrows:") --"Gold:"
	
	hearts = {}
	hearts.pic = {}
	hearts.pic.full = love.graphics.newImage("Art/Misc Pics/full heart.png")
	hearts.pic.half = love.graphics.newImage("Art/Misc Pics/half heart.png")
	hearts.pic.empty = love.graphics.newImage("Art/Misc Pics/empty heart.png")
	hearts.pic.drawwidth = 18 -- 9:10
	hearts.pic.drawheight = 18--15
	hearts.pic.picwidth = hearts.pic.full:getWidth()
	hearts.pic.picheight = hearts.pic.full:getHeight()

	bubble = {}
	bubble.pic = love.graphics.newImage('Art/Misc Pics/bubble.png')
	bubble.picwidth = bubble.pic:getWidth()
	bubble.picheight = bubble.pic:getHeight()
	bubble.width = 30
	bubble.height = 30
	bubble.time = 30
	
	
	
end


function hud.update(dt)
	for i,b in pairs(hud.buttons) do
		b:update()
	end
end


function hud.mousepressed(x,y,button)
	for i,b in pairs(hud.buttons) do
		if b.hover then
			if i == 'pause' then
				paused = true
			end
		end
	end

	if collision.pointRectangle(x,y, xpbar.x, xpbar.y, xpbar.width,xpbar.height ) then
		if player.xp >= levelupxps[player.level] and #levelupxps > player.level then
			player.upoints = player.upoints + player.level*3
			player.level = player.level + 1
		end
	end
end

function hud.draw()
	
	--love.graphics.setColor(200,130,50)
	--love.graphics.rectangle("fill", hud.x,hud.y, hud.width,hud.height)
	love.graphics.setColor(255,255,255)
	local n = 6
	for i=1,n do 
		love.graphics.draw(graybrick.pic, hud.x + (i-1)*hud.width/n,hud.y,0, hud.width/n/graybrick.width,hud.height/graybrick.height)
	end

	
	love.graphics.setColor(unpack(hud.outline.color))
	love.graphics.setLineWidth(hud.outline.width)
	love.graphics.rectangle("line", hud.x+hud.outline.width/2,hud.y+hud.outline.width/2, hud.width-hud.outline.width,hud.height-hud.outline.width)
	
	
	drawHealthBar()
	drawXPBar()
	drawAirBar()
	
	love.graphics.setFont(neographfont[28])
	love.graphics.setColor(30,30,30)
	--love.graphics.print(player.name .. ' Level ' .. player.level, 47,5)
	love.graphics.printf(player.name .. ' Level ' .. player.level, 2,3,hpbar.x+hpbar.width+10,'center')
	love.graphics.setColor(255,150,80)
	--love.graphics.print(player.name .. ' Level ' .. player.level, 45,3)
	love.graphics.printf(player.name .. ' Level ' .. player.level, 0,3,hpbar.x+hpbar.width+10,'center')
	
	love.graphics.setFont(neographfont[20])
	love.graphics.setColor(0,0,0)
	love.graphics.print("Arrows:", gold.x+1,gold.y-1)
	
	love.graphics.setColor(255,255,50)
	love.graphics.print("Arrows:", gold.x,gold.y)--"Gold:"
	
	love.graphics.setFont(impactfont[24])
	love.graphics.setColor(0,0,0)
	love.graphics.print(player.weapons.bow.arrowsLeft, gold.x+gold.textwidth + 3,gold.y-1) --player.gold
	
	love.graphics.setColor(255,250,5)
	love.graphics.print(player.weapons.bow.arrowsLeft, gold.x+gold.textwidth + 2,gold.y)		
	
	if player.xp > levelupxps[player.level] then
		love.graphics.setFont(impactfont[20])
		love.graphics.setColor((math.sin(love.timer.getTime()*2)+1)*120,255,0)
		love.graphics.print("Click flashing bar to get upgrade points!",gold.x,gold.y-20)
	end

	
	love.graphics.setFont(defaultfont[14])
	love.graphics.setColor(255,255,255)
	
	
	for i,b in pairs(hud.buttons) do
		b:draw()
	end
end


function drawHealthBar()
	
	love.graphics.setFont(impactfont[20])
	
	love.graphics.setColor(90,10,10)
	love.graphics.print("HP", 12,hpbar.y-3)
	
	love.graphics.setColor(225,20,20)
	love.graphics.print("HP", 10,hpbar.y-5)


	love.graphics.setColor(20,20,20)
	love.graphics.rectangle("fill", hpbar.x,hpbar.y,hpbar.width,hpbar.height)
	
	love.graphics.setColor(200,0,0)
	love.graphics.rectangle("fill", hpbar.x+2,hpbar.y+2,(hpbar.width-4)*player.hp/player.maxhp, hpbar.height-4)
	
	
	love.graphics.setFont(impactfont[14])
	
	love.graphics.setColor(20,20,20)
	love.graphics.print(player.hp .. '/' .. player.maxhp, hpbar.textx+1,hpbar.texty+1)
	
	love.graphics.setColor(250,250,250)
	love.graphics.print(player.hp .. '/' .. player.maxhp, hpbar.textx,hpbar.texty)
end


function drawXPBar()
	
	love.graphics.setFont(impactfont[20])
	
	love.graphics.setColor(10,60,10)
	love.graphics.print("XP", 12,xpbar.y - 3)
	
	love.graphics.setColor(20,225,20)
	love.graphics.print("XP", 10,xpbar.y - 5)


	love.graphics.setColor(20,20,20)
	love.graphics.rectangle("fill", xpbar.x,xpbar.y,xpbar.width,xpbar.height)
	
	love.graphics.setColor(0,200,0)
	love.graphics.rectangle("fill", xpbar.x+2,xpbar.y+2,(xpbar.width-4)*math.min(player.xp/levelupxps[player.level],1), xpbar.height-4)
	
	
	love.graphics.setFont(impactfont[14])
	
	love.graphics.setColor(20,20,20)
	love.graphics.print(player.xp .. '/' .. levelupxps[player.level], xpbar.textx+1,xpbar.texty+ 1)
	
	love.graphics.setColor(250,250,250)
	love.graphics.print(player.xp .. '/' .. levelupxps[player.level], xpbar.textx,xpbar.texty)

	if player.xp >= levelupxps[player.level] then
		love.graphics.setColor(255,math.sin(4*love.timer.getTime())*127+127,math.cos(4*love.timer.getTime())*127+127,100)
		love.graphics.rectangle("fill", xpbar.x+2,xpbar.y+2,xpbar.width-4,xpbar.height-4)
	end
end


function drawAirBar()
	
	love.graphics.setFont(impactfont[20])
	
	love.graphics.setColor(20,20,60)
	love.graphics.print("Air", airbar.x-28,airbar.y - 4)
	
	love.graphics.setColor(20,80,235)
	love.graphics.print("Air", airbar.x - 29,airbar.y - 5)


	love.graphics.setColor(20,20,20)
	love.graphics.rectangle("fill", airbar.x,airbar.y,airbar.width,airbar.height)
	
	love.graphics.setColor(30,70,225)
	love.graphics.rectangle("fill", airbar.x + 2,airbar.y+2,(airbar.width-4)*player.oxygenlevel/player.maxoxygenlevel, airbar.height-4)
	
	
	love.graphics.setFont(impactfont[14])
	
	love.graphics.setColor(20,20,20)
	love.graphics.printf(math.ceil(player.oxygenlevel) .. '/' .. player.maxoxygenlevel, airbar.x+3,airbar.y+1,airbar.width-4,'center')
	
	love.graphics.setColor(250,250,250)
	love.graphics.printf(math.ceil(player.oxygenlevel) .. '/' .. player.maxoxygenlevel, airbar.x+2,airbar.y,airbar.width-4,'center')
end



function drawHearts()
		
	love.graphics.setFont(impactfont[20])
	love.graphics.setColor(180,20,20)
	love.graphics.print("Health:", 10,7)
	
	local i = 0
	while i < player.health do
		love.graphics.draw(hearts.pic.full, 80 + i*(hearts.pic.drawwidth*1.3),10, 0, hearts.pic.drawwidth/hearts.pic.picwidth,hearts.pic.drawheight/hearts.pic.picheight)
		i = i + 1
	end
	if math.floor(player.health) ~= player.health then
		i = i - 1
		love.graphics.draw(hearts.pic.half, 8 + i*(hearts.pic.drawwidth*1.3),10, 0, hearts.pic.drawwidth/hearts.pic.picwidth,hearts.pic.drawheight/hearts.pic.picheight)
		i = i + 1
	end
	while i < player.maxhealth do
		love.graphics.draw(hearts.pic.empty, 8 + i*(hearts.pic.drawwidth*1.3),10, 0, hearts.pic.drawwidth/hearts.pic.picwidth,hearts.pic.drawheight/hearts.pic.picheight)
		i = i + 1
	end
end

function drawOxygenLevel()	

	love.graphics.setFont(defaultfont[20])
	love.graphics.setColor(30,100,200)
	love.graphics.print(math.round(player.oxygenlevel/player.maxoxygenlevel,0.01)*100 .. "%", window.width/2 - 67,20)
	
	

	i = 0
	x = window.width/2 + 10
	while i <= player.oxygenlevel-bubble.time do
		--love.graphics.circle("fill", x, 30, 15)
		love.graphics.draw(bubble.pic, x-bubble.width/2, 30-bubble.height/2, 0, bubble.width/bubble.picwidth,bubble.height/bubble.picheight)
		x = x + 35
		i = i + bubble.time	
	end
	--love.graphics.circle("fill", x, 30, (player.oxygenlevel-i) * 15/bubble.time)
	local width = (2*(player.oxygenlevel-i) * 15/bubble.time)
	local height = (2*(player.oxygenlevel-i) * 15/bubble.time)
	love.graphics.draw(bubble.pic, x-width/2, 30-height/2, 0, width/bubble.picwidth,height/bubble.picheight)
	
	if player.oxygenlevel <= 0 then
		love.graphics.setFont(defaultfont[24])
		
		drowncolortime = love.timer.getTime()
		love.graphics.setColor((math.sin(drowncolortime)+1)*100+55,255 - (math.cos(drowncolortime)+1)*100,0)
		love.graphics.print("Breathe!!", x-15,15)
	end
end
