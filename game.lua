--[[game.lua
    - Handles all game logic and visual represnetations to the users.
    - Each component can draw itself.
    - The order in which the component appears in the Components table is important.
]]--

-- Global constants --

-- Store functions in this table.

-- Missing the microwave and food Components.
MICROWAVE_MAX = 5

-- Dimension of the microwaves
MICROWAVE_SIZE = {WIDTH = 50, HEIGHT = 40}

-- Cooldown time for a microwave to be ready to hold a food again.
MICROWAVE_COOLDOWN = 1

-- Initial Food radius
INITIAL_FOOD_RADIUS = 5

-- Food radius growth rate per second
FOOD_RADIUS_DT = 2

-- Boolean used to pause the game
PAUSED_GAME = true

-- Different physical Components of the game.
Components = {
  swimming_pool        = {x = 0, y = 0, w = 0, h = 0, img = nil, is_drawn = false},
  title_label          = {x = 52, y = 200, is_drawn = false,
                          img = love.graphics.newImage("assets/title.png"),
                          draw = function (self)
                            love.graphics.setColor(255, 255, 255)
                            love.graphics.draw(self.img, self.x, self.y)
                          end},
  start_button         = {x = 52, y = 350, w = 105, h = 50, is_drawn = false, is_clickable = false,
                          img = love.graphics.newImage("assets/start-button.png"),
                          draw = function (self)
                            love.graphics.setColor(255, 255, 255)
                            love.graphics.draw(self.img, self.x, self.y)
                          end,
                          clicked = function (self)
                            removeTitleScreen()
                            startGame()
                          end},
  quit_button          = {x = 263, y = 350, w = 105, h = 50, is_drawn = false, is_clickable = false,
                          img = love.graphics.newImage("assets/quit-button.png"),
                          draw = function (self)
                            love.graphics.setColor(255, 255, 255)
                            love.graphics.draw(self.img, self.x, self.y)
                          end,
                          clicked = function (self)
                            quit()
                          end},
  microwaves           = {list = {}, is_drawn = false, is_clickable = false, clickedIndices = {},
                          draw = function (self)
                            for _, m in pairs(self.list) do
                              -- Draw the microwave. NOTE: Just here for testing the physics.
                              love.graphics.setColor(50, 50, 50)
                              love.graphics.polygon("fill", m.object.body:getWorldPoints(m.object.shape:getPoints()))
                              -- if there is food inside the microwave
                              if m.food then
                                -- draw food
                                love.graphics.setColor(m.food.color)
                                love.graphics.circle("fill", m.food.x, m.food.y, m.food.radius)
                              end
                            end
                          end,
                          clicked = function (self)
                            for i = #self.clickedIndices, 1, -1 do
                              local microwave = self.list[i]
                              -- if there was a food and it was ready
                              if microwave.food
                                 and microwave.food.cooking_time < 0 then
                                Components.score.score = Components.score.score + microwave.food.score
                                microwave.food = nil
                                microwave.cooldown = MICROWAVE_COOLDOWN
                              else
                                -- Tried to remove the food too early, destory the microwave
                                table.remove(Components.microwaves.list, i)
                              end
                            end
                            -- Clear the clickedIndices list once all the clicks have been handled
                            for k,v in pairs (self.clickedIndices) do
                              self.clickedIndices[k] = nil
                            end
                          end,
                          update = function (self, dt)
                            for _,m in pairs(self.list) do
                              -- Update position of the microwave.
                              m.x = m.object.body:getX()
                              m.y = m.object.body:getY()
                              -- If the microwave has a food
                              if m.food then
                                -- Update the food inside the microwave
                                if m.food then
                                  m.food.x = m.x
                                  m.food.y = m.y
                                end

                                -- Update food timers
                                if m.food.cooking_time > 0 then
                                  m.food.cooking_time = m.food.cooking_time - dt
                                  m.food.radius = m.food.radius + FOOD_RADIUS_DT * dt
                                else
                                  m.food.decay_time = m.food.decay_time - dt
                                  m.food.radius = m.food.radius - (m.food.radius / m.food.decay_time) * dt
                                end
                              else
                                m.cooldown = m.cooldown - dt
                              end
                            end
                          end },
  score                = {x = 5, y = 5, score = 0, is_drawn = false,
                          draw = function (self)
                            love.graphics.setColor(255, 255, 255)
                            love.graphics.print("Score = " .. self.score, self.x, self.y, 0, 1.25)
                          end},
  result_label        = {x = 52, y = 200, score = 0, is_drawn = false,
                          img = love.graphics.newImage("assets/result.png"),
                          draw = function (self)
                            love.graphics.setColor(255, 255, 255)
                            love.graphics.draw(self.img, self.x, self.y)
                            love.graphics.setColor(0, 0, 0)
                            love.graphics.print(self.score, self.x + 150, self.y + 50, 0, 4)
                          end},
  retry_button         = {x = 52, y = 350, w = 105, h = 50, is_drawn = false, is_clickable = false,
                          img = love.graphics.newImage("assets/retry-button.png"),
                          draw = function (self)
                            love.graphics.setColor(255, 255, 255)
                            love.graphics.draw(self.img, self.x, self.y)
                          end,
                          clicked = function (self)
                            removeResultScreen()
                            startGame()
                          end},
  title_screen_button  = {x = 263, y = 350, w = 105, h = 50, is_drawn = false, is_clickable = false,
                          img = love.graphics.newImage("assets/title-screen-button.png"),
                          draw = function (self)
                            love.graphics.setColor(255, 255, 255)
                            love.graphics.draw(self.img, self.x, self.y)
                          end,
                          clicked = function (self)
                            removeResultScreen()
                            showTitleScreen()
                          end}}

-- Stores the attribute of each food group.
FOOD_ATTRIBUTES = {
  VEGGY = {LOTTO_NUM = 25, COOKING_TIME_MIN = 2, COOKING_TIME_MAX = 3,
           DECAY_TIME_MIN = 1, DECAY_TIME_MAX = 3, SCORE = 1, COLOR = {76,175,80}},

  GRAIN = {LOTTO_NUM = 50, COOKING_TIME_MIN = .25, COOKING_TIME_MAX = .50,
           DECAY_TIME_MIN = 1, DECAY_TIME_MAX = 1.5, SCORE = 3, COLOR = {141,110,99}},

  FRUIT = {LOTTO_NUM = 66, COOKING_TIME_MIN = 1, COOKING_TIME_MAX = 2,
           DECAY_TIME_MIN = 1, DECAY_TIME_MAX = 1.5, SCORE = 2, COLOR = {249,168,37}},

  MEAT = {LOTTO_NUM = 84, COOKING_TIME_MIN = 1, COOKING_TIME_MAX = 3,
           DECAY_TIME_MIN = 1, DECAY_TIME_MAX = 2, SCORE = 2, COLOR = {229,57,53}},

  DAIRY = {LOTTO_NUM = 100, COOKING_TIME_MIN = .5, COOKING_TIME_MAX = 1,
           DECAY_TIME_MIN = .5, DECAY_TIME_MAX = 1, SCORE = 4, COLOR = {255, 255, 255}}}

-- Transition functions --

-------------------------------------
-- Setup any starting components that are to be used immediately.
-------------------------------------
function initialize()
  showTitleScreen()
  spawnMicrowave(50, 50)
end

-------------------------------------
-- Draw the title screen, start button, and quit button.
-------------------------------------
function showTitleScreen()
  Components.title_label.is_drawn = true

  Components.start_button.is_drawn = true
  Components.start_button.is_clickable = true

  Components.quit_button.is_drawn = true
  Components.quit_button.is_clickable  = true
end

-------------------------------------
-- Remove the title screen.
-------------------------------------
function removeTitleScreen()
  Components.title_label.is_drawn = false

  Components.start_button.is_drawn = false
  Components.start_button.is_clickable= false

  Components.quit_button.is_drawn = false
  Components.quit_button.is_clickable = false
end

-------------------------------------
-- N/A
-------------------------------------
function startGame()
  -- Unpause the game
  PAUSED_GAME = false

  Components.score.is_drawn = true

  Components.microwaves.is_drawn = true
  Components.microwaves.is_clickable = true
end

function updateGame(dt)
  if not PAUSED_GAME then
    Components.microwaves:update(dt)
    spawnFood()
    despawnFood()
    handleGameOver()
  end
end

function resetGame()
  PAUSED_GAME = true

  Components.score.score = 0
  Components.score.is_drawn = false

  -- Wipe the microwave list
  for k,v in pairs (Components.microwaves.list) do
      Components.microwaves.list[k] = nil
  end
  Components.microwaves.is_drawn = false
  Components.microwaves.is_clickable = false

  -- Create just a initial microwave
  spawnMicrowave(50, 50)
end

function handleGameOver()
  if #Components.microwaves.list == 0 then
    PAUSED_GAME = true
    -- Store the score in the results screen
    Components.result_label.score = Components.score.score
    showResultScreen()
    -- resetGame has to be called after because we need to display the score in the result screen
    resetGame()
  end
end

-------------------------------------
-- N/A
-------------------------------------
function showResultScreen()
  Components.result_label.is_drawn = true

  Components.retry_button.is_drawn = true
  Components.retry_button.is_clickable = true

  Components.title_screen_button.is_drawn = true
  Components.title_screen_button.is_clickable  = true
end
-------------------------------------
-- N/A
-------------------------------------
function removeResultScreen()
  Components.result_label.is_drawn = false

  Components.retry_button.is_drawn = false
  Components.retry_button.is_clickable = false

  Components.title_screen_button.is_drawn = false
  Components.title_screen_button.is_clickable  = false
end

-------------------------------------
-- N/A
-------------------------------------
function quit()
  love.event.quit()
end

-- Gameplay functions --

-------------------------------------
-- Generates a number from 1 to 100.
-- @return The lotto number.
-------------------------------------
function getLottoTicket()
  return math.random(0, 100)
end

-------------------------------------
-- Generates a number from a the possible floating point numbers min_t to max_t.
-- @param min_t The minimum time range, type float.
-- @param max_t The maximum time range, type float.
-- @return Returns the floating point number between min_t and max_t
-------------------------------------
function getRandTime(min_t, max_t)
  time = math.random(min_t * 100, max_t * 100)

  -- Turn the value back into its normal decimal place.
  return time / 100
end

-------------------------------------
-- Creates a food object from a random food group and returns it. The attributes the food is randomly given is based off of the FOOD_ATTRIBUTES table.
-- @param lotto_num A random number that determines the food type to be chosen.
-- @return the food type name and the food type attributes.
-------------------------------------
function getFoodType(lotto_num)
  local type_name, food_type = nil, nil

  -- Assign the food type based on the lotto_num variable.
  if lotto_num <= FOOD_ATTRIBUTES.VEGGY.LOTTO_NUM then
    type_name = "Vegetable"
    food_type = FOOD_ATTRIBUTES.VEGGY
  elseif lotto_num <= FOOD_ATTRIBUTES.GRAIN.LOTTO_NUM then
    type_name = "Grain"
    food_type = FOOD_ATTRIBUTES.GRAIN
  elseif lotto_num <= FOOD_ATTRIBUTES.FRUIT.LOTTO_NUM then
    type_name = "Fruit"
    food_type = FOOD_ATTRIBUTES.FRUIT
  elseif lotto_num <= FOOD_ATTRIBUTES.MEAT.LOTTO_NUM then
    type_name = "Meat"
    food_type = FOOD_ATTRIBUTES.MEAT
  elseif lotto_num <= FOOD_ATTRIBUTES.DAIRY.LOTTO_NUM then
    type_name = "Dairy"
    food_type = FOOD_ATTRIBUTES.DAIRY
  end

  return type_name, food_type
end

-------------------------------------
-- Spawns the food object in the microwave objects.
-- Food object has the data members: x, y, w, h, img, type, cooking_time and decay_time.
-- @param x_width The starting x-point of the food object. (Should be the x of the microwave plus half the width)
-- @param y_height The starting y-point of the food object. (should be the y of the microwave plus half the height)
-------------------------------------
function spawnFood()
  -- Loop through the table of microwaves and generate food for the empty microwaves.
  for _, m in pairs(Components.microwaves.list) do
    -- If microwave doesn't have a food and it is off cooldown
    if not m.food and m.cooldown < 0 then
      local lotto_num = getLottoTicket()
      -- Get the food type and the food type name.
      local type_name, food_type = getFoodType(lotto_num)
      local new_food = {x = m.x, y = m.y, img = nil, type = type_name,
                        cooking_time = getRandTime(food_type.COOKING_TIME_MIN, food_type.COOKING_TIME_MAX),
                        decay_time =  getRandTime(food_type.DECAY_TIME_MIN, food_type.DECAY_TIME_MAX),
                        radius = INITIAL_FOOD_RADIUS,
                        score = food_type.SCORE,
                        color = food_type.COLOR}

      -- Store the new food into the microwave.
      m.food = new_food
    end
  end
end

-------------------------------------
-- Despawns expired food objects in microwaves.
-------------------------------------
function despawnFood()
  for i = #Components.microwaves.list, 1, -1 do
    local microwave = Components.microwaves.list[i]
    if microwave.food then
      -- if food has expired
      if microwave.food.decay_time < 0 then
        -- remove the microwave with the expired food
        table.remove(Components.microwaves.list, i)
      end
    end
  end
end

-------------------------------------
-- Creates a microwave object and stores it in the microwaves table.
-- Microwave data members: x, y, w, h, img, food and is_drawn.
-- @param x The starting x-point of the microwave.
-- @param y The starting y-point of the microwave.
-------------------------------------
function spawnMicrowave(x, y)
  -- Make sure the number of microwaves in the table doesn't exceed the max amount.
  if #Components.microwaves.list <= MICROWAVE_MAX then
    -- Create a new microwave and insert it into the microwaves table.
    local new_microwave = {x = x, y = y, w = MICROWAVE_SIZE.WIDTH, h = MICROWAVE_SIZE.HEIGHT, img = nil, food = nil, object = nil, cooldown = 0}
    -- Assign the microwave a physical body.
    new_microwave.object = createPhysicalMicrowave(new_microwave)
    table.insert(Components.microwaves.list, new_microwave)
  end
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
  -- Set the default angle of the physical object to 0. NOTE: Used later for debugging purposes.
  new_microwave.angle = 0

  return new_microwave
end

-------------------------------------
-- Removes the last microwave element from the microwaves table.
-------------------------------------
function despawnMicrowave()
  -- Remove the specific microwave object from the table.
  last_index = #Components.microwaves.list
  table.remove(Components.microwaves.list, last_index)
end

-------------------------------------
-- Checks if the cooking time for the food has reached zero and returns true or false.
-- @param food The food to check the cooking time for.
-- @return Returns true or false if the cooking time has reached 0.
-------------------------------------
function isFoodReady(food)
  -- Return true if the cooking time is 0 or less than 0.
  if food.cooking_time <= 0 then
    return true
  end
  return false
end
