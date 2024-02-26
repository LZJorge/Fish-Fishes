local timer = require 'libs.hump.timer'

local world = require 'src.world'

local Player = require 'src.entities.player'
local Bird = require 'src.entities.bird'
local Plane = require 'src.entities.plane'
local Crab = require 'src.entities.crab'

local states = require 'src.states'

local centerX = require 'src.utils.centerText'

local player = {}
local birds = {}
local planes = {}
local crabs = {}

local game = {}

game.level = 1
game.round = 0

game.highScore = {}
game.highScore[1] = 0
game.highScore[2] = 0
game.highScore[3] = 0

game.birdPoints = 5

game.birdsNumber = 4
game.planesNumber = 2
game.crabsNumber = 0

-- Iniciar características de la partida
function game.init()
    local entities = { player, birds, planes }
    game.score = 0

    -- Inicia el mundo de la libreria 'Windfield'
    if game.round == 1 then
        world.init()
    end

    --
    game.updateLevelParams()
    
    -- Inicia nueva instancia del jugador
    player[1] = Player:new(world)

    -- Inicia una cantidad x de aves
    for i = 1, game.birdsNumber do
        birds[i] = Bird:new(world)
    end

    -- Inicia una cantidad x de aviones
    for i = 1, game.planesNumber do
        planes[i] = Plane:new(world)
    end

    -- Inicia una cantidad x de cangrejos
    for i = 1, game.crabsNumber do
        crabs[i] = Crab:new(world)
    end

    entities = { player, birds, planes, crabs }

    game.play()

    return entities
end

function game.updateLevelParams()
    if game.level == 1 then
        game.birdsNumber = 5
        game.birdPoints = 5
        game.planesNumber = 2
        game.crabsNumber = 0
    elseif game.level == 2 then
        game.birdsNumber = 7
        game.birdPoints = 10
        game.planesNumber = 4
        game.crabsNumber = 2
    elseif game.level == 3 then
        game.birdsNumber = 8
        game.birdPoints = 15
        game.planesNumber = 4
        game.crabsNumber = 3
    end
end

-- Función para eliminar las entidades
function game.eraseEntities()
    player[1].collider:destroy()

    for i = 1, game.birdsNumber do
        birds[i].collider:destroy()
    end

    for i = 1, game.planesNumber do
        planes[i].collider:destroy()
    end

    for i = 1, game.crabsNumber do
        crabs[i].collider:destroy()
    end
end

-- Reiniciar juego
function game.restart()
    game.loading()
    game.updateRound()

    timer.after(3.1, function ()
        game.eraseEntities(world.entities)

        game.init(world)
    end)
end

-- Actualizar puntuación
function game.updateScore()
    game.score = game.score + game.birdPoints
end

----------------------------------------
-- Dibujar
----------------------------------------
function game.drawScore()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print('Puntuación: ' ..game.score, 30, 30)
    love.graphics.print('Nivel: ' ..game.level, 30, 50)
end

-- Dibujar pausa
function game.drawPause(font)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print('Juego pausado', centerX('Juego pausado', font), love.graphics.getHeight() / 2 - 50)
end

-- Dibujar línea de separación entre agua y aire
function game.drawLine()
    -- ligth blue transparent
    love.graphics.setColor(100, 100, 155)
    
    -- Toda la mitad inferior de la pantalla debe ser agua
    love.graphics.line(0, love.graphics.getHeight() / 2 + 50, love.graphics.getWidth(), love.graphics.getHeight() / 2 + 50)

    love.graphics.setColor(255, 255, 255)
end

--
function game.drawLoading(font)
    love.graphics.newFont(20)
    love.graphics.print('Cargando...', centerX('Cargando...', font), 80)
    love.graphics.newFont(14)
end

-- Dibujar pausa
function game.drawGameOver(font)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print('Perdiste! =(', centerX('Perdiste! =(', font), love.graphics.getHeight() - 150 - 65)
    love.graphics.print('Puntuación más alta: ' ..game.highScore[game.level], centerX('Puntuación más alta: ' ..game.highScore[game.level], font), love.graphics.getHeight() -150 - 25)
    love.graphics.print('Tu puntuación: ' ..game.score, centerX('Tu puntuación: ' ..game.score, font), love.graphics.getHeight() - 150 - 5)
    love.graphics.print('Presiona la tecla R para reiniciar', centerX('Presiona la tecla R para reiniciar', font), love.graphics.getHeight() - 150 + 35)
    love.graphics.print('Presiona la tecla ESC para salir', centerX('Presiona la tecla ESC para salir', font), love.graphics.getHeight() - 150 + 55)
end

----------------------------------------
-- Funciones de estado
----------------------------------------
-- Pausar juego
function game.pause()
    game.state = states.PAUSED
end

-- Iniciar juego
function game.play()
    game.state = states.PLAYING
end

-- Terminar juego
function game.finish()
    if game.highScore[game.level] < game.score then
        game.highScore[game.level] = game.score
    end

    game.state = states.GAMEOVER
end

-- Aumentar ronda
function game.updateRound()
    game.round = game.round + 1
end

-- Poner juego en estado de carga (necesario para evitar bug de colliders al reiniciar)
function game.loading()
    game.state = states.LOADING
end

-- Funciones de menus
function game.isOnMenu()
    if game.round > 1
        and game.state ~= states.LOADING
        and game.state ~= states.MENU.LEVEL_SELECT
        and game.state ~= states.MENU.KEYBOARD
    then
        game.eraseEntities()
    end
    game.state = states.MENU.MAIN
end

function game.isOnKeyboardMenu()
    game.state = states.MENU.KEYBOARD
end

function game.isOnLevelsMenu()
    game.state = states.MENU.LEVEL_SELECT
end

-- Dificultades del juego
function game.level_1()
    game.level = 1
    game.updateRound()
end

function game.level_2()
    game.level = 2
    game.updateRound()
end

function game.level_3()
    game.level = 3
    game.updateRound()
end

return game