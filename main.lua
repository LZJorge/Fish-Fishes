local timer = require 'libs.hump.timer'

local game = require 'src.game'
local keyboard = require 'src.keyboard'
local world = require 'src.world'

local Player = require 'src.entities.player'
local Bird = require 'src.entities.bird'
local Plane = require 'src.entities.plane'

local player = {}
local birds = {}
local planes = {}

local entities = { player, birds, planes }

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Inicia características del juego
    game.init()

    -- Inicia el mundo de la libreria 'Windfield'
    if game.round == 0 then
        world.init()
    end
    
    -- Inicia nuevca instancia del jugador
    player[1] = Player:new(world)

    -- Inicia una cantidad x de aves
    local birdsNumber = 5
    for i = 1, birdsNumber do
        birds[i] = Bird:new(world)
    end

    -- Inicia una cantidad x de aviones
    local planesNumber = 2
    for i = 1, planesNumber do
        planes[i] = Plane:new(world)
    end
end

function love.update(dt)
    -- Actualizar reloj de la librería Hump
    timer.update(dt)

    -- Acciones que pueden ocurrir mientras el juego está en pausa
    -- Controles de ayuda
    keyboard.helpers(game.state)

    -- Acciones que pueden ocurrir mientras el juego no está transcurriendo
    if game.state.playing then
        -- Actualizar mundo de windfield
        world:update(dt)

        -- Calcular colisiones del jugador con las diferentes entidades
        player[1]:update(world)

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
    if game.state.ended then
        keyboard.restart(entities)
    end
end

function love.draw()
    -- Dibujar colliders de las entidades
    --world:draw()
    game.drawLine()

    -- Dibujar fuente
    love.graphics.setNewFont('assets/font/font.ttf', 14)

    -- Dibujar entidades
    for i = 1, #entities do
        for j = 1, #entities[i] do
            entities[i][j]:draw()
        end
    end

    -- Dibujar puntuación
    game.drawScore()

    -- Dibujar Pausa si el juego se encuentra pausado
    if game.state.paused then
        game.drawPause()
    end

    -- Dibujar Perdiste si haz chocado contra un enemigo
    if game.state.ended then
        game.drawGameOver()
    end
end