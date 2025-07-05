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
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/treefarm.lua treefarm
-- treefarm
--
-- Or if you just want to harvest
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/harvest.lua harvest
-- harvest

-- Function start --

-- Function to plant an 8x8 of saplings
-- Assumes we have moved 5 blocks from the chest and we're above the bottom left corner of the farm
local function plantSaplings()
    turtle.select(16)
    for row = 1, 8 do
        for col = 1, 8 do
            turtle.placeDown()
            if col < 8 then -- Move forward unless it's the last block
                turtle.forward()
            end
        end

        if row < 8 then
            if row % 2 == 1 then -- Odd rows: right, forward, right
                turtle.turnRight()
                turtle.forward()
                turtle.turnRight()
            else                 -- Even rows: left, forward, left
                turtle.turnLeft()
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

local function returnHome() -- Assumes we're at the end of a planting cycle or harvesting cycle and are in the bottom right corner of the farm
    turtle.dig()
    turtle.forward() -- Move forward 1 to hover over the water
    turtle.turnRight()
    for i = 1, 7 do
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
end

local function harvestTrees() -- Assumes we're at the start of the harvesting cycle at the top of the farm in the bottom left corner of the 8x8
    for layer = 1, 11 do -- 10 layers to cover 30 blocks (3 blocks per layer is cleared) - says 11 layers but lua is weird so it's really 10
        print("Clearing layer " .. layer .. "")
        for row = 1, 8 do
            for col = 1, 8 do
                clearBlocks() -- Dig up, forward, down
                if col < 8 then -- Move forward unless it's the last block in the row
                    turtle.forward()
                end
            end
            if row < 8 then -- After clearing a row, prepare for the next one within the same layer
                if row % 2 == 1 then -- Odd rows: turn right, move forward (to next row), turn right
                    turtle.turnRight()
                    turtle.dig()
                    turtle.forward()
                    turtle.turnRight()
                else                 -- Even rows: turn left, move forward (to next row), turn left
                    turtle.turnLeft()
                    turtle.dig()
                    turtle.forward()
                    turtle.turnLeft()
                end
            end
        end

        -- We're now at the bottom right of the farm
        -- This gets us to the starting X,Z position of the current 8x8 layer

        -- Refuel using collected wood
        for i = 1, 16 do
            turtle.select(i)
            turtle.refuel()
        end

        -- Deposit items in water stream
        turtle.dig()
        turtle.forward()
        for i = 1, 16 do
            turtle.select(i)
            turtle.place() -- Attempt to place a wood block
        end
        turtle.back()
        for i = 1, 16 do
            turtle.select(i)
            turtle.drop() -- Spit all items out at the log so they drop nicely into the water stream
        end
        turtle.forward()
        turtle.dig() -- Remove the block
        turtle.back()

        -- Turn right and dig through the farm to start the next layer
        turtle.turnRight()
        for i = 1, 7 do
            clearBlocks() -- Dig through the farm
            turtle.forward()
        end
        turtle.turnRight()

        if layer < 11 then -- Move up only if there are more layers to harvest
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

-- Main loop starts here
while true do
    -- We start on top of a chest 5 blocks away from the farm
    -- The 4 blocks in front of us have water below
    -- The 5th block is the bottom left corner of the 8x8 farm

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
