require "entities.bird"
require "entities.pipes"
require "entities.game_controller"

function love.load()
    bird = Bird:create({})
    pipes = Pipes:create({})
    gameController = GameController:create({})

    function reset()
        bird:reset()
        pipes:reset()
        gameController:reset()
    end

    reset()
end

function love.update(dt)
    bird:update(dt)
    pipes:update(dt)

    if gameController:playerDied(bird, pipes) then
        reset()
    end

    gameController:checkPlayerScored(bird, pipes)
end

function love.keypressed(key)
    bird:move()
end

function love.draw()
    gameController:drawGameField()
    bird:draw()
    pipes:draw()
    gameController:drawScore()
end