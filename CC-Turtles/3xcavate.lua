------------------------------------------------
-- SPDX-FileCopyrightText: 2017 Daniel Ratcliffe
-- SPDX-License-Identifier: LicenseRef-CCPL
------------------------------------------------

-----------
-- 3xcavate
-----------

----------------
-- What is this?
----------------
-- This is a mod of the excavate.lua script, except it mines 3 blocks at a time and goes down 3 blocks at a time
-- This was a GPT one shot from Claude (annoyingly since I spent so much time on my own)

-------------------
-- Download and run
-------------------
-- Go to the corner of a chunk border where you want to mine
-- Place a chest with a void filter and a chunk loader above it
-- Place 4 mining turtles around the chest
-- Open each mining turtle and paste in this
-- wget https://raw.githubusercontent.com/USBAkimbo/Random/refs/heads/master/CC-Turtles/3xcavate.lua 3xcavate
-- Then excavate a 16x16 area down to bedrock
-- 3xcavate 16
-- The turtle will come back up to drop off items and be refueled

--------------------------------------------------

if not turtle then
    printError("Requires a Turtle")
    return
end

local tArgs = { ... }
if #tArgs ~= 1 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: " .. programName .. " <diameter>")
    return
end

-- Mine in a quarry pattern until we hit something we can't dig
local size = tonumber(tArgs[1])
if size < 1 then
    print("Excavate diameter must be positive")
    return
end

local depth = 0
local unloaded = 0
local collected = 0

local xPos, zPos = 0, 0
local xDir, zDir = 0, 1

local goTo -- Filled in further down
local refuel -- Filled in further down

local function unload(_bKeepOneFuelStack)
    print("Unloading items...")
    for n = 1, 16 do
        local nCount = turtle.getItemCount(n)
        if nCount > 0 then
            turtle.select(n)
            local bDrop = true
            if _bKeepOneFuelStack and turtle.refuel(0) then
                bDrop = false
                _bKeepOneFuelStack = false
            end
            if bDrop then
                turtle.drop()
                unloaded = unloaded + nCount
            end
        end
    end
    collected = 0
    turtle.select(1)
end

local function returnSupplies()
    local x, y, z, xd, zd = xPos, depth, zPos, xDir, zDir
    print("Returning to surface...")
    goTo(0, 0, 0, 0, -1)

    local fuelNeeded = 2 * (x + y + z) + 1
    if not refuel(fuelNeeded) then
        unload(true)
        print("Waiting for fuel")
        while not refuel(fuelNeeded) do
            os.pullEvent("turtle_inventory")
        end
    else
        unload(true)
    end

    print("Resuming mining...")
    goTo(x, y, z, xd, zd)
end

local function collect()
    local bFull = true
    local nTotalItems = 0
    for n = 1, 16 do
        local nCount = turtle.getItemCount(n)
        if nCount == 0 then
            bFull = false
        end
        nTotalItems = nTotalItems + nCount
    end

    if nTotalItems > collected then
        collected = nTotalItems
        if math.fmod(collected + unloaded, 50) == 0 then
            print("Mined " .. collected + unloaded .. " items.")
        end
    end

    if bFull then
        print("No empty slots left.")
        return false
    end
    return true
end

function refuel(amount)
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel == "unlimited" then
        return true
    end

    local needed = amount or xPos + zPos + depth + 2
    if turtle.getFuelLevel() < needed then
        for n = 1, 16 do
            if turtle.getItemCount(n) > 0 then
                turtle.select(n)
                if turtle.refuel(1) then
                    while turtle.getItemCount(n) > 0 and turtle.getFuelLevel() < needed do
                        turtle.refuel(1)
                    end
                    if turtle.getFuelLevel() >= needed then
                        turtle.select(1)
                        return true
                    end
                end
            end
        end
        turtle.select(1)
        return false
    end

    return true
end

-- New function to mine 3 layers at current position
local function mineThreeLayers()
    if not refuel() then
        print("Not enough Fuel")
        returnSupplies()
    end

    -- Mine up
    while turtle.detectUp() do
        if turtle.digUp() then
            if not collect() then
                returnSupplies()
            end
        else
            break
        end
    end
    
    -- Attack up if there's a mob
    if turtle.attackUp() then
        if not collect() then
            returnSupplies()
        end
    end

    -- Mine current level (forward direction handled by movement)
    
    -- Mine down
    while turtle.detectDown() do
        if turtle.digDown() then
            if not collect() then
                returnSupplies()
            end
        else
            break
        end
    end
    
    -- Attack down if there's a mob
    if turtle.attackDown() then
        if not collect() then
            returnSupplies()
        end
    end

    return true
end

local function tryForwards()
    if not refuel() then
        print("Not enough Fuel")
        returnSupplies()
    end

    while not turtle.forward() do
        if turtle.detect() then
            if turtle.dig() then
                if not collect() then
                    returnSupplies()
                end
            else
                return false
            end
        elseif turtle.attack() then
            if not collect() then
                returnSupplies()
            end
        else
            sleep(0.5)
        end
    end

    xPos = xPos + xDir
    zPos = zPos + zDir
    
    -- Mine 3 layers at this new position
    mineThreeLayers()
    
    return true
end

-- New function to descend 3 layers at once
local function tryDown3()
    if not refuel() then
        print("Not enough Fuel")
        returnSupplies()
    end

    -- Descend 3 layers
    for i = 1, 3 do
        while not turtle.down() do
            if turtle.detectDown() then
                if turtle.digDown() then
                    if not collect() then
                        returnSupplies()
                    end
                else
                    return false
                end
            elseif turtle.attackDown() then
                if not collect() then
                    returnSupplies()
                end
            else
                sleep(0.5)
            end
        end
        depth = depth + 1
    end

    if math.fmod(depth, 10) == 0 then
        print("Descended " .. depth .. " metres.")
    end

    return true
end

local function turnLeft()
    turtle.turnLeft()
    xDir, zDir = -zDir, xDir
end

local function turnRight()
    turtle.turnRight()
    xDir, zDir = zDir, -xDir
end

function goTo(x, y, z, xd, zd)
    while depth > y do
        if turtle.up() then
            depth = depth - 1
        elseif turtle.digUp() or turtle.attackUp() then
            collect()
        else
            sleep(0.5)
        end
    end

    if xPos > x then
        while xDir ~= -1 do
            turnLeft()
        end
        while xPos > x do
            if turtle.forward() then
                xPos = xPos - 1
            elseif turtle.dig() or turtle.attack() then
                collect()
            else
                sleep(0.5)
            end
        end
    elseif xPos < x then
        while xDir ~= 1 do
            turnLeft()
        end
        while xPos < x do
            if turtle.forward() then
                xPos = xPos + 1
            elseif turtle.dig() or turtle.attack() then
                collect()
            else
                sleep(0.5)
            end
        end
    end

    if zPos > z then
        while zDir ~= -1 do
            turnLeft()
        end
        while zPos > z do
            if turtle.forward() then
                zPos = zPos - 1
            elseif turtle.dig() or turtle.attack() then
                collect()
            else
                sleep(0.5)
            end
        end
    elseif zPos < z then
        while zDir ~= 1 do
            turnLeft()
        end
        while zPos < z do
            if turtle.forward() then
                zPos = zPos + 1
            elseif turtle.dig() or turtle.attack() then
                collect()
            else
                sleep(0.5)
            end
        end
    end

    while depth < y do
        if turtle.down() then
            depth = depth + 1
        elseif turtle.digDown() or turtle.attackDown() then
            collect()
        else
            sleep(0.5)
        end
    end

    while zDir ~= zd or xDir ~= xd do
        turnLeft()
    end
end

if not refuel() then
    print("Out of Fuel")
    return
end

print("Excavating with 3-layer efficiency...")

local reseal = false
turtle.select(1)
if turtle.digDown() then
    reseal = true
end

-- Mine the starting position (3 layers)
mineThreeLayers()

local alternate = 0
local done = false
while not done do
    for n = 1, size do
        for _ = 1, size - 1 do
            if not tryForwards() then
                done = true
                break
            end
        end
        if done then
            break
        end
        if n < size then
            if math.fmod(n + alternate, 2) == 0 then
                turnLeft()
                if not tryForwards() then
                    done = true
                    break
                end
                turnLeft()
            else
                turnRight()
                if not tryForwards() then
                    done = true
                    break
                end
                turnRight()
            end
        end
    end
    if done then
        break
    end

    if size > 1 then
        if math.fmod(size, 2) == 0 then
            turnRight()
        else
            if alternate == 0 then
                turnLeft()
            else
                turnRight()
            end
            alternate = 1 - alternate
        end
    end

    -- Descend 3 layers at once for next level
    if not tryDown3() then
        done = true
        break
    end
end

print("Returning to surface...")

-- Return to where we started
goTo(0, 0, 0, 0, -1)
unload(false)
goTo(0, 0, 0, 0, 1)

-- Seal the hole
if reseal then
    turtle.placeDown()
end

print("Mined " .. collected + unloaded .. " items total.")