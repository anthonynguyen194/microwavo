--[[game.lua
    - Handles all game logic and visual represnetations to the users.
    - Each component can draw itself.
    - The order in which the component appears in the COMPONENTS table is important.
]]--

-- Global constants
COMPONENTS = {
  swimming_pool  = {x = 0, y = 0, w = 0, h = 0, img = nil, draw = false},
  title_label    = {x = 0, y = 0, w = 0, h = 0, img = nil, draw = false},
  start_button   = {x = 0, y = 0, w = 0, h = 0, img = nil, draw = false},
  quit_button    = {x = 0, y = 0, w = 0, h = 0, img = nil, draw = false},
  microwaves     = {},
  score          = {x = 0, y = 0, w = 0, h = 0, score = 0},
  results_window = {x = 0, y = 0, w = 0, h = 0, img = nil, draw = false, retry_butn = nil, return_to_menu_butn = nil}}

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
-- N/A
-------------------------------------
function spawnFood()

end

-------------------------------------
-- Creates a microwave object and stores it in the microwaves table.
-------------------------------------
function createMicrowaveObject()

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
