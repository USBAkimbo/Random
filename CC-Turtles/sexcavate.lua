--------------------
-- Superior Excavate
--------------------
--
---------------
-- Requirements
---------------
-- A mining turtle
-- A chest
--
-------------
-- How to run
-------------
-- Open the placed mining turtle then paste in these 2 commands
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/sexcavate.lua sexcavate
-- sexcavate

--------
-- Usage
--------
-- The turtle expects to be in the bottom left corner of a 16x16 area
-- Place the turtle on Y=0
-- A chest needs to be behind the turtle
-- The turtle pulls a stack of items from the chest and refuels, then dumps anything in the inventory into the chest
-- The turtle then digs out a 16x16x3 area
-- Once it's done, it returns to the chest and unloads
-- Then it goes back out and does the next layer
-- It does this until bedrock is detected

-- Function start --

-- Function to clear blocks above, forward, or below
local function clearBlocks()
    turtle.digUp()
    turtle.dig() -- dig in front
    turtle.digDown()
end

local function dig16x16() -- Assumes we're at the bottom left corner of the 16x16 area
    for layer = 1, 2 do -- TESTING - 2 LAYERS - 3 blocks x 20 layers = 60 blocks dug down
        print("Clearing layer " .. layer .. "")
        for row = 1, 16 do -- There are 16 rows in total
            for i = 1, 16 do -- Clear 16 blocks forward unless we're on the last block
                clearBlocks()
                if i < 16 then
                    if not turtle.forward() then -- If we can't move forward there's probably gravel, so dig 10 times to get rid of it
                        for i = 1, 10 do
                            turtle.dig()
                        end
                        turtle.forward()
                    end
                end
            end

            if row < 16 then -- If there's another row to clear
                if row % 2 == 1 then -- Odd rows: Turn right, dig, move forward, turn right
                    turtle.turnRight()
                    turtle.dig()
                    if not turtle.forward() then -- If we can't move forward there's probably gravel, so dig 10 times to get rid of it
                        for i = 1, 10 do
                            turtle.dig()
                        end
                        turtle.forward()
                    end
                    turtle.turnRight()
                else -- Even rows: Turn left, move 2 blocks into the next row, turn left
                    turtle.turnLeft()
                    turtle.dig()
                    if not turtle.forward() then -- If we can't move forward there's probably gravel, so dig 10 times to get rid of it
                        for i = 1, 10 do
                            turtle.dig()
                        end
                        turtle.forward()
                    end
                    turtle.turnLeft()
                end
            end
        end
    end
end

local function returnToStart() -- Assumes we're at the bottom right corner of the 16x16 area after finishing clearing the layer
    turtle.turnRight()
    for i = 1, 16 do -- Turn right and dig 16 blocks forward
        turtle.dig()
        if not turtle.forward() then -- If we can't move forward there's probably gravel, so dig 10 times to get rid of it then move again
            for i = 1, 10 do
                turtle.dig()
            end
            turtle.forward()
        end
        turtle.turnRight() -- We're now back at the start in the bottom left corner, facing the starting direction
        for i = 1, 10 do -- Dig up 10 blocks without moving to clear any possible gravel
            turtle.digUp()
        end
        for i = 1, 100 do
            if not turtle.detectUp() then -- Check if there is no block above
                turtle.up() -- Try to go up 100 blocks to get back to the chest
            else
                turtle.down() -- Go down 1 block to be at the same level as the chest
                break -- Exit the loop if a block is detected above
            end
        end
    end
end

local function unloadItems()
    turtle.turnRight()
    turtle.turnRight() -- Face the chest
    for i = 1, 16 do
        turtle.select(i)
        turtle.drop() -- Drop all items into water or into the hole we just dug (which will drop to water when leaves decay)
    end
    turtle.turnRight()
    turtle.turnRight() -- Face the digging area
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
dig16x16()
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
    dig16x16()
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
