local Player = {}

-- Iniciar características del jugador
function Player:new()
    local obj = setmetatable({}, { __index = Player })

    -- Tamaño del 'personaje'
    obj.size = 20

    -- El personaje empieza en el centro horizontalmente y a 1/4 verticalmente
    obj.x = (love.graphics.getWidth() - obj.size) / 2
    obj.y = (love.graphics.getHeight() - obj.size) - (love.graphics.getHeight() / 4)

    -- Velocidad del personaje
    obj.speedX = 200
    obj.speedY = 200
    obj.topSpeed = 800
    obj.gravity = 20

    -- Tamaño de area de colisión del personaje
    obj.hitbox = obj.size + 5

    return obj
end

-- Dibujar jugador en pantalla
function Player:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle(
        'fill',
        self.x,
        self.y,
        self.size, self.size
    )
end

return Player