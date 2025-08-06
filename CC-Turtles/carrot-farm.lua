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

-- ------------------------------------------------------------
--  Carrot‑harvester for ComputerCraft / CC: Tweaked
--
--  The script now checks whether the turtle’s inventory is full.
--  If it is, the script stops instead of continuing to dig/drop.
-- ------------------------------------------------------------

local function inventoryFull()
    -- Scan all 16 slots; if any are empty return false
    for slot = 1, 16 do
        local item = turtle.getItemDetail(slot)
        if not item then          -- empty slot found
            return false
        end
    end
    return true                   -- every slot contains an item
end

-- Main loop – runs until the inventory is full or we manually stop it
while true do

    -- 1. Check inventory first; exit if it's already full
    if inventoryFull() then
        print("[INFO] Inventory is full. Stopping script.")
        break   -- exits the while‑true loop, ending the program
    end

    ------------------------------------------------------------------
    -- Wait until the carrot below is fully grown (age == 7)
    ------------------------------------------------------------------
    local isGrown = false
    while not isGrown do
        local success, data = turtle.inspectDown()
        if success and data.name == "minecraft:carrot" and data.state.age == 7 then
            isGrown = true
        else
            os.sleep(5)   -- pause before checking again
        end
    end

    ------------------------------------------------------------------
    -- Harvest the fully grown carrot
    ------------------------------------------------------------------
    turtle.digDown()

    ------------------------------------------------------------------
    -- Find a carrot in the inventory and plant it
    ------------------------------------------------------------------
    for i = 1, 16 do
        local item = turtle.getItemDetail(i)
        if item and item.name == "minecraft:carrot" then
            turtle.select(i)     -- pick the carrot slot
            turtle.placeDown()   -- plant it below
            break                -- only plant one carrot per cycle
        end
    end

    ------------------------------------------------------------------
    -- Drop all items from every inventory slot up into the water stream
    ------------------------------------------------------------------
    for i = 1, 16 do
        turtle.select(i)
        turtle.dropUp()
    end

    -- Loop back to wait for the next carrot to grow
end
