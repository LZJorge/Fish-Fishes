local button = require 'src.ui.buttons'
local game = require 'src.game'
local timer = require 'libs.hump.timer'
local world = require 'src.world'

local buttons = {}
local levelsMenu = {}

local function start()
    game.loading()

    if game.round > 1 then
        timer.after(3.1, function ()
            love.load()
        end)
    else
        love.load()
    end
end

function levelsMenu.setButtons()
    table.insert(buttons, button.add('Nivel 1', 
        function () 
            game.level_1()
            start()
        end))
    
    table.insert(buttons, button.add('Nivel 2', 
        function () 
            game.level_2()
            start()
        end))

    table.insert(buttons, button.add('Nivel 3', 
        function () 
            game.level_3()
            start()
        end))
end

function levelsMenu.init()
    levelsMenu.setButtons()
end

function levelsMenu.draw(font)
    button.draw('Selecciona un nivel', font, buttons)
end

return levelsMenu