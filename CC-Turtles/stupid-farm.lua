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
-- The turtle simply digs in front and the item drops on the floor
-- It's just like a player breaking the block
-- This works well with sugar cane and bamboo - simply place them on a mud block and put a hopper under it

while true do
    turtle.dig()
end