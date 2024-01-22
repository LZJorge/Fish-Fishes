local game = require('src.game')

local keyboard = {}

function ResetSpeed(player)
    player.speedX = 200
    player.speedY = 200
end

-- Mientras el personaje se pueda mover (dentro del agua) su velocidad va aumentando
local function adjustSpeed(player, dt, CanMove)
    if CanMove then
        if player.speedY < 200 then
            ResetSpeed(player)
        end

        if player.speedY <= player.topSpeed then
            player.speedX = player.speedX + dt * 300
            player.speedY = player.speedY + dt * 300
        end
    end
end

-- Acciones para mover al jugador
function keyboard.move(player, dt, canMove)
    -- Movimiento horizontal
    if(love.keyboard.isDown('left')) then
        player.x = player.x - player.speedX * dt
        adjustSpeed(player, dt, canMove)
    end

    if(love.keyboard.isDown('right')) then
        player.x = player.x + player.speedX * dt
        adjustSpeed(player, dt, canMove)

    end

    if canMove then
        -- Movimiento vertical
        if(love.keyboard.isDown('up')) then
            player.y = player.y - player.speedY * dt
            adjustSpeed(player, dt, canMove)
        end

        if(love.keyboard.isDown('down')) then
            player.y = player.y + player.speedY * dt
            adjustSpeed(player, dt, canMove)
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

return keyboard