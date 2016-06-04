

resources = {}

function resources.load()


	-----------------FONTS----------------
		defaultfont = {}
		defaultfont[14] = love.graphics.newFont(14)
		defaultfont[20] = love.graphics.newFont(20)
		defaultfont[24] = love.graphics.newFont(24)
		defaultfont[28] = love.graphics.newFont(28)
		defaultfont[36] = love.graphics.newFont(36)
		defaultfont[48] = love.graphics.newFont(48)
		defaultfont[64] = love.graphics.newFont(64)
		defaultfont[200] = love.graphics.newFont(200)

		impactfont = {}
		impactfont[12] = love.graphics.newFont('Fonts/Impact.ttf',12)
		impactfont[14] = love.graphics.newFont('Fonts/Impact.ttf',14)
		impactfont[20] = love.graphics.newFont('Fonts/Impact.ttf',20)
		impactfont[24] = love.graphics.newFont('Fonts/Impact.ttf',24)
		impactfont[28] = love.graphics.newFont('Fonts/Impact.ttf',28)
		impactfont[36] = love.graphics.newFont('Fonts/Impact.ttf',36)
		impactfont[48] = love.graphics.newFont('Fonts/Impact.ttf',48)
		impactfont[60] = love.graphics.newFont('Fonts/Impact.ttf',60)
	
		neographfont = {}
		neographfont[14] = love.graphics.newFont('Fonts/neograph.ttf',14)
		neographfont[20] = love.graphics.newFont('Fonts/neograph.ttf',20)
		neographfont[22] = love.graphics.newFont('Fonts/neograph.ttf',21)
		neographfont[28] = love.graphics.newFont('Fonts/neograph.ttf',28)
		neographfont[36] = love.graphics.newFont('Fonts/neograph.ttf',36)
		neographfont[48] = love.graphics.newFont('Fonts/neograph.ttf',48)
		neographfont[60] = love.graphics.newFont('Fonts/neograph.ttf',60)
	
	---------------MISC PICS----------------
	infinity = {}
	infinity.pic = love.graphics.newImage("Art/Misc Pics/infinity.png")
	infinity.picwidth = infinity.pic:getWidth()
	infinity.picheight = infinity.pic:getHeight()

	sliderpic = {}
	sliderpic.pic = love.graphics.newImage("Art/Misc Pics/slider bar.png")
	sliderpic.width = sliderpic.pic:getWidth()
	sliderpic.height = sliderpic.pic:getHeight()

	sliderpic.arrowpic = love.graphics.newImage("Art/Misc Pics/updside down triangle.png")
	sliderpic.arrowwidth = sliderpic.pic:getWidth()
	sliderpic.arrowheight = sliderpic.pic:getHeight()
	
	quicksand = {}
	quicksand.pic = love.graphics.newImage("Art/Misc Pics/quicksand.png")
	quicksand.width = quicksand.pic:getWidth()
	quicksand.height = quicksand.pic:getHeight()

	bubble = {}
	bubble.pic = love.graphics.newImage('Art/Misc Pics/bubble.png')
	bubble.width = bubble.pic:getWidth()
	bubble.height = bubble.pic:getHeight()
	
	graybrick = {}
	graybrick.pic = love.graphics.newImage("Art/Misc Pics/weird gray brick wall.png")
	graybrick.width = graybrick.pic:getWidth()
	graybrick.height = graybrick.pic:getHeight()
	
	greenrect = {}
	greenrect.pic = love.graphics.newImage("Art/Misc Pics/Green Rectangle with raised border gray.png")
	greenrect.width = greenrect.pic:getWidth()
	greenrect.height = greenrect.pic:getHeight()

	bottomlessrect = {}
	bottomlessrect.pic = love.graphics.newImage("Art/Misc Pics/bottomless rectangle with border.png")
	bottomlessrect.width = bottomlessrect.pic:getWidth()
	bottomlessrect.height = bottomlessrect.pic:getHeight()
	
	sky = {}
	sky.pic = love.graphics.newImage("Art/Misc Pics/sky.png")
	sky.width = sky.pic:getWidth()
	sky.height = sky.pic:getHeight()
	
	dirt = {}
	dirt.pic = love.graphics.newImage("Art/Background Pics/dirt.png")
	dirt.width = dirt.pic:getWidth()
	dirt.height = dirt.pic:getHeight()
	
	grassydirt = {}
	grassydirt.pic = love.graphics.newImage("Art/Background Pics/grassy dirt.png")
	grassydirt.width = grassydirt.pic:getWidth()
	grassydirt.height = grassydirt.pic:getHeight()

	stonebrick = {}
	stonebrick.pic = love.graphics.newImage("Art/Background Pics/stone brick.png")
	stonebrick.width = stonebrick.pic:getWidth()
	stonebrick.height = stonebrick.pic:getHeight()
	
	water = {}
	water.pic = love.graphics.newImage("Art/Background Pics/water.png")
	water.width = water.pic:getWidth()
	water.height = water.pic:getHeight()

	door = {}
	door.pic = love.graphics.newImage("Art/Background Pics/door.png")
	door.width = door.pic:getWidth()
	door.height = door.pic:getHeight()
	
	explosionPic = {}
	explosionPic.pic = love.graphics.newImage("Art/Misc Pics/white explosion.png")
	explosionPic.width = explosionPic.pic:getWidth()
	explosionPic.height = explosionPic.pic:getHeight()
	
	titlecastle = {}
	titlecastle.pic = love.graphics.newImage("Art/Background Pics/title castle.png")
	titlecastle.width = titlecastle.pic:getWidth()
	titlecastle.height = titlecastle.pic:getHeight()

	-- grantgames = {}
	-- grantgames.pic = love.graphics.newImage("Art/Misc Pics/Grant Games.gif")
	-- grantgames.width = grantgames.pic:getWidth()
	-- grantgames.height = grantgames.pic:getHeight()
	
	playerimages = {}
	playerimages.left = love.graphics.newImage("Art/Person Pics/facing left.png")
	playerimages.right = love.graphics.newImage("Art/Person Pics/facing right.png")
	playerimages.away = love.graphics.newImage("Art/Person Pics/facing away.png")
	playerimages.towards = love.graphics.newImage("Art/Person Pics/facing towards.png")
	playerimages.leftTorso = love.graphics.newImage("Art/Person Pics/torso left.png")
	playerimages.rightTorso = love.graphics.newImage("Art/Person Pics/torso right.png")
	--playerimages.front = love.graphics.newImage("Person Pics/facing front.png")
	playerimages.picwidth, playerimages.picheight = playerimages.left:getWidth(), playerimages.left:getHeight()
	
	playerarm = {}
	playerarm.leftpic = love.graphics.newImage("Art/Person Pics/left arm.png")
	playerarm.rightpic = love.graphics.newImage("Art/Person Pics/right arm.png")
	playerarm.width = playerarm.leftpic:getWidth()
	playerarm.height = playerarm.leftpic:getHeight()
	
	playerwheel = {}
	playerwheel.pic = love.graphics.newImage("Art/Person Pics/wheel.png")
	playerwheel.width = playerwheel.pic:getWidth()
	playerwheel.height = playerwheel.pic:getHeight()

	--[
	leftarrow = {}
	leftarrow.pic = love.graphics.newImage("Art/Weapon Pics/left arrow.png")
	leftarrow.picwidth = leftarrow.pic:getWidth()
	leftarrow.picheight = leftarrow.pic:getHeight()
	leftarrow.width = 40
	leftarrow.height = 10
	leftarrow.angle = math.atan2(0.5*leftarrow.height, leftarrow.width)
	--]]
	
	levelPic = {}
	levelPic.pics = {}
	table.insert(levelPic.pics,love.graphics.newImage("Art/Level Pics/Birthing Place 1.png"))
	table.insert(levelPic.pics,love.graphics.newImage("Art/Level Pics/First Level 2.png"))
	table.insert(levelPic.pics,love.graphics.newImage("Art/Level Pics/Awesome Level 3.png"))
	levelPic.width = levelPic.pics[1]:getWidth()
	levelPic.height = levelPic.pics[1]:getHeight()
	
	playeranimations = {}
	playeranimations.jumping = {}
	for i=1,5 do
		table.insert(playeranimations.jumping, love.graphics.newImage("Art/Person Pics/jumping person/" .. i .. ".png"))
	end
	playeranimations.jumping.delay = 0.02
	playeranimations.jumping.frames = 5
	
	
	
	-----------------MUSIC------------------
	music = {}
	music.volume = 1
	
	
	music.title = {}
	music.title.music = love.audio.newSource("Music/Title Music/Title Joel strong first loopable.ogg","stream")
	music.title.music:setVolume(0.4)--0.7)
	
	music.loading = {}
	music.loading.music = love.audio.newSource("Music/Loading Music/Loading Joel loopable.ogg","static")
	music.loading.music:setVolume(0.4)
	music.loading.music:setLooping(true)
	
	music.discovery = {}
	music.discovery.music = love.audio.newSource("Music/Discovery Music/Discovery Joel loopable.ogg","stream")
	music.discovery.music:setVolume(0.4)--0.6)
	music.discovery.music:setLooping(true)
	
	music.discovery.fastmusic = love.audio.newSource("Music/Discovery Music/Discovery Joel fast loopable.ogg","stream")
	music.discovery.fastmusic:setVolume(0.6)
	music.discovery.fastmusic:setLooping(true)
	
	music.dying = {}
	music.dying.music = love.audio.newSource("Music/Dying Music/Dying Joel loopable.ogg","static")
	music.dying.music:setVolume(0.6)
	music.dying.music:setLooping(true)
	
	music.fight = {}
	music.fight.music = love.audio.newSource("Music/Fight Music/Fight Grant loopable.ogg","stream")
	music.fight.music:setVolume(0.6)
	music.fight.music:setLooping(true)
	
	
	
	
	
	
	---------------SOUND EFFECTS---------------------
	sfx = {}
	
	sfx.twong = love.audio.newSource("Sound Effects/Bow Noises/twong.ogg","static")
	sfx.twong:setVolume(1)
	
end



