local timer = require 'libs.hump.timer'

local states = require 'src.states'

local menu = require 'src.menu'
local game = require 'src.game'
local keyboard = require 'src.keyboard'
local world = require 'src.world'

local player = {}
local birds = {}
local planes = {}

world.entities = { player, birds, planes }

-- Inicia el menu
menu.init()

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    if game.state ~= states.MENU.MAIN then
        -- Inicia características del juego
        world.entities = game.init()

        player = world.entities[1]
        birds = world.entities[2]
        planes = world.entities[3]
    end
end

function love.update(dt)
    -- Actualizar reloj de la librería Hump
    timer.update(dt)

    if game.state ~= states.MENU.MAIN then  
        -- Acciones que pueden ocurrir mientras el juego está en pausa
        -- Controles de ayuda
        keyboard.helpers(game.state)

        -- Acciones que pueden ocurrir mientras el juego no está transcurriendo
        if game.state == states.PLAYING then
            -- Actualizar mundo de windfield
            world:update(dt)

            -- Calcular colisiones del jugador con las diferentes entidades
            player[1]:update(world, game)

            -- Mover aves
            for i = 1, #birds do
                birds[i]:move()
            end

            -- Mover aviones
            for i = 1, #planes do
                planes[i]:move(dt)
            end

            -- Controles del jugador
            keyboard.movement(player[1])
        end

        -- Acciones que pueden ocurrir mientras el juego está terminado
        if game.state == states.GAMEOVER then
            keyboard.restart(game.state, world.entities)
        end

        -- Volver del menu de controles
        if game.state == states.MENU.KEYBOARD then
            keyboard.onKeyboardMenu()
        end
    end
end

function love.draw()
    -- Dibujar fuente
    local font = love.graphics.setNewFont('assets/font/font.ttf', 14)

    -- Iniciar el menu
    if game.state == states.MENU.MAIN then
        menu.draw(font)
    end
    
    if game.state ~= states.MENU.MAIN then
        -- Dibujar entidades
        if game.state ~= states.LOADING 
            and game.state ~= states.MENU.MAIN 
            and game.state ~= states.MENU.KEYBOARD 
        then
            for i = 1, #world.entities do
                for j = 1, #world.entities[i] do
                    world.entities[i][j]:draw()
                end
            end
        end

        -- Dibujar puntuación
        if game.state == states.PLAYING or game.state == states.GAMEOVER or game.state == states.PAUSED then
            game.drawLine()
            game.drawScore()
        end

        -- Dibujar Pausa si el juego se encuentra pausado
        if game.state == states.PAUSED then
            game.drawPause()
        end

        -- Dibujar Perdiste si haz chocado contra un enemigo
        if game.state == states.GAMEOVER then
            game.drawGameOver()
        end

        if game.state == states.MENU.KEYBOARD then
            keyboard.draw(font)
        end
    end
end