local game = require('src.game')
local bounds = require('src.bounds')
local player = require('src.player')
local keyboard = require('src.keyboard')
local bird = require('src.bird')

function love.load()
    player.init()
    bird.init()
    game.init()
end

function love.update(dt)
    -- Acciones que pueden ocurrir mientras el juego está en pausa
    keyboard.helpers(game.state)

    -- Acciones que pueden ocurrir mientras el juego NO está en pausa
    if game.state.playing then
        -- Mover jugador
        keyboard.move(player, dt, CanMove)

        -- Checar colisiones con el borde de la pantalla
        bounds.checkScreen(player, love.graphics.getWidth(), love.graphics.getHeight())

        -- Checar colisiones con las aves
        local birdCollision = bounds.checkCollision(player, bird)
        if birdCollision then
            game.updateScore()
            bird.regenerate()
        end

        -- Iniciar movimiento de las aves
        bird.move(dt)
    end
end

function love.draw()
    -- Dibujar línea de separacion entre agua y cielo en el medio de la pantalla
    love.graphics.line(0,
        love.graphics.getHeight() / 2,
        love.graphics.getWidth(),
        love.graphics.getHeight() / 2
    )

    -- Dibujar puntuación
    game.drawScore()

    -- Dibujar entidades
    player.draw()
    bird.draw()

    -- Dibujar PAUSA en caso de estar pausado el juego
    if game.state.paused then
        love.graphics.print('PAUSA', love.graphics.getWidth() / 2 - 25, 50)
    end
end