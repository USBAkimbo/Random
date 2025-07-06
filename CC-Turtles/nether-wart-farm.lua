-- Requirements
--
-- A mining turtle (no fuel required)
-- Soul sand with nether wart planted on it
--
-- How to run
--

-- Open the turtle and paste in the below, then power cycle the turtle to start it - the turtle stores all collected nether wart
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/nether-wart-farm.lua startup

while true do

    print("Starting harvest")
    turtle.select(1) -- Select slot 1
    turtle.digDown() -- Collect the nether wart
    turtle.placeDown() -- Re-plant the nether wart
    print("Sleeping for 40 mins") -- https://minecraft.wiki/w/Nether_Wart#Farming - fully grows from planting to harvest every 40960 game ticks (34.133333333333 minutes) on average
    os.sleep(2400)
    print("Current fuel level: " .. turtle.getFuelLevel())
    print("Cycle complete")
    
end
