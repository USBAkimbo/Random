---------------
-- Requirements
---------------
-- A mining turtle (no fuel required)
-- Soul sand with nether wart planted on it
-------------
-- How to run
-------------
-- Open the turtle and paste in the below, then power cycle the turtle to start it - the turtle stores all collected nether wart
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/nether-wart-farm.lua startup

while true do
    turtle.select(1) -- Select slot 1
    local success, data = turtle.inspectDown() -- Inspect the nether wart
    if success and data and data.state and data.state.age == 3 then -- If growth state is 3 (max) then harvest and re-plant
        turtle.digDown() -- Collect the nether wart
        turtle.placeDown() -- Re-plant the nether wart
    end
end
