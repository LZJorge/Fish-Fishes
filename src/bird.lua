local bird = {}
local direction = 1

function bird.init()
    bird.size = 10
    bird.speed = 300
    bird.hitbox = bird.size + 5
    bird.y = math.random(bird.size, love.graphics.getHeight() / 2 - bird.size)
    bird.x = bird.size
end

function bird.draw()
    -- Dibujar Aves
    love.graphics.setColor(0, 0, 1)
    love.graphics.circle('fill', bird.x, bird.y, bird.size, bird.size * 2)
end

function bird.regenerate()
    local side = math.random()

    if side < 0.5 then
        bird.x = bird.size
        direction = 1
    else
        bird.x = love.graphics.getWidth() - bird.size
        direction = -1
    end
end

function bird.move(dt)        
    bird.x = bird.x + bird.speed * direction * dt

    if bird.x < bird.size or bird.x > love.graphics.getWidth() - bird.size then
        direction = -direction
    end
end

return bird