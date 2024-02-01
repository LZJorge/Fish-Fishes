local game = require 'src.game'
local keyboard = require 'src.keyboard'
local Player = require 'src.entities.player'
local Bird = require 'src.entities.bird'
local world = require 'src.world'
local timer = require 'libs.hump.timer'

local player = {}
local birds = {}

function love.load()
    -- Inicia el mundo de la libreria 'Windfield'
    world.init()

    -- Inicia características del juego
    game.init()
    
    -- Inicia nuevca instancia del jugador
    player = Player:new(world)

    -- Inicia una cantidad x de aves
    local birdsNumber = 4
    for i = 1, birdsNumber do
        birds[i] = Bird:new(world)
    end
end

function love.update(dt)
    world:update(dt)
    timer.update(dt)

    player:update(world)

    for i = 1, #birds do
        birds[i]:move()
    end

    -- Controles del jugador
    keyboard.movement(player)
end

function love.draw()
    -- Dibujar colliders de las entidades
    world:draw()

    game.drawScore()
end