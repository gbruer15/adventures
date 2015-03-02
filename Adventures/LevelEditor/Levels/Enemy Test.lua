
local levelname = "Enemy Test"

level[levelname] = {}

level[levelname].blocks = {{['y'] = -640,['x'] = 384,['height'] = 64,['type'] = 'dirt',['width'] = 448},
[2] = {['y'] = 0,['x'] = -384,['height'] = 64,['type'] = 'grassydirt',['width'] = 64},
[3] = {['y'] = -64,['x'] = -512,['height'] = 128,['type'] = 'grassydirt',['width'] = 128},
[4] = {['y'] = -960,['x'] = 1088,['height'] = 1280,['type'] = 'grassydirt',['width'] = 128},
[5] = {['y'] = -960,['x'] = 1024,['height'] = 1280,['type'] = 'grassydirt',['width'] = 64},
[6] = {['y'] = -832,['x'] = -768,['height'] = 1152,['type'] = 'grassydirt',['width'] = 256},
[7] = {['y'] = 64,['x'] = -512,['height'] = 256,['type'] = 'grassydirt',['width'] = 1536},
[8] = {['y'] = 64,['x'] = -512,['height'] = 256,['type'] = 'grassydirt',['width'] = 1536},
[9] = {['y'] = -640,['x'] = 832,['height'] = 512,['type'] = 'dirt',['width'] = 64},
[10] = {['y'] = -192,['x'] = 384,['height'] = 64,['type'] = 'dirt',['width'] = 448},
[11] = {['y'] = -640,['x'] = 320,['height'] = 512,['type'] = 'dirt',['width'] = 64}}

level[levelname].enemySpawnPoints = {enemySpawnPoint.make{x=600,y=-450,type='pawn', enemyatts={},totalenemies=60,display=true,spawnrate=0.3}}