shopInterface = {}
shopInterface.__index = shopInterface

function shopInterface.make(att)
	local self = {}
	setmetatable(self,shopInterface)

	self.x = window.width/2
	self.y = (window.height-hud.height)/2 + hud.height

	self.width = window.width*0.8
	self.height = (window.height-hud.height)*0.95

	self.buttons = {}
	self.buttons.goBack = button.make{x=self.x-self.width/2+10,y=self.y+self.height/2-10,text="Return",image=greenrect.pic,textcolor={0,0,0}}


	
	self.infoBar = {}
	self.infoBar.width = self.width*0.25
	self.infoBar.height = self.height-50


	weaponsDisplayPage = pageDisplay.make{
								text="Upgrade your weapons here!"
								,buttons = {button.make{text="Hat Button"
														,x=self.x+25
														,y=self.y+30
														,image=greenrect.pic
														,textcolor={0,0,0,0}
														}

										}
								}
	hatDisplayPage = pageDisplay.make{
								text="Upgrade your hat here!"
								}
	nothingDisplayPage = pageDisplay.make{
								text="Upgrade nothing here!"
								}

	self.tabbedDisplay = tabbedDisplay.make{
							x = self.x-self.width/2+15
							,y = self.y-self.height/2+15
							,width = self.width-self.infoBar.width-75
							,height = self.infoBar.height
							,tabNames={'Weapons','Hats', 'Nothing'}
							,pageDisplays={
											['Weapons']=weaponsDisplayPage
											,['Hats']=hatDisplayPage
											,['Nothing']=nothingDisplayPage
										}

						}


	return self

end



function shopInterface:update(dt)
	for i,b in pairs(self.buttons) do
		b:update(dt)
	end 
	self.tabbedDisplay:update(dt)
end

function shopInterface:draw()
	love.graphics.setColor(40,40,40,180)
	love.graphics.rectangle("fill",self.x-self.width/2,self.y-self.height/2,self.width,self.height)

	for i,b in pairs(self.buttons) do
		b:draw()
	end 
	self.tabbedDisplay:draw()
end


function shopInterface:mousepressed(x,y,button)
	self.tabbedDisplay:mousepressed(x,y,button)
	for i,b in pairs(self.buttons) do
		if b.hover then
			if i == 'goBack' then
				pausedscreen.showshop = false
			end
		end
	end
	
end

function shopInterface:mousereleased(x,y,button)
	for i,b in pairs(self.buttons) do
		if b.hover then
			if i == 'goBack' then
				--pausedscreen.showshop = false
			end
		end
	end
end

function shopInterface:keypressed(key)
	
end


shopItem = {}
shopItem.__index = shopItem

function shopItem.make(att)
	local self = {}
	setmetatable(self, shopItem)

	self.description = att.description or "This is an item in the shop."

	self.price = att.price or 0
	
	
	return self
end

function shopItem:update(dt)

end

function shopItem:draw()

end