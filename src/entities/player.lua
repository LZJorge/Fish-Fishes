require 'src.layers'
local Player = {}

-- Iniciar características del jugador
function Player:new(world)
    -- Tamaño del 'personaje'
    self.size = 20

    -- El personaje empieza en el centro horizontalmente y a 1/4 verticalmente
    self.x = (love.graphics.getWidth() - self.size) / 2
    self.y = (love.graphics.getHeight() - self.size) - (love.graphics.getHeight() / 4)

    -- Velocidad del personaje
    self.speed = 1400
    self.topSpeed = 1024
    self.isInWater = true

    -- Textura
    self.sprite = love.graphics.newImage('assets/entities/player/player.png')

    -- Collider del jugador
    self.collider = world:newRectangleCollider(self.x, self.y, self.size, self.size)
    self.collider:setRestitution(0.2)
    self.collider:setCollisionClass(Layers.PLAYER)
    self.collider:setObject(self)

    return self
end

function Player:update(world, game)
    if self.collider:exit(Layers.WATER) then
        self.isInWater = false
        world:setGravity(0, 1024)
    end

    self.x = self.collider:getX()
    self.y = self.collider:getY()

    if self.collider:enter(Layers.WATER) then
        self.isInWater = true
        world:setGravity(0, 32)
        self.collider:applyLinearImpulse(0, -100)
    end

    if self.collider:enter(Layers.BIRD) then
        local collision_data = self.collider:getEnterCollisionData(Layers.BIRD)
        local bird = collision_data.collider:getObject()
        game.updateScore()
        bird:reset()

        if game.level == 3 and self.size < 50 then
            self.size = self.size + 2
        end
    end

    if self.collider:enter(Layers.PLANE) and game.level < 3 then
        game.finish()
    end
end

-- Dibujar jugador
function Player:draw()
    love.graphics.draw(
        self.sprite, 
        self.x, 
        self.y, 
        0, 
        1.2 * (self.size / 20), 
        1.2 * (self.size / 20), 
        self.sprite:getWidth() / 2,
        self.sprite:getHeight() / 2
    )
end

return Player