require('src.keyboard')
CanMove = true

local bounds = {}
function bounds.checkScreen(player, maxWidth, maxHeight)
    -- Colisiones Horizontales
    if player.x < 0 then
        player.x = 0
    end

    if player.x > maxWidth - player.size then
        player.x = maxWidth - player.size
    end

    -- Significa que esta fuera del agua
    -- Colisiones Verticales
    if player.y < maxHeight / 2 then
        -- Fuera del agua no te puedes mover verticalmente
        CanMove = false
        
        player.y = player.y - (player.speedY * 0.02)
        player.speedY = player.speedY - player.gravity
    end

    -- Significa que esta dentro del agua
    if player.y >= (maxHeight / 2) then
        CanMove = true

        if player.speedY < 200 then
            ResetSpeed(player)
        end
    end

    if player.y > maxHeight - player.size then
        player.y = maxHeight - player.size
    end
end

function bounds.checkCollision(player, entity)
    if player.x + player.hitbox > entity.x
    and player.x < entity.x + entity.hitbox
    and player.y + player.hitbox > entity.y
    and player.y < entity.y + entity.hitbox then
        return true
    end

    return false
end

return bounds