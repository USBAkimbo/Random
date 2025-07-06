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
    for row = 1, 14 do
        for col = 1, 14 do
            turtle.placeDown()
            if col < 14 then -- Move forward unless it's the last block
                turtle.forward()
            end
        end

        if row < 14 then
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
end

local function harvestTrees() -- Assumes we're at the start of the harvesting cycle at the top of the farm in the bottom left corner of the 14x14
    for layer = 1, 11 do -- 10 layers to cover 30 blocks (3 blocks per layer is cleared) - says 11 layers but lua is weird so it's really 10
        print("Clearing layer " .. layer .. "")
        for row = 1, 14 do
            for col = 1, 14 do
                clearBlocks() -- Dig up, forward, down
                if col < 14 then -- Move forward unless it's the last block in the row
                    turtle.forward()
                end
            end
            if row < 14 then -- After clearing a row, prepare for the next one within the same layer
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
        -- This gets us to the starting X,Z position of the current 14x14 layer

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
        turtle.forward() -- Hover over the water
        turtle.digDown()
        for i = 1, 16 do
            turtle.select(i)
            turtle.dropDown() -- Drop all items into water or into the hole we just dug
        end
        turtle.back() -- Return to original starting position

        -- Turn right and dig through the farm to start the next layer
        turtle.turnRight()
        for i = 1, 13 do
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

print("Returning home") -- We end up at the planting level but 30 blocks up, so we just need to go back 5 blocks and go down 30 blocks
for i = 1, 5 do
    turtle.back()
end
for i = 1, 30 do
    turtle.down()
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
    returnHome()
    print("Returned home")

    print("Waiting for trees to grow (10 minutes)")
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
