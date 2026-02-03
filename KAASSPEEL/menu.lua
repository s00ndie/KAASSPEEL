local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    
    local title = display.newText(
        sceneGroup,
        "MENU",
        display.contentCenterX,
        display.contentCenterY - 100,
        native.systemFontBold,
        40
    )
    title:setFillColor(1, 0.9, 0.2)
    local startBtn = display.newText(
        sceneGroup,
        "Cheese clicker",
        display.contentCenterX,
        display.contentCenterY,
        native.systemFont,
        30
    )
    startBtn:setFillColor(1, 0.9, 0.2)

    startBtn:addEventListener("tap", function()
        composer.gotoScene("game", { effect="slideLeft", time=400 })
    end)

    local startBtn2 = display.newText(
        sceneGroup,
        "Whack a chees",
        display.contentCenterX,
        display.contentCenterY + 60,
        native.systemFont,
        30
    )
    startBtn2:setFillColor(1, 0.9, 0.2)
    startBtn2:addEventListener("tap", function()
        composer.gotoScene("game2", { effect="slideLeft", time=400 })
    end)
end

scene:addEventListener("create", scene)
return scene