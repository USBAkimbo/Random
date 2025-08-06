-- Info
--
-- Stupid farm used to farm 1 carrot
-- 
-- How to run
--
-- Till a piece of farmland and place a carrot
-- Place a water source near the farmland
-- Place a carrot on it
-- Place a turtle above the carrot
-- Paste this into it
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/carrot-farm.lua startup
-- Then restart the turtle

-- What happens?
-- The turtle checks the growth of the carrot and re-plants it when it's fully grown
-- The extra carrots are stored in the turtle
-- The turtle stops when it has no more inventory space

-- This loop runs the turtle's logic forever
while true do

  -- Wait until the carrot below is fully grown
  local isGrown = false
  while not isGrown do
    -- Inspect the block below the turtle
    local success, data = turtle.inspectDown()
    
    -- Check if inspection was successful and if the carrot's age is 7 (fully grown)
    if success and data.name == "minecraft:carrot" and data.state.age == 7 then
      isGrown = true
    else
      -- If not grown, wait for 5 seconds before checking again
      os.sleep(5)
    end
  end

  -- Harvest the fully grown carrot
  turtle.digDown()

  -- Find carrot in the inventory and plant them
  for i = 1, 16 do
    local item = turtle.getItemDetail(i)
    -- Check if the slot contains a carrot
    if item and item.name == "minecraft:carrot" then
      turtle.select(i) -- Select the carrot
      turtle.placeDown() -- Plant the carrot
      break -- Exit the loop after planting
    end
  end

  -- Loop through all 16 inventory slots to drop items
  for i = 1, 16 do
    turtle.select(i)
    -- Drop the entire stack from the current slot up into the water stream
    turtle.dropUp()
  end
  
  -- The script now loops back to the beginning to wait for the new carrot to grow
end