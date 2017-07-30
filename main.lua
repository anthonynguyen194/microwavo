-- main.lua handles loading, updating, drawing, and the physics portion of the game components.

-- Include game.lua functions and variables globally.
local game_module = require "game"


function love.load()
  initialize()
  -- Set background color and window size.
  love.window.setMode(420, 600)
  love.graphics.setBackgroundColor(0, 139, 139)
  spawnMicrowave(50, 50)
  spawnFood()
  test = #COMPONENTS.microwaves
end

function love.update(dt)
end

function love.draw()
  -- Draw all the microwaves.
  for _, m in ipairs(COMPONENTS.microwaves) do
    love.graphics.setColor(119, 136, 153)
    love.graphics.rectangle("line", m.x, m.y, m.w, m.h)
  end

  -- Draw the food in the microwave.
  for _, m in ipairs(COMPONENTS.microwaves) do
    love.graphics.setColor(220, 20, 60)
    love.graphics.circle("fill", m.food.x, m.food.y, 5)
  end

  -- Print the score to the screen
  COMPONENTS.score:draw();
end

function love.mousepressed(x, y, button, istouch)
end
