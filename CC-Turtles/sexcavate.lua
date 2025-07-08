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
-- Place 4 turtles around a single chest with a void filter
-- Place a chunk loader above the chest
-- Run "sexcavate" on each turtle
-- The turtle expects to be in the bottom left corner of a 16x16 area
-- The turtle needs a block 2 spaces above its head to use as a stopping point
-- Place the turtle on Y=1 as it goes 60 blocks down (to stop before bedrock at Y=-59)
-- The turtle expects a stack of charcoal blocks from the chest
-- It pulls a stack of charcoal blocks from the chest and refuels, then dumps anything in the inventory into the chest
-- The turtle then digs out a 16x16x3 area
-- Once it's done, it returns to the chest and unloads
-- Then it goes back out and does the next layer
-- It does this until we reach Y=-59

--------------------
-- Function start --
--------------------

-- Function to do an initial refuel
local function initialRefuel()
    turtle.turnRight()
    turtle.turnRight() -- Turn to face the chest
    turtle.select(1)
    turtle.suck() -- Pull a stack of charcoal blocks from the chest and refuel
    turtle.refuel()
    for i = 1, 16 do
        turtle.select(i)
        turtle.drop() -- Dump all inventory into the chest for a clean start
    end
    turtle.turnRight()
    turtle.turnRight() -- Turn to face the mine
end

-- Function to clear blocks above, forward, and below
local function clearBlocks()
    turtle.digUp()
    turtle.dig()
    turtle.digDown()
end

-- Function to clear a 16x16x3 area, starting from the bottom left and ending up in the bottom right
local function dig16x16x3() -- Assumes we're at the bottom left corner of the 16x16 area
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

-- Function to go back to where we started mining, then go up to the chest
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
        for i = 1, 70 do -- TEST: try 70 but maybe only needs to be 60?
            if not turtle.detectUp() then -- Check if there is no block above
                turtle.up() -- Try to go up to get back to the chest
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

------------------
-- Function end --
------------------

-- Turtle is placed on Y=1 as we dig down 60 blocks to stop on Y=-59
initialRefuel()

-- Start of digging loop
local depth = 0
while depth ~= 20 do
    dig16x16x3()
    returnToStart()
    unloadItems()
    depth = depth + 3 -- Add 3 to go down 3 more layers
    for i = 1, depth do -- loop through current depth count
        turtle.digDown()
        turtle.down()
    end
end
