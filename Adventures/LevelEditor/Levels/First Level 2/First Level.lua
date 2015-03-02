local level = {}
level.levelname = 'First Level'

level.allpawns = {}

level.allsoldiers = {}

level.numSoldiers = 0

level.doors = {{['x'] = 5600,['y'] = 64,['width'] = 64,['height'] = 128,['type'] = 'door',goesto='levelend'}}

level.numPawns = 0

level.enemydrops = {}

level.enemySpawnPoints = {enemySpawnPoint.make{x=300,y=0,type='wizard',spawnrate=1.5,totalenemies=10, enemyatts={xspeed=14,crazymove=true}, display=true,xstep=100},enemySpawnPoint.make{x=300,y=0,type='pawn',spawnrate=2,totalenemies=15, enemyatts={drawwidth=80}, display=true,xstep=100/1.5*2 },enemySpawnPoint.make{x=300,y=0,type='pawn',spawnrate=0.8,totalenemies=15, enemyatts={drawwidth=50}, display=true,xstep=100/1.5*0.8 },enemySpawnPoint.make{x=300,y=0,type='pawn',spawnrate=1.5,totalenemies=10, enemyatts={drawwidth=30}, display=true,xstep=100 }}

level.spawnpoint = {[1] = 0, 
[2] = 0}

level.blocks = {[1] = {['x'] = -384,['y'] = 192,['type'] = 'dirt',['height'] = 64,['width'] = 1792},
[2] = {['x'] = 1408,['y'] = 192,['type'] = 'dirt',['height'] = 64,['width'] = 2432},
[3] = {['x'] = 3840,['y'] = 192,['type'] = 'dirt',['height'] = 64,['width'] = 2112},
[4] = {['x'] = 5888,['y'] = -256,['type'] = 'dirt',['height'] = 448,['width'] = 64},
[5] = {['x'] = 2944,['y'] = -256,['type'] = 'dirt',['height'] = 64,['width'] = 2944},
[6] = {['x'] = 320,['y'] = -256,['type'] = 'dirt',['height'] = 64,['width'] = 2624},
[7] = {['x'] = -384,['y'] = -256,['type'] = 'dirt',['height'] = 448,['width'] = 64},
[8] = {['x'] = -320,['y'] = -256,['type'] = 'dirt',['height'] = 64,['width'] = 640},
[9] = {['x'] = -320,['y'] = -256,['type'] = 'dirt',['height'] = 64,['width'] = 640}}

return level
