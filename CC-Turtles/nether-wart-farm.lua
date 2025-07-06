-- Requirements
--
-- A mining turtle (refuel to max)
-- Soul sand with nether wart planted on it
--
-- How to run
--

-- Open the placed mining turtle then paste in these 2 commands - it will auto start on server restart too
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/nether-wart-farm.lua startup
-- startup

-- Loop until we run out of fuel
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
