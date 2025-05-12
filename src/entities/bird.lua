Bird = {
    x = 62,
    y = 200,
    width = 30,
    height = 25,
    speed = 0,
    sprite = love.graphics.newImage("res/bird.png")
}

function Bird:create(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    self.x = o.x or 62
    self.y = o.y or 200
    self.width = o.width or 30
    self.height = o.height or 25
    self.speed = o.speed or 0
    self.sprite = o.sprite or love.graphics.newImage("res/bird.png")

    return o
end

function Bird:reset()
    self.y = 200
    self.speed = 0
end

function Bird:update(dt)
    self.speed = self.speed + (516 * dt)
    self.y = self.y + (self.speed * dt)
end

function Bird:isCollidingWithPipe(pipeX, pipeSpaceY, pipeSpaceHeight, pipeWidth)
    return
    -- Left edge of bird is to the left of the right edge of pipe
    self.x < (pipeX + pipeWidth)
    and
     -- Right edge of bird is to the right of the left edge of pipe
    (self.x + self.width) > pipeX
    and (
        -- Top edge of bird is above the bottom edge of first pipe segment
        self.y < pipeSpaceY
        or
        -- Bottom edge of bird is below the top edge of second pipe segment
        (self.y + self.height) > (pipeSpaceY + pipeSpaceHeight)
    )
end

function Bird:move()
    if self.y > 0 then
        self.speed = -165
    end
end

function Bird:draw()
    local width  = self.sprite:getWidth()
	local height = self.sprite:getHeight()
	local quad         = love.graphics.newQuad(0, 0, width, height, width, height)
    love.graphics.draw(self.sprite, quad, self.x, self.y)
end