--[[game.lua
    - Handles all game logic and visual represnetations to the users.
    - Each component can draw itself.
    - The order in which the component appears in the COMPONENTS table is important.
]]--

-- Global constants --

-- Missing the microwave and food components.
MICROWAVE_MAX = 5

-- Dimension of the microwaves
MICROWAVE_SIZE = {WIDTH = 10, HEIGHT = 10}

-- Different physical components of the game.
COMPONENTS = {
  swimming_pool  = {x = 0, y = 0, w = 0, h = 0, img = nil, draw = false},
  title_label    = {x = 0, y = 0, w = 0, h = 0, img = nil, draw = false},
  start_button   = {x = 0, y = 0, w = 0, h = 0, img = nil, draw = false},
  quit_button    = {x = 0, y = 0, w = 0, h = 0, img = nil, draw = false},
  microwaves     = {},
  score          = {x = 0, y = 0, w = 0, h = 0, score = 0},
  results_window = {x = 0, y = 0, w = 0, h = 0, img = nil, draw = false, retry_butn = nil, return_to_menu_butn = nil}}

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
function init()

end

-------------------------------------
-- N/A
-------------------------------------
function showTitleScreen()
  --[[set attributes for
      title label
      start button
      quit button]]

end

-------------------------------------
-- N/A
-------------------------------------
function startGame()

end

-------------------------------------
-- N/A
-------------------------------------
function quit()

end

-------------------------------------
-- N/A
-------------------------------------
function showResultScreen()
            quit()
            showTitleScreen()

end

-- Gameplay functions --

-------------------------------------
-- Spawns the food object in the microwave objects.
-- @param x_width The starting x-point of the food object. (Should be the x of the microwave plus half the width)
-- @param y_height The starting y-point of the food object. (should be the y of the microwave plus half the height)
-------------------------------------
function spawnFood()
  -- Loop through the table of microwaves and generate food for the empty microwaves.
  for _, m in ipairs(COMPONENTS.microwaves) do
    -- If food has been despawned then generate a new one for the microwave.
    if not m.food then
      local lotto_num = getLottoTicket()
      -- Get the food type and the food type name.
      local type_name, food_type = getFoodType(lotto_num)
      local new_food = {x = m.x + (m.w / 2), y = m.y + (m.h / 2), img = nil, type = type_name, cooking_time = , decay_time =  }
    end
  end
end

-------------------------------------
-- Creates a microwave object and stores it in the microwaves table.
-- @param x The starting x-point of the microwave.
-- @param y The starting y-point of the microwave.
-------------------------------------
function createMicrowaveObject(x, y)
  -- Make sure the number of microwaves in the table doesn't exceed the max amount.
  if #COMPONENTS.microwaves <= MICROWAVE_MAX then
    -- Create a new microwave and insert it into the microwaves table.
    local new_microwave = {x = x, y = y, w = MICROWAVE_SIZE.WIDTH, h = MICROWAVE_SIZE.HEIGHT, img = nil, food = {}}
    table.insert(COMPONENTS.microwaves, new_microwave)
  end
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

  return type_name, new_food
end

-------------------------------------
-- Generates a number from 1 to 100.
-- @return The lotto number.
-------------------------------------
function getLottoTicket()
  math.randomseed(os.time())
  return math.random(0, 101)
end

-------------------------------------
-- Generates a number from a the possible floating point numbers min_t to max_t.
-- @param min_t The minimum time range, type float.
-- @param max_t The maximum time range, type float.
-- @return Returns the floating point number between min_t and max_t
-------------------------------------
function getRandTime(min_t, max_t)
  math.randomseed(os.time())
  time = math.random(min_t * 100, max_t * 100)

  -- Turn the value back into its normal decimal place.
  return time / 100
end
-------------------------------------
-- N/A
-------------------------------------
function despawnFood()

end

-------------------------------------
-- N/A
-------------------------------------
function spawnMicrowave()

end

-------------------------------------
-- N/A
-------------------------------------
function despawnMicrowave()

end

-------------------------------------
-- N/A
-------------------------------------
function microwavePressed()

end

-------------------------------------
-- N/A
-------------------------------------
function isFoodReady()

end
