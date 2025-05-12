require "../constants"

function newPipeSpaceY(spaceHeight)
    local pipeSpaceYMin = 54
    local pipeSpaceY = love.math.random(pipeSpaceYMin, constants.windowHeight - spaceHeight - pipeSpaceYMin)
    return pipeSpaceY
end

Pipes = {
    x = 0,

    width = 54,
    spaceHeight = 100,

    topX = 0,
    topSpaceY = 0,

    bottomX = 0,
    bottomSpaceY = 0
}

function Pipes:create(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.x = o.x or 0
    self.width = o.width or 0
    self.spaceHeight = o.spaceHeight or 0

    return o
end

function Pipes:reset()
    self.topX = constants.windowWidth
    self.topSpaceY = newPipeSpaceY(self.spaceHeight)

    self.bottomX = constants.windowWidth + ((constants.windowWidth + self.width) / 2)
    self.bottomSpaceY = newPipeSpaceY(self.spaceHeight)
end

function Pipes:update(dt)
    local function moveIndividual(pipeX, pipeSpaceY)
        pipeX = pipeX - (60 * dt)

        if (pipeX + self.width) < 0 then
            pipeX = constants.windowWidth
            pipeSpaceY = newPipeSpaceY(self.spaceHeight)
        end

        return pipeX, pipeSpaceY
    end
    
    self.topX, self.topSpaceY = moveIndividual(self.topX, self.topSpaceY)
    self.bottomX, self.bottomSpaceY = moveIndividual(self.bottomX, self.bottomSpaceY)
end

function Pipes:draw()
    local function drawIndividual(pipeX, pipeSpaceY)
        love.graphics.setColor(.37, .82, .28)
        love.graphics.rectangle(
            'fill',
            pipeX,
            0,
            self.width,
            pipeSpaceY
        )
        love.graphics.rectangle(
            'fill',
            pipeX,
            pipeSpaceY + self.spaceHeight,
            self.width,
            constants.windowHeight - pipeSpaceY - self.spaceHeight
        )
    end

    drawIndividual(self.topX, self.topSpaceY)
    drawIndividual(self.bottomX, self.bottomSpaceY)
end
