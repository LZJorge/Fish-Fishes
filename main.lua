local game = require('src.game')
local bounds = require('src.bounds')
local Player = require('src.player')
local keyboard = require('src.keyboard')
local Bird = require('src.bird')

local bird = {}
local player = {}

function love.load()
    player = Player:new()

    game.init()

    -- Cantidad de aves: 3
    for i = 1, 3 do
        bird[i] = Bird:new()
    end
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

        for i = 1, #bird do
            -- Checar colisiones con las aves
            local birdCollision = bounds.checkCollision(player, bird[i])
            if birdCollision then
                game.updateScore()
                bird[i]:regenerate()
            end

            -- Iniciar movimiento de las aves
            bird[i]:move(dt)
        end
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
    player:draw()
    for i = 1, #bird do
        bird[i]:draw()
    end

    -- Dibujar PAUSA en caso de estar pausado el juego
    if game.state.paused then
        love.graphics.print('PAUSA', love.graphics.getWidth() / 2 - 25, 50)
    end
end