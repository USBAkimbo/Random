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

-- Function end --

start main loop here

dig16x16x3()
returnToStart()
unloadItems()

now go down 3 and repeat, then go down 6, then go down 9 etc until we see bedrock

once we see bedrock, i want the turtle to go back to the chest