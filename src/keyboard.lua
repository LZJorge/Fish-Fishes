local game = require 'src.game'
local states = require 'src.states'
local keyboard = {}

-- Acciones para mover al jugador
function keyboard.movement(player)
    local vx, vy = player.collider:getLinearVelocity()

    -- Solo puede moverse si está en el agua
    if player.isInWater then
        -- Movimiento horizontal
        if(love.keyboard.isDown('left')) and vx > -(player.topSpeed - 100) then
            player.collider:applyForce(-player.speed, 0)
            player.sprite = love.graphics.newImage('assets/entities/player/playerLeft.png')
        end

        if(love.keyboard.isDown('right')) and vx < player.topSpeed - 100 then
            player.collider:applyForce(player.speed, 0)
            player.sprite = love.graphics.newImage('assets/entities/player/player.png')
        end
    
        -- Movimiento vertical
        if(love.keyboard.isDown('up')) and vy > -player.topSpeed then
            player.collider:applyForce(0, -player.speed)
        end

        if(love.keyboard.isDown('down')) and vy < player.topSpeed then
            player.collider:applyForce(0, player.speed)
        end
    end
end

-- Acciones para activar o desactivar la pausa del juego
function keyboard.helpers(state)
    function love.keypressed(key)
        if key == 'escape' then
            if state == states.PLAYING then
                game.pause()
            elseif state == states.PAUSED then
                game.play()
            end
        end
    end
end

-- Acciones para activar o desactivar la pausa del juego
function keyboard.restart(state, entities)
    function love.keypressed(key)
        if key == 'r' then
            game.restart(entities)
        end

        if key == 'escape' then
            if state == states.GAMEOVER then
                game.isOnMenu()
            end
        end
    end
end

function keyboard.onKeyboardMenu()
    function love.keypressed(key)
        if key == 'escape' then
            game.isOnMenu()
        end
    end
end

function keyboard.draw(font)
    local function centerX(text)
        return (love.graphics.getWidth() / 2) - (font:getWidth(text) / 2)
    end

    -- Dibujar todos los controles disponibles centrados
    love.graphics.setColor(255, 255, 255)

    love.graphics.newFont(24)
    love.graphics.print('Controles', centerX('Controles'), 40)
    love.graphics.newFont(14)

    -- usar print para dibujar texto centrado en la pantalla

    love.graphics.newFont(18)
    love.graphics.print('Movimiento', centerX('Movimiento'), 120)
    love.graphics.newFont(14)

    -- Dibujar todos los controles disponibles centrados con sus respectivas flechas
    love.graphics.print('Arriba: Flecha arriba', centerX('Arriba: Flecha arriba'), 160)
    love.graphics.print('Abajo: Flecha abajo', centerX('Abajo: Flecha abajo'), 180)
    love.graphics.print('Izquierda: Flecha izquierda', centerX('Izquierda: Flecha izquierda'), 200)
    love.graphics.print('Derecha: Flecha derecha', centerX('Derecha: Flecha derecha'), 220)

    -- Durante el juego
    love.graphics.newFont(18)
    love.graphics.print('Durante la partida', centerX('Durante la partida'), 260)
    
    love.graphics.newFont(14)
    love.graphics.print('Pausa: Escape', centerX('Pausa: Escape'), 300)


    -- Al terminar el juego
    love.graphics.newFont(18)
    love.graphics.print('Al terminar la partida', centerX('Al terminar la partida'), 340)
    
    love.graphics.newFont(14)
    love.graphics.print('Reiniciar: R', centerX('Reiniciar: R'), 360)
    love.graphics.print('Menu: Escape', centerX('Menu: Escape'), 380)

    love.graphics.newFont(18)
    love.graphics.print('Volver: Escape', centerX('Volver: Escape'), love.graphics.getHeight() - 60)

    love.graphics.setColor(255, 255, 255)
end

return keyboard