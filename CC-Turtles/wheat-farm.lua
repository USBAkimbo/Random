-- Info
--
-- This has been designed for a 2x8 line of turtles with a water stream over them
-- This is so they can drop items up and then end up in the chest at the front
-- 
-- Setup
-- 
-- Place a 2x8 line of turtles
-- Place 2 water streams above it so all the turtles are covered and items end up in a hopper at the end
-- Cover the water stream so items don't get lost
-- Test it and ensure that items end up in the chest
--
-- How to run
--
-- Open each mining turtle then paste in this
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/wheat-farm.lua startup
-- Then restart the turtle

-- What happens?
-- The turtle checks the below wheat block's growth state and waits until the wheat has fully grown
-- Once it has fully grown, it digs down to harvest it
-- Then it selects seeds from its inventory
-- Then it plants the seeds
-- Then it loops from slot 1 to 16, dropping items up into the water stream
-- Then it goes back to the start, waiting for the wheat to grow and repeating forever

-- This loop runs the turtle's logic forever
while true do

  -- Wait until the wheat below is fully grown
  local isGrown = false
  while not isGrown do
    -- Inspect the block below the turtle
    local success, data = turtle.inspectDown()
    
    -- Check if inspection was successful and if the wheat's age is 7 (fully grown)
    if success and data.name == "minecraft:wheat" and data.state.age == 7 then
      isGrown = true
    else
      -- If not grown, wait for 5 seconds before checking again
      os.sleep(5)
    end
  end

  -- Harvest the fully grown wheat
  turtle.digDown()

  -- Find wheat seeds in the inventory and plant them
  for i = 1, 16 do
    local item = turtle.getItemDetail(i)
    -- Check if the slot contains wheat seeds
    if item and item.name == "minecraft:wheat_seeds" then
      turtle.select(i) -- Select the slot with seeds
      turtle.placeDown() -- Plant the seeds
      break -- Exit the loop after planting
    end
  end

  -- Loop through all 16 inventory slots to drop items
  for i = 1, 16 do
    turtle.select(i)
    -- Drop the entire stack from the current slot up into the water stream
    turtle.dropUp()
  end
  
  -- The script now loops back to the beginning to wait for the new seeds to grow
end