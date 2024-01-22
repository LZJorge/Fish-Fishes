local bird = {}
local direction = 1

-- Iniciar características del ave
function bird.init()
    -- Tamaño del ave
    bird.size = 10

    -- Velocidad del ave (aleatoria entre 200 y 400)
    bird.speed = math.random(200, 400)

    -- Tamaño de área de colision del ave
    bird.hitbox = bird.size + 5

    -- Posicion del ave (aleatoria en el eje Y) 
    bird.y = math.random(bird.size, love.graphics.getHeight() / 2 - bird.size)
    bird.x = bird.size -- Inicia en el lado izquiero
end

-- Dibujar ave
function bird.draw()
    love.graphics.setColor(0, 0, 1) -- Aplicar colores
    love.graphics.circle('fill', bird.x, bird.y, bird.size, bird.size * 2)
    love.graphics.setColor(255, 255, 255) -- Reiniciar colores
end

-- Regenerar ave una vez colisionada con el jugador
function bird.regenerate()
    bird.init()    
    local side = math.random()

    if side < 0.5 then
        bird.x = bird.size
        direction = 1
    else
        bird.x = love.graphics.getWidth() - bird.size
        direction = -1
    end
end

-- Iniciar el movimiento del ave
function bird.move(dt)   
    bird.x = bird.x + bird.speed * direction * dt

    -- Cambiar el sentido del movimiento si choca con el borde de la pantalla
    if bird.x < bird.size or bird.x > love.graphics.getWidth() - bird.size then
        direction = -direction
    end
end

return bird