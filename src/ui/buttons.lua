local button = {}

function button.add(text, fn)
    return {
        text = text,
        fn = fn,

        now = false,
        last = false
    }
end

function button.draw(title, font, buttons)
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    button.width = ww * (1/3)
    button.height = wh * (1/8)

    local margin = 16
    local total_height = (button.height + margin) * #buttons
    local cursor_y = 0

    -- 
    love.graphics.print(
        title,
        (ww / 2) - (font:getWidth(title) / 2),
        60
    )
    
    for i, btn in ipairs(buttons) do
        btn.last = btn.now

        local bx = (ww / 2) - (button.width / 2)
        local by = (wh / 2 )- (button.height / 2) - (total_height / 2) + cursor_y

        -- color gris
        local color = { 0.4, 0.4, 0.4, 1.0 }

        -- Posicion del cursor
        local mx, my = love.mouse.getPosition()

        -- Verificar si el cursor se encuentra dentro del boton
        local hot = 
            mx > bx and
            mx < bx + button.width and
            my > by and
            my < by + button.height

        if hot then
            color = { 0.7, 0.7, 0.7, 1.0 }
        end

        -- Boton presionado
        btn.now = love.mouse.isDown(1)
        if hot and btn.now and not btn.last then
            btn.fn()
        end

        -- Colocando el color del boton
        love.graphics.setColor(color[1], color[2], color[3], color[4])
        love.graphics.rectangle(
            'fill', 
            bx, 
            by, 
            button.width, 
            button.height
        )

        -- Colocando el texto
        local textW = font:getWidth(btn.text)
        local textH = font:getHeight(btn.text)

        love.graphics.setColor(33, 33, 33)
        love.graphics.print(
            btn.text, 
            bx + (button.width - textW) / 2, 
            by + (button.height - textH) / 2
        )

        cursor_y = cursor_y + button.height + margin
        love.graphics.setColor(255, 255, 255)
    end
end

return button