local bounds = require('src.bounds')
local player = require('src.player')
local keyboard = require('src.keyboard')
local bird = require('src.bird')

local score

function love.load()
    player.init()
    bird.init()
    score = 0
end

function love.update(dt)
    -- Mover jugador
    keyboard.move(player, dt, CanMove)

    -- Checar colisiones
    bounds.checkScreen(player, love.graphics.getWidth(), love.graphics.getHeight())
    local birdCollision = bounds.checkCollision(player, bird)
    if birdCollision then
        score = score + 10
        bird.regenerate()
    end

    -- Dibujar Aves
    bird.move(dt)
end

function love.draw()
    -- Dibujar línea de separacion entre agua y cielo en el medio de la pantalla
    love.graphics.line(0,
        love.graphics.getHeight() / 2,
        love.graphics.getWidth(),
        love.graphics.getHeight() / 2
    )

    love.graphics.setColor(255, 255, 255)
    love.graphics.print('score: ' ..score, 30, 30)

    player.draw()
    bird.draw()
end