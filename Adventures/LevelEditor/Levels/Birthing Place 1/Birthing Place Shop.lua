local level = {}
level.levelname = "Birthing Place Shop"

level.blocks = {{['y'] = -384,['x'] = 64,['height'] = 64,['type'] = 'sign',['text'] = "Welcome to the Shop",['width'] = 384},
[2] = {['y'] = -64,['x'] = 448,['height'] = 64,['type'] = 'stonebrick',['width'] = 192},
[3] = {['y'] = -448,['x'] = 576,['height'] = 64,['type'] = 'stonebrick',['width'] = 64},
[4] = {['y'] = -512,['x'] = 448,['height'] = 128,['type'] = 'stonebrick',['width'] = 128},
[5] = {['y'] = -512,['x'] = 64,['height'] = 64,['type'] = 'stonebrick',['width'] = 192},
[6] = {['y'] = -384,['x'] = -128,['height'] = 64,['type'] = 'stonebrick',['width'] = 64},
[7] = {['y'] = -320,['x'] = -128,['height'] = 64,['type'] = 'stonebrick',['width'] = 64},
[8] = {['y'] = -64,['x'] = -64,['height'] = 64,['type'] = 'stonebrick',['width'] = 512},
[11] = {['y'] = -256,['x'] = -128,['height'] = 256,['type'] = 'stonebrick',['width'] = 64},
[12] = {['y'] = -448,['x'] = -64,['height'] = 128,['type'] = 'stonebrick',['width'] = 64},
[13] = {['y'] = -512,['x'] = 0,['height'] = 128,['type'] = 'stonebrick',['width'] = 64},
[14] = {['y'] = -512,['x'] = 256,['height'] = 64,['type'] = 'stonebrick',['width'] = 192},
[15] = {['y'] = -384,['x'] = 576,['height'] = 64,['type'] = 'stonebrick',['width'] = 128},
[16] = {['y'] = -320,['x'] = 640,['height'] = 64,['type'] = 'stonebrick',['width'] = 128},
[17] = {['y'] = -256,['x'] = 640,['height'] = 256,['type'] = 'stonebrick',['width'] = 128}}

level.doors = {{['y'] = -192,['x'] = 64,['height'] = 128,['width'] = 64, goesto='Second Place',id = 'a1'}}

level.enemySpawnPoints = {enemySpawnPoint.make{x=192,y=-128,type='pawn',totalenemies=50,spawnrate=0.3,display=true}}

return level
