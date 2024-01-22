local player = {}

-- Iniciar características del jugador
function player.init()
    -- Tamaño del 'personaje'
    player.size = 20

    -- El personaje empieza en el centro horizontalmente y a 1/4 verticalmente
    player.x = (love.graphics.getWidth() - player.size) / 2
    player.y = (love.graphics.getHeight() - player.size) - (love.graphics.getHeight() / 4)

    -- Velocidad del personaje
    player.speedX = 200
    player.speedY = 200
    player.topSpeed = 800
    player.gravity = 20

    -- Tamaño de area de colisión del personaje
    player.hitbox = player.size + 5
end

-- Dibujar jugador en pantalla
function player.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle(
        'fill',
        player.x,
        player.y,
        player.size, player.size
    )
end

return player