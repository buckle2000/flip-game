local F = require 'fun'

local Game = {}

Game.title = 'FLIP'

function Game.new()
    local t = {
        agents = {}
    }
    setmetatable(t, {
        __index=Game
    })
    return t
end

local SPAWN_RATE = 2 -- average number of agent spawned per second
local AGENT_SPEED = 0.3 -- agent speed
local END_POS = 0
local FLIP_POS = 1
local SPAWN_POS = 2

Game.END_POS = END_POS
Game.FLIP_POS = FLIP_POS
Game.SPAWN_POS = SPAWN_POS

--[[
    Game board: END_POS === FLIP_POS === SPAWN_POS
    If any agent touch END_POS, you lose
]]

function Game:step(dt)
    -- move agents
    for i,x in ipairs(self.agents) do
        if x.right then
            x.pos = x.pos + AGENT_SPEED * dt
        else
            x.pos = x.pos - AGENT_SPEED * dt
        end
    end

    -- remove any agent right of SPAWN_POS
    self.agents = F.filter(function(x) return x.pos <= SPAWN_POS end, self.agents):totable()
    
    -- Agents spawn at SPAWN_POS randomly, moving left
    if love.math.random() < SPAWN_RATE * dt then
        table.insert(self.agents, {
            right = false,
            pos = SPAWN_POS
        })
    end
end

-- Call flip() to reverse direction of all agents in range [0, 1)
-- i.e. left -> right, right -> left
function Game:flip()
    F.each(function(x) x.right = not x.right end,
        F.filter(function(x) return x.pos < FLIP_POS end, self.agents))
end

function Game:isover()
    return F.any(function(x) return x.pos < END_POS end, self.agents)
end

return Game