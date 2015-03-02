--Paused Screen--


pausedscreen = {}

function pausedscreen.load()
	pausedscreen.width = window.width/3
	pausedscreen.x = window.width/2-pausedscreen.width/2
	pausedscreen.y = hud.height + 50
	pausedscreen.height = window.height-hud.height - 2*50


	local buttontexts = {"Resume","Upgrades","Save","Options","Quit","Restart Level","Shop"}
	--local textcolors = {{0,0,0}}
	local font = neographfont[22]
	local indices = {'resume','upgrades','save','options','quit','restart','shop'}

	local n = #buttontexts
	local centerx = window.width/2
	local height = 50
	local yspace = 10

	local centery = pausedscreen.y+pausedscreen.height/2--window.height/2
	local topy = centery-(yspace+height)*n/2

	local width = 0
	pausedscreen.buttons = {}
	icolors = {{255,255,0},{0,127,255},{0,255,127},{127,155,127},{220,0,0},{40,117,200},{100,100,100}}
	for i=1,n do
		pausedscreen.buttons[indices[i]] = button.make{text=buttontexts[i],font=font, y=topy, height=height, image=greenrect.pic, imagecolor={unpack(icolors[i])}, textcolor={0,0,0}}
		pausedscreen.buttons[indices[i]].x = centerx-pausedscreen.buttons[indices[i]].width/2

		if pausedscreen.buttons[indices[i]].width > width then
			width = pausedscreen.buttons[indices[i]].width
		end
		topy = topy+yspace+height
	end
	pausedscreen.buttons.resume.textcolor = {0,0,0}
	
end


function pausedscreen.update(dt)
	if pausedscreen.showupgrades then
		upgrades:update(dt)
	elseif pausedscreen.showshop then
		pausedscreen.shop:update(dt)
	else
		for i,b in pairs(pausedscreen.buttons) do
			b:update()
		end
	end
end


function pausedscreen.draw()
	if pausedscreen.showupgrades then
		upgrades:draw()
	elseif pausedscreen.showshop then
		pausedscreen.shop:draw()
	else
		love.graphics.setLineWidth(3)
		
		drawBlur.rectangle(pausedscreen.x,pausedscreen.y,pausedscreen.width,pausedscreen.height,10,{0,0,0,255},{100,100,100,0})
		--[[for i=7,10 do
			love.graphics.setColor(25*(10-i)^0.5,25*(10-i)^0.5,25*(10-i)^0.5,25*i)
			love.graphics.rectangle("line", self.x-(10-i),self.y-(10-i),self.width+2*(10-i),self.height+2*(10-i))
		end
]]
		love.graphics.setColor(100,100,100)
		love.graphics.draw(greenrect.pic, pausedscreen.x+pausedscreen.width,pausedscreen.y,math.pi/2,pausedscreen.height/greenrect.width,pausedscreen.width/greenrect.height)

		
		for i,b in pairs(pausedscreen.buttons) do
			b:draw()
		end

	end
end

function pausedscreen.mousepressed(x,y,button)
	if pausedscreen.showupgrades then
		upgrades:mousepressed(x,y,button)
	elseif pausedscreen.showshop then
		pausedscreen.shop:mousepressed(x,y,button)
	else
		for i,b in pairs(pausedscreen.buttons) do
			if b.hover then
				if i == 'quit' then
					if boolBox.getResponse{titleText="Warning! This will delete any unsaved progress!\nAre you sure you want to quit?",trueText="I'm sure",falseText="Cancel"} then
						states.levelselect.load()
					end
				elseif i == 'save' then
					savegame(selectedfile)
					fileheaders[selectedfile] = true
				elseif i == 'upgrades' then
					pausedscreen.showupgrades = true
				elseif i == 'resume' then
					paused = false
				elseif i == 'restart' then
					states.game.load(player.levelNumber,true)
				elseif i == 'shop' then
					pausedscreen.showshop = true
					if not pausedscreen.shop then
						pausedscreen.shop = shopInterface.make();
					end
				end
			end
		end
	end

end

function pausedscreen.mousereleased(x,y,button)
	if pausedscreen.showupgrades then
		upgrades:mousereleased(x,y,button)
	elseif pausedscreen.showshop then
		pausedscreen.shop:mousereleased(x,y,button)
	else

	end

end
