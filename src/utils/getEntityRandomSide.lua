local function getRandomSide(entitySize)
    local x
    local side = math.random(0, 1)
    if side == 0 then
        x = entitySize
    else
        x = love.graphics.getWidth() - entitySize
    end

    return x
end

return getRandomSide