require 'src.layers'
local timer = require 'libs.hump.timer'
local Bird = {}

local function getSide(size)
    local x
    local side = math.random(0, 1)
    if side == 0 then
        x = size
    else
        x = love.graphics.getWidth() - size
    end

    return x
end

-- Iniciar características del jugador
function Bird:new(world)
    local self = setmetatable({}, { __index = Bird })

    self.world = world
    
    -- Tamaño del 'personaje'
    self.size = 20

    -- El personaje empieza en el centro horizontalmente y a 1/4 verticalmente
    self.x = getSide(self.size)
    self.y = math.random(40, 280)

    -- Velocidad del ave
    self.speed = math.random(600, 800)
    self.topSpeed = 472
    self.direction = math.random(0, 1)

    self.collider = self.world:newRectangleCollider(self.x, self.y, self.size, self.size)
    self.collider:setRestitution(0.2)
    self.collider:setCollisionClass(Layers.BIRD)
    self.collider:setGravityScale(0)
    self.collider:setObject(self)

    return self
end

-- Mover aves aleatoriamente
function Bird:move()
    self.collider:applyLinearImpulse(math.random(-15, 15), math.random(-5, 5))

    if self.collider:enter('Wall') then
        self.direction = -self.direction
    end
end

-- Reiniciar aves luego de colisionar con el jugador
function Bird:reset()
    self.collider:setPosition(-1000, -1000)
    self.speed = 0

    -- Aparecen luego de 3 segundos
    timer.after(3, function () self:reapear() end)
end

-- Reaparecer aves
function Bird:reapear()
    self.speed = math.random(600, 800)
    self.direction = math.random(0, 1)
    self.x = getSide(self.size)
    self.y = math.random(40, 280)
    self.collider:setPosition(self.x, self.y)
end

return Bird