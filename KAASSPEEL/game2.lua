display.setStatusBar( display.HiddenStatusBar )
math.randomseed(os.time())

local composer = require("composer")
local scene = composer.newScene()

local saveFile = 'maxScore.txt'

local function loadMaxScore()
    local path = system.pathForFile(saveFile, system.DocumentsDirectory)
    local file = io.open(path, "r")
    if file then
        local contents = file:read("*a")
        io.close(file)
        return tonumber(contents) or 0
    end
    return 0
end

local gameActive = true
local score = 0
local scoreText
local maxScoreText
local mole
local maxScore = loadMaxScore()
local a = 1/6
local b = 3/6
local c = 1
local d = 1/2
local H = display.contentHeight
local W = display.contentWidth

local function saveMaxScore(value)
    local path = system.pathForFile(saveFile, system.DocumentsDirectory)
    local file = io.open(path, 'w')
    if file then
        file:write(tostring(value))
        io.close(file)
    end
end

function scene:create(event)
    local sceneGroup = self.view  

    local bg = display.newImageRect(sceneGroup, "fotos/content.png", display.actualContentWidth, display.actualContentHeight)
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY

    local knop = display.newImageRect(sceneGroup, "fotos/menu.png", 75, 75)
    knop.anchorX = 1
    knop.anchorY = 0
    knop.x = W
    knop.y = 0 - 50                  
    knop:addEventListener("tap", function()
        composer.gotoScene("menu", { effect="slideLeft", time=400 })
    end)


    scoreText = display.newText({
        parent = sceneGroup,
        text = "Score: 0",
        x = d*W,
        y = 0 ,
        font = native.systemFont,
        fontSize = 30
    })
    scoreText:setFillColor(1, 0.9, 0.2)
    scoreText.strokeWidth = 4
    scoreText:setStrokeColor(1,0,0)

    maxScoreText = display.newText({
        parent = sceneGroup,
        text = "Max: " .. maxScore,
        x = a*W,
        y = 0 ,
        font = native.systemFont,
        fontSize = 15
    })
    maxScoreText:setFillColor(1, 0.9, 0.2)
    maxScoreText.strokeWidth = 4
    maxScoreText:setStrokeColor(0,0,0)
end

local function removeMole()
    if mole and mole.removeSelf then
        mole:removeSelf()
        mole = nil
    end
end

local function spawnMole()
    removeMole()

    local x = math.random(50, display.contentWidth - 50)
    local y = math.random(100, display.contentHeight - 100)

    -- !!! sceneGroup беремо з self.view !!!
    local sceneGroup = scene.view

    mole = display.newImageRect(sceneGroup, "fotos/kaas.png", 90, 90)
    mole.x = x
    mole.y = y

    mole:addEventListener("touch", function(event)
        if event.phase ~= "began" then return false end   -- ТІЛЬКИ began!

        score = score + 1
        scoreText.text = "Score: " .. score
        
        if score > maxScore then
            maxScore = score
            maxScoreText.text = "Max: " .. maxScore
            saveMaxScore(maxScore)
        end

        removeMole()
        spawnMole()          -- новий крот одразу

        return true
    end)
end

local gameOverText, restartBtn, restartText  -- оголосимо, щоб уникнути помилок

local function showGameOver()
    gameActive = false
    removeMole()

    local sceneGroup = scene.view

    gameOverText = display.newText({
        parent = sceneGroup,
        text = "Game Over!\nScore: " .. score,
        x = W/2,
        y = H/2 - 40,
        font = native.systemFontBold,
        fontSize = 48,
        align = "center"
    })
    gameOverText:setFillColor(1, 0.3, 0.3)

    restartBtn = display.newRoundedRect(sceneGroup, W/2, H*0.75, 220, 80, 16)
    restartBtn:setFillColor(0.1, 0.7, 0.2)

    restartText = display.newText({
        parent = sceneGroup,
        text = "RESTART",
        x = W/2,
        y = H*0.75,
        font = native.systemFontBold,
        fontSize = 34
    })
    restartText:setFillColor(1,1,1)

    local function restartGame()
        removeMole()  -- на всяк випадок

        if gameOverText then gameOverText:removeSelf() gameOverText = nil end
        if restartBtn    then restartBtn:removeSelf()    restartBtn = nil end
        if restartText   then restartText:removeSelf()   restartText = nil end

        score = 0
        scoreText.text = "Score: 0"
        gameActive = true

        spawnMole()
    end

    restartBtn:addEventListener("tap", restartGame)
    restartText:addEventListener("tap", restartGame)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "did" then
        -- гра стартує тільки тут!
        spawnMole()

        -- Якщо хочеш обмежити час гри, розкоментуй:
        -- timer.performWithDelay(30000, function()
        --     if gameActive then showGameOver() end
        -- end, 1)
    end
end

-- !!! Видали ці рядки – вони ламають усе !!!
-- scoreText = display.newText(...)
-- maxScoreText = display.newText(...)
-- spawnMole()

scene:addEventListener("create", scene)
scene:addEventListener("show",   scene)

return scene