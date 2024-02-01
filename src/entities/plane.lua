require 'src.layers'
local timer = require 'libs.hump.timer'
local Plane = {}
local getRandomSide = require 'src.utils.getEntityRandomSide'

-- Iniciar características del avion
function Plane:new(world)
    local obj = setmetatable({}, { __index = Plane })

    obj.world = world
    
    -- Tamaño del 'personaje'
    obj.size = 20

    -- El personaje empieza en el centro horizontalmente y a 1/4 verticalmente
    obj.x = obj.size
    obj.y = math.random(30, 280)
    obj.direction = 1

    -- Velocidad del ave
    obj.speed = math.random(10, 15)
    obj.topSpeed = 256

    obj.collider = obj.world:newBSGRectangleCollider(obj.x, obj.y, obj.size, obj.size, obj.size / 3)
    obj.collider:setCollisionClass(Layers.PLANE)
    obj.collider:setGravityScale(0)
    obj.collider:setObject(obj)

    return obj
end

-- Mover aviones en la misma dirección unicamente
function Plane:move()
    local vx = self.collider:getLinearVelocity()

    if self.direction == 1 and vx <= self.topSpeed then
        self.collider:setLinearVelocity(self.topSpeed, 0)
    elseif  self.direction == 0 and vx >= -self.topSpeed then
        self.collider:setLinearVelocity(-self.topSpeed, 0)
    end

    if self.collider:enter(Layers.WALL) then
        self:reset()
    end
end

-- Reiniciar aviones luego de salir del mapa
function Plane:reset()
    self.collider:setPosition(-1000, -1000)
    self.speed = 0
    self.collider:setLinearVelocity(0, 0)

    -- Aparecen luego de 2 segundos
    timer.after(2, function () self:reapear() end)
end

-- Reaparecer aves
function Plane:reapear()
    self.speed = math.random(10, 15)
    self.x = getRandomSide(self.size)
    
    if self.x == self.size then
        self.direction = 1
    else
        self.direction = 0
    end

    self.y = math.random(40, 280)
    self.collider:setPosition(self.x, self.y)
end

return Plane