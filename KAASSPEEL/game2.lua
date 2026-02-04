display.setStatusBar(display.HiddenStatusBar)
math.randomseed(os.time())
--chees movement
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
local currentScore = 0
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

local gameTime = 30
local timeLeft = gameTime
local timeText
local countdownTimer   -- ← правильна назва, без опечаток!

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
    knop.y = -50                  
    knop:addEventListener("tap", function()
        composer.gotoScene("menu", { effect="slideLeft", time=400 })
    end)

    scoreText = display.newText({
        parent = sceneGroup,
        text = "Score: 0",
        x = d*W,
        y = 0,
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
        y = 0,
        font = native.systemFont,
        fontSize = 15
    })
    maxScoreText:setFillColor(1, 0.9, 0.2)

    timeText = display.newText({
        parent = sceneGroup,
        text = "Time: " .. gameTime,
        x = display.contentCenterX,
        y = 60,
        font = native.systemFontBold,
        fontSize = 36
    })
    timeText:setFillColor(1,1,0)
end

local function updateCountdown()
    timeLeft = timeLeft - 1
    timeText.text = "Time: " .. timeLeft

    if timeLeft <= 0 then
        timer.cancel(countdownTimer)
        countdownTimer = nil

        composer.setVariable("currentScore", currentScore)
        composer.setVariable("maxScore", maxScore)

        composer.gotoScene("gameover", {
            time = 600,
            effect = "fade"
        })
    end
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

    local sceneGroup = scene.view

    mole = display.newImageRect(sceneGroup, "fotos/kaas.png", 90, 90)
    mole.x = x
    mole.y = y

    mole:addEventListener("touch", function(event)
        if event.phase ~= "began" then return false end   

        currentScore = currentScore + 1
        scoreText.text = "Score: " .. currentScore
        
        if currentScore > maxScore then
            maxScore = currentScore
            maxScoreText.text = "Max: " .. maxScore
            saveMaxScore(maxScore)
        end

        removeMole()
        spawnMole()

        return true
    end)
end

function scene:show(event)
    if event.phase == "did" then
        currentScore = 0 
        scoreText.text = "Score: 0"
        timeLeft = gameTime
        timeText.text = "Time: " .. gameTime
        gameActive = true

        spawnMole()

        -- Запускаємо таймер — тепер правильно
        countdownTimer = timer.performWithDelay(1000, updateCountdown, gameTime)
    end
end

function scene:hide(event)
    if event.phase == "will" then
        if countdownTimer then
            timer.cancel(countdownTimer)
            countdownTimer = nil
        end
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene