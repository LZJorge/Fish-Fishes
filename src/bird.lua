local Bird = {}

function Bird:new()
    local obj = setmetatable({}, { __index = Bird })
    -- Tamaño del ave
    obj.size = 10

    -- Velocidad del ave (aleatoria entre 200 y 400)
    obj.speed = math.random(200, 400)

    -- Dirección del ave
    obj.direction = 1

    -- Tamaño de área de colision del ave
    obj.hitbox = obj.size + 5

    -- Posicion del ave (aleatoria en el eje Y) 
    obj.y = math.random(obj.size, love.graphics.getHeight() / 2 - obj.size)
    obj.x = obj.size -- Inicia en el lado izquierdo

    return obj
end

function Bird:draw()
    love.graphics.setColor(0, 0, 1) -- Aplicar colores
    love.graphics.circle('fill', self.x, self.y, self.size, self.size * 2)
    love.graphics.setColor(255, 255, 255) -- Reiniciar colores
end

function Bird:regenerate()
    self.speed = math.random(200, 400)
    self.y = math.random(self.size, love.graphics.getHeight() / 2 - self.size)

    local side = math.random()

    if side < 0.5 then
        self.x = self.size
        self.direction = 1
    else
        self.x = love.graphics.getWidth() - self.size
        self.direction = -1
    end
end

-- Iniciar el movimiento del ave
function Bird:move(dt)   
    self.x = self.x + self.speed * self.direction * dt

    -- Cambiar el sentido del movimiento si choca con el borde de la pantalla
    if self.x < self.size or self.x > love.graphics.getWidth() - self.size then
        -- self.direction = -self.
        self:regenerate()
    end
end

return Bird