-- main.lua handles loading, updating, drawing, and the physics portion of the game components.

function love.load()
    Game.init()
    Game.showScreen()

function love.update(dt)

function love.draw()
    Game.Components.draw

function love.mousepressed(x, y, button, istouch)
