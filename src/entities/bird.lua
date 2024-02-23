require 'src.layers'
local timer = require 'libs.hump.timer'
local Bird = {}
local getRandomSide = require 'src.utils.getEntityRandomSide'

-- Iniciar características del ave
function Bird:new(world)
    local obj = setmetatable({}, { __index = Bird })

    obj.world = world
    
    -- Tamaño del 'personaje'
    obj.size = 20

    -- El personaje empieza en el centro horizontalmente y a 1/4 verticalmente
    obj.x = getRandomSide(obj.size)
    obj.y = math.random(40, 280)

    -- Velocidad del ave
    obj.direction = math.random(0, 1)

    -- Textura
    obj.sprite = love.graphics.newImage('assets/entities/bird/bird1.png')

    -- Collider del ave
    obj.collider = obj.world:newRectangleCollider(obj.x, obj.y, obj.size, obj.size)
    obj.collider:setRestitution(0.2)
    obj.collider:setCollisionClass(Layers.BIRD)
    obj.collider:setGravityScale(0)
    obj.collider:setObject(obj)

    return obj
end

-- Mover aves aleatoriamente
function Bird:move()
    self.collider:applyLinearImpulse(math.random(-15, 15), math.random(-5, 5))

    self.x = self.collider:getX()
    self.y = self.collider:getY()

    if self.collider:enter(Layers.WALL) then
        self.direction = -self.direction
    end
end

-- Reiniciar aves luego de colisionar con el jugador
function Bird:reset()
    self.collider:setPosition(-1000, -1000)

    -- Aparecen luego de 3 segundos
    timer.after(3, function () self:reapear() end)
end

-- Reaparecer aves
function Bird:reapear()
    self.direction = math.random(0, 1)
    self.x = getRandomSide(self.size)
    self.y = math.random(40, 280)
    self.collider:setPosition(self.x, self.y)
end

-- Dibujar aves
function Bird:draw()
    -- self.animations.left:draw(self.spriteSheet, self.x, self.y, nil, 4)
    love.graphics.draw(
        self.sprite, 
        self.x, 
        self.y, 
        0, 
        1.2, 
        1.2, 
        self.sprite:getWidth() / 2,
        self.sprite:getHeight() / 2
    )
end

return Bird