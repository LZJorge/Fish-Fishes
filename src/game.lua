local timer = require 'libs.hump.timer'
local game = {}

game.round = 0
game.highScore = 0

-- Iniciar características de la partida
function game.init()
    game.score = 0
    game.state = {
        playing = true,
        paused = false,
        ended = false,
        loading = false
    }
end

-- Reiniciar juego
function game.restart(entities)
    game.loading()

    timer.after(3, function ()
        for i = 1, #entities do
            for j = 1, #entities[i] do
               entities[i][j].collider:destroy() 
            end
        end
    
        game.round = game.round + 1
        game.score = 0
    
        game.play()
        love.load()
    end)
end

-- Actualizar puntuación
function game.updateScore()
    game.score = game.score + 10
end

-- Dibujar puntuación
function game.drawScore()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print('Puntuación: ' ..game.score, 30, 30)
end

-- Dibujar pausa
function game.drawPause()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print('Juego pausado', love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2 - 50)
end

-- Dibujar línea de separación entre agua y aire
function game.drawLine()
    -- ligth blue transparent
    love.graphics.setColor(100, 100, 155)
    
    -- Toda la mitad inferior de la pantalla debe ser agua
    love.graphics.line(0, love.graphics.getHeight() / 2 + 50, love.graphics.getWidth(), love.graphics.getHeight() / 2 + 50)

    love.graphics.setColor(255, 255, 255)
end

-- Dibujar pausa
function game.drawGameOver()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print('Perdiste! =(', love.graphics.getWidth() / 2 - 40, love.graphics.getHeight() - 150 - 65)
    love.graphics.print('Puntuación más alta: ' ..game.highScore, love.graphics.getWidth() / 2 - 80, love.graphics.getHeight() -150 - 25)
    love.graphics.print('Tu puntuación: ' ..game.score, love.graphics.getWidth() / 2 - 60, love.graphics.getHeight() - 150 - 5)
    love.graphics.print('Presiona la tecla R para reiniciar', love.graphics.getWidth() / 2 - 115, love.graphics.getHeight() - 150 + 35)
end

-- Pausar juego
function game.pause()
    game.state = {
        playing = false,
        paused = true,
        ended = false,
        loading = false
    }
end

-- Iniciar juego
function game.play()
    game.state = {
        playing = true,
        paused = false,
        ended = false,
        loading = false
    }
end

-- Terminar juego
function game.finish()
    if game.highScore < game.score then
        game.highScore = game.score
    end

    game.state = {
        playing = false,
        paused = false,
        ended = true,
        loading = false
    }
end

-- Poner juego en estado de carga (necesario para evitar bug de colliders al reiniciar)
function game.loading()
    game.state = {
        playing = false,
        paused = false,
        ended = false,
        loading = true
    }
end

return game