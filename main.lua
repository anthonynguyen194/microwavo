-- main.lua handles loading, updating, drawing, and the physics portion of the game Components.

-- Include game.lua functions and variables globally.
local game_module = require "game"

function love.load()
  -- Initialize application
  -- Set the seed for the random function.
  math.randomseed(os.time())
  -- Set background color.
  love.graphics.setBackgroundColor(0, 139, 139)

  -- Initialize the game
  initialize()
end

function love.update(dt)
end

function love.draw()
  for _,c in pairs(Components) do
    if c.is_drawn then
      c:draw()
    end
  end
end

function love.mousepressed(x, y, button, istouch)
  for _,c in pairs(Components) do
    if c.is_clickable then
      if wasComponentClicked(c, x, y) then
        c:clicked()
      end
    end
  end
end

--[[
  Check if a component was clicked
  ]]--
function wasComponentClicked(c, x, y)
  if c.list then -- if list of component
    for index,item in ipairs(c.list) do
      if isPtInRectangle(x, y, item.x, item.y, item.w, item.h) then
        table.insert(c.clickedIndices, index)
        return true
      end
    end
    return false
  else
    return isPtInRectangle(x, y, c.x, c.y, c.w, c.h)
  end
end

--[[
  Check if a point (x,y) is inside a rectangle (rx, ry, rw, rh).
  ]]--
function isPtInRectangle(x, y, rx, ry, rw, rh)
  return x > rx and
         x < rx + rw and
         y > ry and
         y < ry + rh
end
