local function centerX(text, font)
    return (love.graphics.getWidth() / 2) - (font:getWidth(text) / 2)
end

return centerX