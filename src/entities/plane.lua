require 'src.layers'
local timer = require 'libs.hump.timer'
local Plane = {}
local getRandomSide = require 'src.utils.getEntityRandomSide'

-- Obtiene la dirección del avion en función del lado en el que aparece
local function getDirection(x, size)
    local direction
    if x == size then
        direction = 1
    else
        direction = 0
    end
    return direction
end

-- Iniciar características del avion
function Plane:new(world)
    local obj = setmetatable({}, { __index = Plane })

    obj.world = world
    
    -- Tamaño del 'personaje'
    obj.size = 25

    -- El personaje empieza en el centro horizontalmente y a 1/4 verticalmente
    obj.x = getRandomSide(obj.size)
    obj.y = math.random(30, 280)
    obj.direction = getDirection(obj.x, obj.size)

    -- Velocidad del ave
    obj.speed = math.random(10, 20)
    obj.topSpeed = math.random(180, 300)

    -- Textura
    obj.sprite = love.graphics.newImage('assets/entities/plane/planeRed1.png')

    -- Collider
    obj.collider = obj.world:newRectangleCollider(obj.x, obj.y, obj.size, obj.size)
    obj.collider:setCollisionClass(Layers.PLANE)
    obj.collider:setGravityScale(0)
    obj.collider:setObject(obj)

    return obj
end

-- Mover aviones en la misma dirección unicamente
function Plane:move(player, game)
    local vx = self.collider:getLinearVelocity()

    self.x = self.collider:getX()
    self.y = self.collider:getY()

    if self.direction == 1 and vx <= self.topSpeed then
        self.collider:setLinearVelocity(self.topSpeed, 0)
    elseif  self.direction == 0 and vx >= -self.topSpeed then
        self.collider:setLinearVelocity(-self.topSpeed, 0)
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

-- Reiniciar aviones luego de salir del mapa
function Plane:reset()
    self.collider:setPosition(-1000, -1000)
    self.speed = 0
    self.collider:setLinearVelocity(0, 0)

    -- Aparecen luego de 1, 2 o 3 segundos
    timer.after(math.random(1, 3), function ()
        self:reapear()
    end)
end

-- Reaparecer aviones
function Plane:reapear()
    self.speed = math.random(10, 15)
    self.x = getRandomSide(self.size)
    self.y = math.random(40, 280)
    self.direction = getDirection(self.x, self.size)
    self.collider:setPosition(self.x, self.y)
end

-- Dibujar aviones
function Plane:draw()
    -- Orientación del sprite izquierda o derecha
    if self.direction == 1 then
        self.sprite = love.graphics.newImage('assets/entities/plane/planeRed1.png')
    else
        self.sprite = love.graphics.newImage('assets/entities/plane/planeRed1Left.png')
    end

    love.graphics.draw(
        self.sprite, 
        self.x, 
        self.y, 
        0, 
        0.4, 
        0.4, 
        self.sprite:getWidth() / 2,
        self.sprite:getHeight() / 2
    )
end

return Plane