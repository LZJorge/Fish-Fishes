require 'src.layers'
local timer = require 'libs.hump.timer'
local getRandomSide = require 'src.utils.getEntityRandomSide'
local Crab = {}

-- Obtiene la dirección del cangrejo en función del lado en el que aparece
local function getDirection(x, size)
    local direction
    if x == size then
        direction = 1
    else
        direction = 0
    end
    return direction
end

-- Iniciar características del cangrejo
function Crab:new(world)
    local obj = setmetatable({}, { __index = Crab })

    obj.world = world
    
    -- Tamaño del 'personaje'
    obj.size = 18

    -- El personaje empieza en el centro horizontalmente y a 1/4 verticalmente
    obj.x = getRandomSide(obj.size)
    obj.y = love.graphics.getHeight() - obj.size
    obj.direction = getDirection(obj.x, obj.size)

    -- Velocidad del ave
    obj.speed = math.random(5, 10)
    obj.topSpeed = math.random(100, 150)

    -- Textura
    obj.sprite = love.graphics.newImage('assets/entities/crab/crab.png')

    -- Collider
    obj.collider = obj.world:newRectangleCollider(obj.x, obj.y, obj.size, obj.size)
    obj.collider:setCollisionClass(Layers.CRAB)
    obj.collider:setObject(obj)

    return obj
end

-- Mover cangrejos en la misma dirección unicamente
function Crab:move(player, game)
    local vx = self.collider:getLinearVelocity()
    local _, currentVY = self.collider:getLinearVelocity()

    self.x = self.collider:getX()
    self.y = self.collider:getY()

    if self.direction == 1 and vx <= self.topSpeed then
        self.collider:setLinearVelocity(self.topSpeed, currentVY)
    elseif  self.direction == 0 and vx >= -self.topSpeed then
        self.collider:setLinearVelocity(-self.topSpeed, currentVY)
    end

    if self.collider:enter(Layers.WALL) then
        self:reset()
    end

    -- verificar la colisión con el jugador
    if game.level == 3 and
        self.x < player.x + player.size and
        self.x + self.size > player.x and
        self.y < player.y + player.size and
        self.y + self.size > player.y 
    then
        game.finish()
    end
end

-- Reiniciar cangrejos luego de salir del mapa
function Crab:reset()
    self.collider:setPosition(-1000, -1000)
    self.speed = 0
    self.collider:setLinearVelocity(0, 0)

    -- Aparecen luego de 1, 2 o 3 segundos
    timer.after(math.random(0.2, 3), function ()
        self:reapear()
    end)
end

-- Hacer saltar al cangrejo
function Crab:jump()
    self.collider:setLinearVelocity(0, math.random(-350, -650))
end

-- Reaparecer cangrejos
function Crab:reapear()
    self.speed = math.random(5, 10)
    self.x = getRandomSide(self.size)
    self.y = love.graphics.getHeight() - self.size
    self.direction = getDirection(self.x, self.size)
    self.collider:setPosition(self.x, self.y)
end

-- Dibujar cangrejos
function Crab:draw()

    -- Orientación del sprite izquierda o derecha
    love.graphics.draw(
        self.sprite, 
        self.x, 
        self.y, 
        0, 
        1.8, 
        1.8, 
        self.sprite:getWidth() / 2,
        self.sprite:getHeight() / 2 + 10
    )
end

return Crab