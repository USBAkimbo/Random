-- Requirements
--
-- A mining turtle
-- Some space
-- Feed the mining turtle about 4 stacks of charcoal (needs to be full with 20k fuel)
-- Fill the chest with at least 1 stack of spruce saplings
-- Must be spruce as we're abusing the 2x2 trees
--
-- How to run
--
-- Open the placed mining turtle then paste in these 2 commands
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/tree-farm.lua tree-farm
-- tree-farm

-- What happens?
-- The farm expects a 4x4 shape of floating 2x2 platforms made of dirt with a 2 block gap in between
-- So 14x14 in total space
-- The starts the harvest by digging 5 blocks forward, then clears the 14x14 space up to 30 blocks
-- Then it returns to the chest and collects saplings
-- Saplings are planted
-- The turtle returns to the top of the chest and sleeps for 1 hour
-- The turtle loops back to the startprint("Cycle complete")

-- Crude farm map (use a highligher for the "SS")

-- Key
-- X = Water stream 4 blocks below
-- S = Sapling on top of dirt

-- XXXXXXXXXXXXXXXXXXXXXX
-- XXXXXXXXXXXXXXXXXXXXXX
-- XXXXXXXXXXXXXXXXXXXXXX
-- XXXXXXXXXXXXXXXXXXXXXX
-- XXXXSSXXSSXXSSXXSSXXXX
-- XXXXSSXXSSXXSSXXSSXXXX
-- XXXXXXXXXXXXXXXXXXXXXX
-- XXXXXXXXXXXXXXXXXXXXXX
-- XXXXSSXXSSXXSSXXSSXXXX
-- XXXXSSXXSSXXSSXXSSXXXX
-- XXXXXXXXXXXXXXXXXXXXXX
-- XXXXXXXXXXXXXXXXXXXXXX
-- XXXXSSXXSSXXSSXXSSXXXX
-- XXXXSSXXSSXXSSXXSSXXXX
-- XXXXXXXXXXXXXXXXXXXXXX
-- XXXXXXXXXXXXXXXXXXXXXX
-- XXXXSSXXSSXXSSXXSSXXXX
-- XXXXSSXXSSXXSSXXSSXXXX
-- XXXXXXXXXXXXXXXXXXXXXX
-- XXXXXXXXXXXXXXXXXXXXXX
-- XXXXXXXXXXXXXXXXXXXXXX
-- XXXXXXXXXXXXXXXXXXXXXX

-- Function start --

-- Function to plant an 14x14 of saplings
-- Assumes we have moved 5 blocks from the chest and we're above the bottom left corner of the farm
local function plantSaplings()
    turtle.select(16)
    for row = 1, 8 do -- There are 8 rows in total (4 rows of trees + 4 rows of gaps)
        for i = 1, 14 do -- Try to plant a spruce sapling in a line
            turtle.placeDown()
            if i < 14 then
                turtle.forward()
            end
        end

        if row < 8 then -- If there's another row to clear
            if row % 2 == 1 then -- Odd rows: Turn right, dig, move forward, turn right
                turtle.turnRight()
                turtle.forward()
                turtle.turnRight()
            else -- Even rows: Turn left, move 2 blocks into the next row, turn left
                turtle.turnLeft()
                turtle.forward()
                turtle.forward()
                turtle.forward()
                turtle.turnLeft()
            end
        end
    end
end

-- Function to clear blocks above, forward, or below
local function clearBlocks()
    turtle.digUp()
    turtle.dig() -- dig in front
    turtle.digDown()
end

local function harvestTrees() -- Assumes we're at the bottom left corner of the 14x14 farm area after moving from the chest into this block
    for layer = 1, 10 do -- 10 layers to clear up to 30 blocks high (3 blocks per layer)
        print("Clearing layer " .. layer .. "")
        for row = 1, 8 do -- There are 8 rows in total (4 rows of trees + 4 rows of gaps)
            for i = 1, 14 do -- Clear 14 blocks forward
                clearBlocks()
                if i < 14 then
                    turtle.forward()
                end
            end

            if row < 8 then -- If there's another row to clear
                if row % 2 == 1 then -- Odd rows: Turn right, dig, move forward, turn right
                    turtle.turnRight()
                    turtle.dig()
                    turtle.forward()
                    turtle.turnRight()
                else -- Even rows: Turn left, move 2 blocks into the next row, turn left
                    turtle.turnLeft()
                    turtle.dig()
                    turtle.forward()
                    turtle.dig()
                    turtle.forward()
                    turtle.dig()
                    turtle.forward()
                    turtle.turnLeft()
                end
            end
        end

        -- After clearing all rows in a layer, we are at the bottom-right corner of the 14x14

        -- Refuel using collected wood
        for i = 1, 16 do
            turtle.select(i)
            local itemDetail = turtle.getItemDetail(i)
            if itemDetail and string.find(itemDetail.name, "log") then -- Filter for logs
                turtle.refuel()
            end
        end

        -- Deposit items in water stream
        turtle.dig()
        turtle.forward()
        turtle.dig()
        turtle.forward() -- Hover over the water with at least a 1 block space to safely drop into the water
        turtle.digDown()
        for i = 1, 16 do
            turtle.select(i)
            turtle.dropDown() -- Drop all items into water or into the hole we just dug (which will drop to water when leaves decay)
        end
        turtle.back()
        turtle.back() -- Return to original starting position

        -- Turn right and move through the farm to start the next layer
        turtle.turnRight()
        for i = 1, 13 do
            turtle.forward()
        end
        turtle.turnRight()

        if layer < 11 then -- Dig up 3 blocks only if there are more layers to harvest
            turtle.digUp()
            turtle.up()
            turtle.digUp()
            turtle.up()
            turtle.digUp()
            turtle.up()
        end
    end
end

-- Function end --

-- Run an initial harvest to ensure a clean start
print("Starting initial harvest")
print("Moving 5 blocks forward to the start of the farm for harvesting")
for i = 1, 5 do
    turtle.dig() -- Dig the block we're about to move onto
    turtle.forward()
end
print("Reached harvesting start position")

print("Starting harvest")
harvestTrees()
print("Harvest complete")

print("Returning home") -- We end up 30 blocks above the bottom right hand corner of the farm, facing into the farm
for i = 1, 5 do
    turtle.back() -- Move back 5 spaces
end
for i = 1, 30 do
    turtle.down() -- Move down 30 spaces to end on top of the chest
end

-- Loop through planting, waiting and harvesting - loops infinitely so long as there's saplings in the chest and the server doesn't restart
while true do
    -- We start on top of a chest 5 blocks away from the farm
    -- The 4 blocks in front of us have water below
    -- The 5th block is the bottom left corner of the 14x14 farm

    print("Collecting 1 stack of spruce saplings from the starting chest")
    turtle.select(16)
    -- Check if saplings were successfully sucked
    if not turtle.suckDown() then
        print("ERROR: Failed to collect a stack of spruce saplings from the chest")
        error("Stopping script")
    end

    print("Moving 5 blocks forward from the chest")
    for i = 1, 5 do
        turtle.forward()
    end
    print("Reached planting start position")

    print("Planting saplings")
    plantSaplings()
    print("Sapling planting complete")

    print("Returning home")
    turtle.dig()
    turtle.forward() -- Move forward 1 to hover over the water
    turtle.turnRight()
    for i = 1, 13 do -- Move to the bottom left of the farm
        turtle.dig()
        turtle.forward()
    end
    turtle.turnLeft() -- Turn to face the chest
    for i = 1, 4 do
        turtle.dig()
        turtle.forward() -- End up back on top of the chest
    end
    turtle.turnRight()
    turtle.turnRight() -- Turn to face the farm
    print("Returned home")

    print("Waiting for trees to grow (10 mins)")
    os.sleep(600)

    print("Starting harvest")
    print("Moving 5 blocks forward to the start of the farm for harvesting")
    for i = 1, 5 do
        turtle.dig() -- Dig the block we're about to move onto
        turtle.forward()
    end
    print("Reached harvesting start position")

    print("Starting harvest")
    harvestTrees()
    print("Harvest complete")

    print("Returning home") -- We end up at the planting level but 30 blocks up, so we just need to go back 5 blocks and go down 30 blocks
    for i = 1, 5 do
        turtle.back()
    end
    for i = 1, 30 do
        turtle.down()
    end
    print("Cycle complete. Starting next cycle in 5 seconds.")
    sleep(5) -- Small delay before starting the next cycle
end
