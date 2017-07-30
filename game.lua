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
MICROWAVE_SIZE = {WIDTH = 40, HEIGHT = 30}

-- Different physical Components of the game.
Components = {
  swimming_pool  = {x = 0, y = 0, w = 0, h = 0, img = nil, is_drawn = false},
  title_label    = {x = 52, y = 200, is_drawn = false,
                    img = love.graphics.newImage("assets/title.png"),
                    draw = function (self)
                      love.graphics.setColor(255, 255, 255)
                      love.graphics.draw(self.img, self.x, self.y)
                    end},
  start_button   = {x = 52, y = 350, w = 105, h = 50, is_drawn = false, is_clickable = false,
                    img = love.graphics.newImage("assets/start-button.png"),
                    draw = function (self)
                      love.graphics.setColor(255, 255, 255)
                      love.graphics.draw(self.img, self.x, self.y)
                    end,
                    clicked = function (self)
                      removeTitleScreen()
                      startGame()
                    end},
  quit_button    = {x = 263, y = 350, w = 105, h = 50, is_drawn = false, is_clickable = false,
                    img = love.graphics.newImage("assets/quit-button.png"),
                    draw = function (self)
                      love.graphics.setColor(255, 255, 255)
                      love.graphics.draw(self.img, self.x, self.y)
                    end,
                    clicked = function (self)
                      quit()
                    end},
  microwaves     = {list = {}, is_drawn = false, is_clickable = false, clickedIndices = {},
                    draw = function (self)
                      for _, m in pairs(self.list) do
                        -- draw microwave
                        love.graphics.setColor(119, 136, 153)
                        love.graphics.rectangle("line", m.x, m.y, m.w, m.h)

                        -- if there is food inside the microwave
                        if m.food then
                          -- draw food
                          love.graphics.setColor(220, 20, 60)
                          love.graphics.circle("fill", m.food.x, m.food.y, 5)
                        end
                      end
                    end,
                    clicked = function (self)
                      for _,i in pairs(self.clickedIndices) do
                        print("Microwave at index " .. i .. " has been clicked!")
                      end
                    end },
  score          = {x = 5, y = 5, score = 0, is_drawn = false,
                    draw = function (self)
                      love.graphics.setColor(255, 255, 255)
                      love.graphics.print("Score = " .. self.score, self.x, self.y, 0, 1.25)
                    end},
  results_window = {x = 0, y = 0, w = 0, h = 0, img = nil, is_drawn = false, retry_butn = nil, return_to_menu_butn = nil}}

-- Stores the attribute of each food group.
FOOD_ATTRIBUTES = {
  VEGGY = {LOTTO_NUM = 25, COOKING_TIME_MIN = 2, COOKING_TIME_MAX = 3,
           DECAY_TIME_MIN = 1, DECAY_TIME_MAX = 3, SCORE = 1},

  GRAIN = {LOTTO_NUM = 50, COOKING_TIME_MIN = .25, COOKING_TIME_MAX = .50,
           DECAY_TIME_MIN = 1, DECAY_TIME_MAX = 1.5, SCORE = 3},

  FRUIT = {LOTTO_NUM = 66, COOKING_TIME_MIN = 1, COOKING_TIME_MAX = 2,
           DECAY_TIME_MIN = 1, DECAY_TIME_MAX = 1.5, SCORE = 2},

  MEAT = {LOTTO_NUM = 84, COOKING_TIME_MIN = 1, COOKING_TIME_MAX = 3,
           DECAY_TIME_MIN = 1, DECAY_TIME_MAX = 2, SCORE = 2},

  DAIRY = {LOTTO_NUM = 100, COOKING_TIME_MIN = .5, COOKING_TIME_MAX = 1,
           DECAY_TIME_MIN = .5, DECAY_TIME_MAX = 1, SCORE = 4}}

-- Transition functions --

-------------------------------------
-- N/A
-------------------------------------
function initialize()
  showTitleScreen()
end

-------------------------------------
-- Show the title screen.
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
  Components.score.is_drawn = true

  Components.microwaves.is_drawn = true
  Components.microwaves.is_clickable = true

  spawnMicrowave(50, 50)
  spawnFood()
end

-------------------------------------
-- N/A
-------------------------------------
function quit()
  love.event.quit()
end

-------------------------------------
-- N/A
-------------------------------------
function showResultScreen()
            showTitleScreen()

end

-- Gameplay functions --

-------------------------------------
-- Generates a number from 1 to 100.
-- @return The lotto number.
-------------------------------------
function getLottoTicket()
  return math.random(0, 101)
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
  for _, m in ipairs(Components.microwaves.list) do
    -- If food has been despawned then generate a new one for the microwave.
    if not m.food then
      local lotto_num = getLottoTicket()
      -- Get the food type and the food type name.
      local type_name, food_type = getFoodType(lotto_num)
      local new_food = {x = m.x + (m.w / 2), y = m.y + (m.h / 2), img = nil, type = type_name,
                        cooking_time = getRandTime(food_type.COOKING_TIME_MIN, food_type.COOKING_TIME_MAX),
                        decay_time =  getRandTime(food_type.DECAY_TIME_MIN, food_type.DECAY_TIME_MAX)}

      -- Store the new food into the microwave.
      m.food = new_food
    end
  end
end

-------------------------------------
-- Search for the food to remove in the microwave and set it to nil.
-- @param food_to_remove The food to be removed from the microwave.
-------------------------------------
function despawnFood(food_to_remove)
  -- Loop through the microwave an remove the food.
  for _, m in Components.microwaves.list do
    if food_to_remove == m.food then
      m.food = nil
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
    local new_microwave = {x = x, y = y, w = MICROWAVE_SIZE.WIDTH, h = MICROWAVE_SIZE.HEIGHT, img = nil, food = nil, is_drawn = false}
    table.insert(Components.microwaves.list, new_microwave)
  end
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
