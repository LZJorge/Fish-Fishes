local wf = require 'libs.windfield'
require 'src.layers'

local world = wf.newWorld(0, 512)

function world.init()
    world:addCollisionClass(Layers.AIR)
    world:addCollisionClass(Layers.WATER, { ignores = { Layers.WATER } })
    world:addCollisionClass('Top')
    world:addCollisionClass('Wall')
    world:addCollisionClass(Layers.PLAYER, { ignores = { Layers.WATER, Layers.AIR, 'Top' } })
    world:addCollisionClass(Layers.BIRD, { ignores = { Layers.AIR, Layers.BIRD, Layers.PLAYER } })
    world:addCollisionClass(Layers.ENEMY, { ignores = { Layers.AIR } })

    --
    Air = world:newRectangleCollider(-100, -2000, love.graphics.getWidth() + 100, love.graphics.getHeight() / 2 + 2000 + 50 - 1)
    Air:setType('static')
    Air:setCollisionClass(Layers.AIR)
    
    --
    Water = world:newRectangleCollider(-100, love.graphics.getHeight() / 2 + 50 + 1, love.graphics.getWidth() + 100, love.graphics.getHeight() / 2 + 20)
    Water:setType('static')
    Water:setCollisionClass(Layers.WATER)

    --
    Top = world:newLineCollider(0, 0, love.graphics.getWidth(), 0)
    Top:setCollisionClass('Top')
    Top:setType('static')
    Ground = world:newLineCollider(0, love.graphics.getHeight(), love.graphics.getWidth(), love.graphics.getHeight())
    LeftWall = world:newLineCollider(0, -2000, 0, love.graphics.getHeight())
    RightWall = world:newLineCollider(love.graphics.getWidth(), -2000, love.graphics.getWidth(), love.graphics.getHeight())

    local solids = { Ground, LeftWall, RightWall }

    for i = 1, #solids do
        solids[i]:setType('static')
        solids[i]:setCollisionClass('Wall')
    end
end

return world