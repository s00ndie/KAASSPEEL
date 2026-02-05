display.setStatusBar(display.HiddenStatusBar)

local composer = require("composer")

local bgMusic = audio.loadStream('bgmusic.mp3')
audio.setVolume(0.6)
audio.play(bgMusic,{ loops = -1})

composer.gotoScene("menu")

