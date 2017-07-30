-- main.lua handles loading, updating, drawing, and the physics portion of the game components.

-- Include game.lua functions and variables globally.
local game_module = require "game"

function love.load()
  initialize()
  -- Set background color.
  love.graphics.setBackgroundColor(0, 139, 139)

  -- Spawn the microwave and setup the physical world.
  spawnMicrowave(50, 50)
  spawnFood()
  createPhysicalWorld()

end

function love.update(dt)
  -- Startup the physical world.
  pool_world:update(dt)

  -- Movement debugging.
  --here we are going to create some keyboard events
  if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
    pool_objects[1].body:applyForce(400, 0)
  elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
    pool_objects[1].body:applyForce(-400, 0)
  elseif love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
    pool_objects[1].body:applyForce(0, -400)
  elseif love.keyboard.isDown("down") then
    pool_objects[1].body:applyForce(0, 400)
  end
end

function love.draw()
   -- Draw the microwave. NOTE: Just here for testing the physics.
  love.graphics.setColor(50, 50, 50)
  love.graphics.polygon("fill", pool_objects[1].body:getWorldPoints(pool_objects[1].shape:getPoints()))


  -- Print the score to the screen
  COMPONENTS.score:draw()

  -- Show title screen
  --showTitleScreen()
end

function love.mousepressed(x, y, button, istouch)
end



-------------------------------------
-- Setup the physics in the pool game setting.
-------------------------------------
function createPhysicalWorld()
  -- Stores all the physical pool objects.
  pool_objects = {}
  -- Stores the boundaries for the container
  container = {}
  -- Setup the pool world and set the vertical and horizontal gravity to zero.
  pool_world = love.physics.newWorld(0, 0, true)
  -- Create the container that the pool_objects will be in.
  createContainer()
  -- Create the physical microwave and store it.
  -- NOTE: This should loop through the microwaves that should been seen on screen.
  table.insert(pool_objects, createPhysicalMicrowave(COMPONENTS.microwaves[1]))
end

-------------------------------------
-- Creates an invisible rectangular boundary relative to the game's resolution.
-------------------------------------
function createContainer()
  container.ceiling = {}
  container.l_wall = {}
  container.r_wall = {}
  container.ground = {}

  -- Create the boundaries for the container.
  container.ceiling.body = love.physics.newBody(pool_world, love.graphics.getWidth() / 2, 0)
  container.ceiling.shape = love.physics.newRectangleShape(love.graphics.getWidth(), 0)
  container.ceiling.fixture = love.physics.newFixture(container.ceiling.body, container.ceiling.shape)

  container.l_wall.body = love.physics.newBody(pool_world, 0, love.graphics.getHeight() / 2)
  container.l_wall.shape = love.physics.newRectangleShape(0, love.graphics.getHeight())
  container.l_wall.fixture = love.physics.newFixture(container.l_wall.body, container.l_wall.shape)

  container.r_wall.body = love.physics.newBody(pool_world, love.graphics.getWidth(), love.graphics.getHeight() / 2)
  container.r_wall.shape = love.physics.newRectangleShape(0, love.graphics.getHeight())
  container.r_wall.fixture = love.physics.newFixture(container.r_wall.body, container.r_wall.shape)

  container.ground.body = love.physics.newBody(pool_world, love.graphics.getWidth() / 2, love.graphics.getHeight())
  container.ground.shape = love.physics.newRectangleShape(love.graphics.getWidth(), 0)
  container.ground.fixture = love.physics.newFixture(container.ground.body, container.ground.shape)

end

-------------------------------------
-- Create a physical microwave and return it.
-- @param microwave The microwave to base the physical object on.
-- @return Return a physical microwave.
-------------------------------------
function createPhysicalMicrowave(microwave)
  new_microwave = {}
  -- Create the physical body and anchor it to the position of the logical microwave.
  new_microwave.body = love.physics.newBody(pool_world, microwave.x, microwave.y, "dynamic")
  -- Establish the visual shape of the microwave i.e. a polygon.
  new_microwave.shape = love.physics.newRectangleShape(microwave.w, microwave.h)
  -- Fix the visual body to the physical body.
  new_microwave.fixture = love.physics.newFixture(new_microwave.body, new_microwave.shape, 1)
  -- Create make hte microwaves bouncy.
  new_microwave.fixture:setRestitution(0.75)

  return new_microwave
end
