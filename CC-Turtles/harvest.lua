-- Configuration
local SAPLING_SLOT = 16 -- Inventory slot where saplings are located

-- Function start --

-- Function to plant an 8x8 of saplings
-- Assumes we have moved 5 blocks from the chest and we're above the bottom left corner of the farm
local function plantSaplings()
    turtle.select(SAPLING_SLOT)
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
    for layer = 1, 10 do -- 10 layers to cover 30 blocks (3 blocks per layer is cleared)
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
        for i = 1, 14 do
            turtle.select(i)
            turtle.drop() -- We need to spit out all items into the water stream to be collected by the hopper
        end

        -- This gets us to the starting X,Z position of the current 8x8 layer
        turtle.turnRight()
        for i = 1, 7 do
            clearBlocks() -- Dig through the farm
            turtle.forward()
        end
        turtle.turnRight()

        if layer < 10 then -- Move down only if there are more layers to harvest
            turtle.digDown()
            turtle.down()
            turtle.digDown()
            turtle.down()
            turtle.digDown()
            turtle.down()
        end
    end
end

-- Function end --

-- We start on top of a chest 5 blocks away from the farm
-- The 4 blocks in front of us have water below
-- The 5th block is the bottom left corner of the 8x8 farm

print("Starting harvest")
print("Climbing 28 blocks to to max tree height")
for i = 1, 30 do -- Dig up 30 blocks because Spruce grows to 30 max and this divides into 10 layers of 3 to harvest
    turtle.digUp()
    turtle.up()
end
print("Reached harvesting height")
print("Moving 5 blocks forward to the start of the farm for harvesting")
for i = 1, 5 do
    turtle.dig() -- Dig the block we're about to move onto
    turtle.forward()
end
print("Reached harvesting start position")

print("Starting harvest")
harvestTrees()
print("Harvest complete")

print("Returning home") -- We end up at the planting level, so we just need to go back 5 blocks
for i = 1, 5 do
    turtle.back()
end