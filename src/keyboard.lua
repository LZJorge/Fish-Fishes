local game = require 'src.game'
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
            if state.playing then
                game.pause()
            elseif state.paused then
                game.play()
            end
        end
    end
end

-- Acciones para activar o desactivar la pausa del juego
function keyboard.restart(entities)
    function love.keypressed(key)
        if key == 'r' then
            game.restart(entities)
        end
    end
end

return keyboard