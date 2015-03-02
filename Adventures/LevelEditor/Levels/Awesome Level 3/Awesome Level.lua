local level = {}
level.levelname = 'Awesome Level'


level.allpawns = {}

level.allsoldiers = {}

level.numSoldiers = 0

level.doors = {{['x'] = 1088,['y'] = -1280,['width'] = 64,['height'] = 128,['type'] = 'door',goesto='levelend'}}

level.numPawns = 0

level.numWizards = 0

level.allwizards = {}

level.enemySpawnPoints = {[2] = {['height'] = 100,['x'] = 320,['width'] = 100,['xspeed'] = 0,['y'] = -1088,['xstep'] = 0,['spawnrate'] = 1,['yspeed'] = 0,['enemies'] = {},['enemyatts'] = {['y'] = -1088,['x'] = 320},['ystep'] = 0,['counter'] = 0,['type'] = 'pawn',['totalenemies'] = 50,['display'] = true,['maxenemies'] = false},
[5] = {['width'] = 100,['y'] = 256,['spawnrate'] = 1,['counter'] = 0,['maxenemies'] = false,['display'] = true,['x'] = -448,['type'] = 'wizard',['totalenemies'] = 2,['enemies'] = {},['height'] = 100,['enemyatts'] = {['y'] = 320,['x'] = -320,['xspeed']=0},['xspeed']=0,['yspeed']=0},
[3] = {['width'] = 100,['y'] = 256,['spawnrate'] = 0.8,['counter'] = 0,['maxenemies'] = false,['display'] = true,['x'] = 0,['type'] = 'soldier',['totalenemies'] = 12,['enemies'] = {},['height'] = 100,['enemyatts'] = {['y'] = 256,['x'] = 0,['xspeed']=20},['xspeed']=0,['yspeed']=0},
[7] = {['width'] = 100,['y'] = -256,['spawnrate'] = 1,['counter'] = 0,['maxenemies'] = false,['display'] = true,['x'] = -448,['type'] = 'wizard',['totalenemies'] = 2,['enemies'] = {},['height'] = 100,['enemyatts'] = {['y'] = -256,['x'] = -448,['xspeed']=0},['xspeed']=0,['yspeed']=0},
[4] = {['width'] = 100,['y'] = 256,['spawnrate'] = 1,['counter'] = 0,['maxenemies'] = false,['display'] = true,['x'] = 448,['type'] = 'wizard',['totalenemies'] = 2,['enemies'] = {},['height'] = 100,['enemyatts'] = {['y'] = 256,['x'] = 448,['xspeed']=0},['xspeed']=0,['yspeed']=0},
[6] = {['width'] = 100,['y'] = -256,['spawnrate'] = 1,['counter'] = 0,['maxenemies'] = false,['display'] = true,['x'] = 448,['type'] = 'wizard',['totalenemies'] = 2,['enemies'] = {},['height'] = 100,['enemyatts'] = {['y'] = -192,['x'] = 512,['xspeed']=0},['xspeed']=0,['yspeed']=0}}

level.spawnpoint = {[2] = 0, 
[1] = 0}

level.blocks = {[1] = {['x'] = 1280,['y'] = -960,['width'] = 128,['height'] = 64,['type'] = 'stonebrick'},
[2] = {['permeable'] = true,['x'] = 192,['y'] = -896,['width'] = 320,['height'] = 64,['type'] = 'water'},
[3] = {['permeable'] = true,['x'] = -128,['y'] = -896,['width'] = 320,['height'] = 64,['type'] = 'water'},
[4] = {['permeable'] = true,['x'] = -512,['y'] = -896,['width'] = 384,['height'] = 64,['type'] = 'water'},
[5] = {['permeable'] = true,['x'] = -128,['y'] = -832,['width'] = 256,['height'] = 64,['type'] = 'water'},
[6] = {['permeable'] = true,['x'] = 128,['y'] = -832,['width'] = 384,['height'] = 128,['type'] = 'water'},
[7] = {['permeable'] = true,['x'] = -512,['y'] = -832,['width'] = 384,['height'] = 128,['type'] = 'water'},
[8] = {['permeable'] = true,['x'] = 64,['y'] = -768,['width'] = 64,['height'] = 128,['type'] = 'water'},
[9] = {['permeable'] = true,['x'] = -128,['y'] = -768,['width'] = 64,['height'] = 128,['type'] = 'water'},
[10] = {['permeable'] = true,['x'] = -64,['y'] = -768,['width'] = 128,['height'] = 192,['type'] = 'water'},
[11] = {['permeable'] = true,['x'] = -64,['y'] = -576,['width'] = 128,['height'] = 384,['type'] = 'water'},
[12] = {['x'] = 192,['y'] = -384,['width'] = 192,['height'] = 64,['type'] = 'grassydirt'},
[13] = {['x'] = -384,['y'] = -384,['width'] = 192,['height'] = 64,['type'] = 'grassydirt'},
[14] = {['x'] = -64,['y'] = -192,['width'] = 128,['height'] = 64,['type'] = 'grassydirt'},
[15] = {['x'] = 64,['y'] = -256,['width'] = 64,['height'] = 128,['type'] = 'grassydirt'},
[16] = {['x'] = -128,['y'] = -256,['width'] = 64,['height'] = 128,['type'] = 'grassydirt'},
[17] = {['x'] = -512,['y'] = -192,['width'] = 64,['height'] = 128,['type'] = 'grassydirt'},
[18] = {['x'] = 448,['y'] = -192,['width'] = 64,['height'] = 128,['type'] = 'grassydirt'},
[19] = {['x'] = 192,['y'] = -64,['width'] = 192,['height'] = 64,['type'] = 'grassydirt'},
[20] = {['x'] = -384,['y'] = -64,['width'] = 192,['height'] = 64,['type'] = 'grassydirt'},
[21] = {['x'] = -128,['y'] = 64,['width'] = 256,['height'] = 64,['type'] = 'grassydirt'},
[22] = {['x'] = -128,['y'] = 64,['width'] = 256,['height'] = 64,['type'] = 'grassydirt'},
[23] = {['x'] = 896,['y'] = -640,['width'] = 128,['height'] = 256,['type'] = 'dirt'},
[24] = {['x'] = 704,['y'] = -384,['width'] = 192,['height'] = 192,['type'] = 'dirt'},
[25] = {['x'] = 704,['y'] = -640,['width'] = 192,['height'] = 256,['type'] = 'dirt'},
[26] = {['x'] = 1152,['y'] = -832,['width'] = 192,['height'] = 192,['type'] = 'dirt'},
[27] = {['x'] = 896,['y'] = -832,['width'] = 256,['height'] = 192,['type'] = 'dirt'},
[28] = {['x'] = 704,['y'] = -832,['width'] = 192,['height'] = 192,['type'] = 'dirt'},
[29] = {['x'] = 704,['y'] = -896,['width'] = 704,['height'] = 64,['type'] = 'dirt'},
[30] = {['x'] = 1152,['y'] = -960,['width'] = 128,['height'] = 64,['type'] = 'dirt'},
[31] = {['x'] = 960,['y'] = -960,['width'] = 64,['height'] = 64,['type'] = 'dirt'},
[32] = {['x'] = 704,['y'] = -960,['width'] = 128,['height'] = 64,['type'] = 'dirt'},
[33] = {['x'] = 64,['y'] = -640,['width'] = 128,['height'] = 64,['type'] = 'dirt'},
[34] = {['x'] = 64,['y'] = -576,['width'] = 64,['height'] = 128,['type'] = 'dirt'},
[35] = {['x'] = -128,['y'] = -576,['width'] = 64,['height'] = 128,['type'] = 'dirt'},
[36] = {['x'] = -192,['y'] = -640,['width'] = 128,['height'] = 64,['type'] = 'dirt'},
[37] = {['x'] = 128,['y'] = -704,['width'] = 384,['height'] = 64,['type'] = 'dirt'},
[38] = {['x'] = -512,['y'] = -704,['width'] = 384,['height'] = 64,['type'] = 'dirt'},
[39] = {['x'] = 320,['y'] = 256,['width'] = 64,['height'] = 64,['type'] = 'dirt'},
[40] = {['x'] = 192,['y'] = 256,['width'] = 64,['height'] = 64,['type'] = 'dirt'},
[41] = {['x'] = 256,['y'] = 192,['width'] = 64,['height'] = 128,['type'] = 'dirt'},
[42] = {['x'] = -384,['y'] = 256,['width'] = 64,['height'] = 64,['type'] = 'dirt'},
[43] = {['x'] = -256,['y'] = 256,['width'] = 64,['height'] = 64,['type'] = 'dirt'},
[44] = {['x'] = -320,['y'] = 192,['width'] = 64,['height'] = 128,['type'] = 'dirt'},
[45] = {['x'] = 384,['y'] = 448,['width'] = 320,['height'] = 128,['type'] = 'dirt'},
[46] = {['x'] = 192,['y'] = 448,['width'] = 192,['height'] = 128,['type'] = 'dirt'},
[47] = {['x'] = -64,['y'] = 448,['width'] = 256,['height'] = 128,['type'] = 'dirt'},
[48] = {['x'] = -384,['y'] = 448,['width'] = 320,['height'] = 128,['type'] = 'dirt'},
[49] = {['x'] = -704,['y'] = 448,['width'] = 320,['height'] = 128,['type'] = 'dirt'},
[50] = {['x'] = 384,['y'] = 320,['width'] = 320,['height'] = 128,['type'] = 'dirt'},
[51] = {['x'] = 192,['y'] = 320,['width'] = 192,['height'] = 128,['type'] = 'dirt'},
[52] = {['x'] = -64,['y'] = 320,['width'] = 256,['height'] = 128,['type'] = 'dirt'},
[53] = {['x'] = -384,['y'] = 320,['width'] = 320,['height'] = 128,['type'] = 'dirt'},
[54] = {['x'] = -704,['y'] = 320,['width'] = 320,['height'] = 128,['type'] = 'dirt'},
[55] = {['x'] = 512,['y'] = -960,['width'] = 192,['height'] = 1280,['type'] = 'dirt'},
[56] = {['x'] = -704,['y'] = -960,['width'] = 192,['height'] = 1280,['type'] = 'dirt'},
[57] = {['permeable'] = true,['x'] = -128,['y'] = -1024,['width'] = 256,['height'] = 64,['type'] = 'sign',text="Good Job!!"},
[58] = {['x'] = 1024,['y'] = -960,['width'] = 128,['height'] = 64,['type'] = 'stonebrick'},
[59] = {['x'] = 832,['y'] = -960,['width'] = 128,['height'] = 64,['type'] = 'stonebrick'},
[60] = {['x'] = 896,['y'] = -1024,['width'] = 128,['height'] = 64,['type'] = 'stonebrick'},
[61] = {['x'] = 1024,['y'] = -1088,['width'] = 192,['height'] = 128,['type'] = 'stonebrick'},
[62] = {['x'] = 1216,['y'] = -1280,['width'] = 192,['height'] = 320,['type'] = 'stonebrick'},
[63] = {['x'] = 1216,['y'] = -1472,['width'] = 192,['height'] = 192,['type'] = 'stonebrick'},
[64] = {['x'] = 896,['y'] = -1472,['width'] = 320,['height'] = 128,['type'] = 'stonebrick'},
[65] = {['x'] = 576,['y'] = -1472,['width'] = 320,['height'] = 128,['type'] = 'stonebrick'},
[66] = {['x'] = 960,['y'] = -1152,['width'] = 256,['height'] = 64,['type'] = 'stonebrick'},
[67] = {['x'] = 768,['y'] = -1088,['width'] = 256,['height'] = 64,['type'] = 'stonebrick'},
[68] = {['x'] = 640,['y'] = -1024,['width'] = 256,['height'] = 64,['type'] = 'stonebrick'},
[69] = {['x'] = 256,['y'] = -1472,['width'] = 320,['height'] = 128,['type'] = 'stonebrick'},
[70] = {['x'] = -64,['y'] = -1472,['width'] = 320,['height'] = 128,['type'] = 'stonebrick'},
[71] = {['x'] = -384,['y'] = -1472,['width'] = 320,['height'] = 128,['type'] = 'stonebrick'},
[72] = {['x'] = -704,['y'] = -1344,['width'] = 256,['height'] = 64,['type'] = 'stonebrick'},
[73] = {['x'] = -704,['y'] = -1472,['width'] = 320,['height'] = 128,['type'] = 'stonebrick'},
[74] = {['x'] = -704,['y'] = -1280,['width'] = 192,['height'] = 128,['type'] = 'stonebrick'},
[75] = {['x'] = -704,['y'] = -1152,['width'] = 192,['height'] = 64,['type'] = 'stonebrick'},
[76] = {['x'] = -704,['y'] = -1088,['width'] = 192,['height'] = 128,['type'] = 'stonebrick'}}

level.enemydrops = {}
return level
