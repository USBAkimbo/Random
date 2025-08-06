-- Info
--
-- Stupid farm used to farm 1 carrot
-- 
-- How to run
--
-- Till a piece of farmland and place a carrot
-- Place a carrot on it
-- Place a water source near the farmland
-- Place a turtle above the carrot
-- Paste this into it
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/carrot-farm.lua startup
-- Restart the turtle

-- What happens?
-- The turtle checks the growth of the carrot and re-plants it when it's fully grown
-- The extra carrots are stored in the turtle
-- The turtle stops when it has no more inventory space

local function inventoryFull()
    -- Returns true if every slot contains at least one item.
    for i = 1, 16 do -- A turtle's inventory size is fixed at 16 slots.
        if turtle.getItemCount(i) == 0 then
            return false -- Found an empty slot.
        end
    end
    return true -- All slots have items.
end

while true do
    if inventoryFull() then
        print("[CarrotFarmer] Inventory is full – stopping.")
        break -- A more common way to exit a loop. os.exit() also works.
    end

    turtle.select(1) -- Use slot 1 for planting. Assumes carrots are in this slot.

    -- Inspect the block below the turtle.
    local success, data = turtle.inspectDown()

    -- Check if inspection was successful and the block is a mature carrot.
    -- Carrots are mature when their 'age' block state is 7.
    if success and data.name == "minecraft:carrots" and data.state and data.state.age == 7 then
        turtle.digDown()   -- Harvest the mature carrot.
        turtle.placeDown() -- Plant a new one from the selected slot (1).
    end

    os.sleep(0.1) -- Use os.sleep() and provide a small delay.
end