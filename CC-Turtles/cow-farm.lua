-- Requirements
--
-- A mining turtle in the middle of 2x cow crusher 9000
--
-- How to run
--
-- Open the turtle and paste in the below, then power cycle the turtle to start it
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/cow-farm.lua startup

while true do

    turtle.select(1) -- Select slot 1
    turtle.suckUp() -- Pull a stack of wheat from the chest above
    local wheatFound = false -- Search for wheat in any slot in case we didn't pull any in and we have some in our inventory
    for i = 1, 16 do -- Check all 16 inventory slots
        turtle.select(i)
        local item = turtle.getItemDetail()
        if item and item.name == "minecraft:wheat" then
            wheatFound = true
            break -- Wheat found, exit loop and keep it selected
        end
    end

    for i = 1, 32 do -- Try to feed 32 wheat to cows
        turtle.place()
    end
    turtle.turnRight()
    turtle.turnRight() -- Spit 180
    for i = 1, 32 do -- Try to feed 32 wheat to the other cows
        turtle.place()
    end
        
    print("Sleeping for 5 mins until cows can breed again")
    os.sleep(300)
    print("Starting feeding cycle")

end