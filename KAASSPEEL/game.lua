local composer = require("composer")
local scene = composer.newScene()

-- responsive
local a = 1/6
local b = 1/3
local c = 3/6
local d = 2/6
local e = 1/2
local H = display.contentHeight
local W = display.contentWidth

local kaas
local i = 0 
local score

--knop naar menu
local function naarMenu()
    composer.gotoScene("menu", { effect="slideRight", time=400 })
end

local function taplistener(event)
    i = i +1
    score.text = tostring(i)
    print('Score',i)
    transition.to(kaas, {
        time = 80,
        xScale = 1.2,
        yScale = 0.8,
        onComplete = function()
            transition.to(kaas, {
                time = 50,
                xScale = 1,
                yScale = 1
            })
        end
    })
end

function scene:create(event)
    local sceneGroup = self.view
    
    local bg = display.newImageRect(sceneGroup,"fotos/content.png",display.actualContentWidth,display.actualContentHeight)
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY

    kaas = display.newImageRect(sceneGroup,"fotos/kaas.png", 175, 175)
    kaas.x = e*W
    kaas.y = b*H
    kaas:addEventListener('tap',taplistener)

    score = display.newText(sceneGroup,tostring(i),e*W, a*H, native.systemFont, 30)
    score:setFillColor(0,0,0)
    print(score.text)

    local knop = display.newImageRect(sceneGroup,"fotos/menu.png",75,75)
    knop.anchorX = 1
    knop.anchorY = 0
    knop.x = 1*W
    knop.y = 0*H - 50
    

    ---local knop = display.newText(sceneGroup,"Menu", display.contentCenterX, 500, native.systemFont, 30)
    ---knop:setFillColor(1,1,1)
    knop:addEventListener("tap", function()
        composer.gotoScene("menu", { effect="slideLeft", time=400 })
    end)
    
    
end



scene:addEventListener("create", scene)
return scene
