-- Requirements
--
-- A mining turtle
-- Place on top of the cobble that a cobble gen makes
-- Place a chest above to deposit into
-- No fuel needed as the turtle doesn't move
--
-- How to run
--
-- Open the turtle and paste in the below, then power cycle the turtle to start it
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/cobble-farm.lua startup

while true do

    turtle.select(1)
    turtle.digUp()
    turtle.dropDown()

end
