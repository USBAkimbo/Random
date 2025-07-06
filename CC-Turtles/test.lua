-- Refuel using collected wood
for i = 1, 16 do
    turtle.select(i)
    local itemDetail = turtle.getItemDetail(i)
    if itemDetail and string.find(itemDetail.name, "log") then -- Filter for logs
        turtle.refuel()
    end
end
