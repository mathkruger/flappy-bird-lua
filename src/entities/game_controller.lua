require "../constants"

GameController = {
    playingAreaWidth = constants.windowWidth,
    playingAreaHeight = constants.windowHeight,
    score = 0,
    upcomingPipe = 1
}

function GameController:create(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.playingAreaWidth = o.playingAreaWidth or constants.windowWidth
    self.playingAreaHeight = o.playingAreaHeight or constants.windowHeight
    self.score = o.score or 0

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

function GameController:drawGameField()
    love.graphics.setColor(.14, .36, .46)
    love.graphics.rectangle('fill', 0, 0, self.playingAreaWidth, self.playingAreaHeight)
end

function GameController:drawScore()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.score, 15, 15)
end
