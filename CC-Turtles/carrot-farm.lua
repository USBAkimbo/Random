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

-- ────────────────────────────────────────────────────────────────
--  Carrot farmer – exits when inventory is full
--  Adapted for ComputerCraft / CC:Tweaked
-- ────────────────────────────────────────────────────────────────

local function inventoryFull()
    -- Returns true if every slot contains at least one item.
    local slots = turtle.getInventorySize()   -- usually 16 on a vanilla turtle
    for i = 1, slots do
        if turtle.getItemCount(i) == 0 then
            return false          -- found an empty slot → inventory NOT full
        end
    end
    return true                   -- all slots had something in them
end

while true do
    if inventoryFull() then
        print("[CarrotFarmer] Inventory is full – stopping.")
        os.exit()                 -- terminate the program gracefully
    end

    turtle.select(1)              -- keep using slot 1 for carrot operations
    local success, data = turtle.inspectDown()

    if success and data and data.state and data.state.age == 7 then
        turtle.digDown()          -- harvest mature carrot
        turtle.placeDown()        -- plant a new one immediately
    end

    sleep(0.1)                    -- small pause to prevent CPU hogging
end
