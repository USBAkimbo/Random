-- Requirements
--
-- A mining turtle
--
-- How to run
--
-- Open the turtle and paste in the below, then power cycle the turtle to start it
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/stupid-farm.lua startup
--
-- How it works
--
-- The turtle simply digs in front and deposits the item into the chest below
-- This works well with sugar cane and bamboo

while true do
    turtle.select(1) -- Select slot 1
    turtle.dig()
    turtle.dropDown()
end