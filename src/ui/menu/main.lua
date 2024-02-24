local timer = require 'libs.hump.timer'
local game = require 'src.game'
local button = require 'src.ui.buttons'

-- Botones del menu principal
local buttons = {}

-- Menu
local mainMenu = {}

function mainMenu.setButtons()
    table.insert(buttons, button.add('Jugar',
        function()
            game.loading()

            timer.after(0.5, function() 
                game.isOnLevelsMenu()
            end)
        end))
    
    table.insert(buttons, button.add('Controles', 
        function()
            game.isOnKeyboardMenu()
        end
    ))

    table.insert(buttons, button.add('Salir',
        function()
            love.event.quit(0)
        end))
end

function mainMenu.init()
    mainMenu.setButtons()
    game.isOnMenu()
end

function mainMenu.draw(font)
    button.draw('Fish Fishes', font, buttons)
end

return mainMenu