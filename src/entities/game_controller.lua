require "../constants"

GameController = {
    playingAreaWidth = constants.windowWidth,
    playingAreaHeight = constants.windowHeight,
    score = 0,
    upcomingPipe = 1,
    bgSpeed = 40,

    bgX1 = 0,
    bgX2 = constants.windowWidth,

    scoreFont = love.graphics.newFont("res/font.ttf", 50)
}

function GameController:create(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.playingAreaWidth = o.playingAreaWidth or constants.windowWidth
    self.playingAreaHeight = o.playingAreaHeight or constants.windowHeight
    self.score = o.score or 0

    self.scoreFont:setFilter("nearest")
    love.graphics.setFont(self.scoreFont)

    return o
end

function GameController:reset()
    self.score = 0
    self.upcomingPipe = 1
end

function GameController:playerDied(bird, pipes)
    if bird:isCollidingWithPipe(pipes.topX, pipes.topSpaceY, pipes.spaceHeight, pipes.width) or
        bird:isCollidingWithPipe(pipes.bottomX, pipes.bottomSpaceY, pipes.spaceHeight, pipes.width) or bird.y >
        self.playingAreaHeight then
        local maxScore = self:loadMaxScore()
        if maxScore < self.score then
            self:saveMaxScore()
        end
        return true
    end

    return false
end

function GameController:checkPlayerScored(bird, pipes)
    local function updateScoreAndClosestPipe(thisPipe, pipeX, pipeWidth, otherPipe)
        if self.upcomingPipe == thisPipe and (bird.x > (pipeX + pipeWidth)) then
            self.score = self.score + 1
            self.upcomingPipe = otherPipe
        end
    end

    updateScoreAndClosestPipe(1, pipes.topX, pipes.width, 2)
    updateScoreAndClosestPipe(2, pipes.bottomX, pipes.width, 1)
end

function GameController:updateBGPosition(dt)
    local function moveIndividual(xPos)
        xPos = xPos - (self.bgSpeed * dt)

        if (xPos + self.playingAreaWidth) < 0 then
            xPos = constants.windowWidth
        end

        return xPos
    end
    
    self.bgX1 = moveIndividual(self.bgX1)
    self.bgX2 = moveIndividual(self.bgX2)
end

function GameController:saveMaxScore()
    local serializedData = "return { maxScore = " .. self.score .. " }"
    love.filesystem.write("savegame.txt", serializedData)
end

function GameController:loadMaxScore()
    if not love.filesystem.getInfo("savegame.txt") then
        self:saveMaxScore()
        return self.score
    end
    local data = love.filesystem.load("savegame.txt")()
    return data.maxScore
end

function GameController:drawGameField()
    local bg = love.graphics.newImage("res/bg.png")
    love.graphics.draw(bg, self.bgX1, 0)
    love.graphics.draw(bg, self.bgX2, 0)
end

function GameController:drawScore()
    love.graphics.setColor(1, 1, 1)
    local maxScore = self:loadMaxScore()
    love.graphics.print(self.score, self.playingAreaWidth / 2 - 25, 15)
end

function GameController:drawGameTitle()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Bird", self.playingAreaWidth / 2 - 25, 15)
end

function GameController:drawMaxScore()
    local maxScore = self:loadMaxScore()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Max score " .. maxScore, 15, 45)
end
