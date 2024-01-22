local game = {}

-- Iniciar características de la partida
function game.init()
    game.score = 0
    game.state = {
        playing = true,
        paused = false,
        ended = false
    }
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

-- Pausar juego
function game.pause()
    game.state = {
        playing = false,
        paused = true,
        ended = false
    }
end

-- Iniciar juego
function game.play()
    game.state = {
        playing = true,
        paused = false,
        ended = false
    }
end

-- Terminar juego
function game.finish()
    game.state = {
        playing = false,
        paused = false,
        ended = true
    }
end

return game