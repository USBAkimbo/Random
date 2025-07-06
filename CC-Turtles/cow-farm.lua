-- Requirements
--
-- A mining turtle in the middle of 2x cow crusher 9000
--
-- How to run
--
-- Open the turtle and paste in the below, then power cycle the turtle to start it
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/cow-farm.lua startup

while true do

    turtle.suckUp() -- Pull a stack of wheat from the chest above
    turtle.select(1) -- Select slot 1
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