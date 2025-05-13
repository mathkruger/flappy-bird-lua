require "entities.bird"
require "entities.pipes"
require "entities.game_controller"

function love.load()
    bird = Bird:create({})
    pipes = Pipes:create({})
    gameController = GameController:create({})

    gameRunning = false

    function reset()
        bird:reset()
        pipes:reset()
        gameController:reset()
        gameRunning = false
    end

    reset()
end

function love.update(dt)
    gameController:updateBGPosition(dt)

    if gameRunning then
        bird:update(dt)
        pipes:update(dt, gameController)

        if gameController:playerDied(bird, pipes) then
            reset()
        end

        gameController:checkPlayerScored(bird, pipes)
    end
end

function handleGameStartAndPlayerMovement()
    if gameRunning == false then
        gameRunning = true
    end

    bird:move()
end

function love.keypressed(key)
    handleGameStartAndPlayerMovement()
end

function love.mousepressed(x, y, button, istouch)
    handleGameStartAndPlayerMovement()
end

function love.draw()
    gameController:drawGameField()
    bird:draw()
    pipes:draw()
    gameController:drawScore()
end
