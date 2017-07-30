-- main.lua handles loading, updating, drawing, and the physics portion of the game components.

-- Include game.lua functions and variables globally.
local game_module = require "game"

function love.load()
  initialize()
  -- Set background color.
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

  --[[
    Draw calls below this line will be replaced by 
      for each COMPONENT, call draw()
    once the microwave draw function is moved into the microwaves.
    ]]--
  -- Print the score to the screen
  COMPONENTS.score:draw()
  -- Show title screen
  showTitleScreen()
end

function love.mousepressed(x, y, button, istouch)
  for _,c in pairs(COMPONENTS) do
    if c.is_clickable then
      if ptIsInRectangle(x, y, c.x, c.y, c.w, c.h) then
        c:clicked()
      end
    end
  end
end

--[[
  Check if a point (x,y) is inside a rectangle (rx, ry, rw, rh).
  ]]--
function ptIsInRectangle(x, y, rx, ry, rw, rh)
  return x > rx and
         x < rx + rw and
         y > ry and
         y < ry + rh
end
