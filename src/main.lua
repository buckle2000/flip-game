local Game = require("game")
local F = require 'fun'
local game
local over = false

function reset()
    over = false
    print('=> Reset')
    game = Game.new()
end

local FONT_SIZE = 16
local X_PAD = 20
local X_SCALE = 200 -- how many pixels correspond to "1" unit?

function love.load()
    love.window.setMode(X_PAD * 2 + X_SCALE * 2, 50 + FONT_SIZE * 12)
    love.graphics.setFont(love.graphics.newFont(FONT_SIZE))
    print('==> Game start')
    reset()
    love.window.setTitle(Game.title)
end

local dt_acc = 0
local STEP_SIZE = 0.02


-- fixed update
function love.update(dt)
    if not over then
        over = game:isover()
        dt_acc = dt_acc + dt
        while dt_acc > STEP_SIZE do
            dt_acc = dt_acc - STEP_SIZE
            game:step(STEP_SIZE)
        end
    end
end

function getpos(x)
    return X_PAD + X_SCALE * x
end

function love.draw()
    love.graphics.line(getpos(Game.END_POS), 0, getpos(Game.END_POS), 10)
    love.graphics.line(getpos(Game.FLIP_POS), 0, getpos(Game.FLIP_POS), 10)
    love.graphics.line(getpos(Game.SPAWN_POS), 0, getpos(Game.SPAWN_POS), 10)

    for i,x in ipairs(game.agents) do
        if x.right then
            love.graphics.circle('fill', getpos(x.pos), 28, 2)
        else
            love.graphics.circle('fill', getpos(x.pos), 20, 2)
        end
    end
    if over then
        love.graphics.print('Game over, press R to restart', X_PAD, 50)
    else
        love.graphics.print('Game running', X_PAD, 50)
    end
    love.graphics.printf(
[[
Dots will spawn on the right bar.
If any dot reaches the left bar, you lose.
FLIP to reverse velocity of all dots
    between the left bar and the middle bar.

Press spacebar to FLIP
Press Q to quit
]]
    , X_PAD, 50 + FONT_SIZE * 2, X_SCALE * 2 )
end

function love.keypressed(k)
    -- press q to quit
    if k == 'q' then
        love.event.quit()
    end
    if k == 'r' then
        reset()
    end
    if k == 'space' then
        game:flip()
    end
end