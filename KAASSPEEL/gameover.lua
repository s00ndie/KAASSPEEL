local composer = require("composer")
local scene = composer.newScene()


local currentScore = composer.getVariable('currentScore') or 0
local maxScore = composer.getVariable('maxScore') or 0

function scene:create(event)
    local sceneGroup = self.view

    local bg = display.newRect(sceneGroup,display.contentCenterX,display.contentCenterY, display.actualContentWidth ,display.actualContentHeight)
    bg:setFillColor(0.1 , 0.1 , 0.2)

    local gameOverText = display.newText(sceneGroup,'GAME OVER!\n\nScore: '.. currentScore .. '\nMax Score: ' .. maxScore , display.contentCenterX , display.contentHeight *0.2 , native.systemFontBold, 15 , 'center')
    gameOverText:setFillColor(1, 0.3, 0.3)
    
    local menuBtn = display.newRoundedRect(sceneGroup,display.contentCenterX,display.contentHeight * 0.82 , 280,90,25)
    menuBtn:setFillColor(0.8,0.4,0.2)

    local menuText = display.newText(sceneGroup,'MENU', display.contentCenterX,display.contentHeight * 0.82,native.systemFontBold, 42)
    menuText:setFillColor(1,1,1)

    

    local function goToMenu()
        composer.gotoScene('menu',{time=400,effect='slideLeft'})
    end

    
    menuBtn:addEventListener('tap', goToMenu)
    menuText:addEventListener('tap', goToMenu)
end

scene:addEventListener('create', scene)
return scene