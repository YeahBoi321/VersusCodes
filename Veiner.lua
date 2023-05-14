--Variable definition
mined = {[0]={[0]=1}}
facing = 1
directions = {{1,0},{0,1},{-1,0},{0,-1}}
stack = {"stop"}
search = "mushroom"

--Function to change direction of turtle
function rotate(l_or_r)
    if l_or_r == "left" then
        facing = facing - 1
    elseif l_or_r == "right" then
        facing = facing + 1
    end
    if facing > 4 then
        facing = 1
    elseif facing < 1 then
        facing = 4
    end
end

--Just to make things more concise with my stack
function moveReversed()
    if stack[1] == "stop" then
        error()
    elseif stack[1] == "forward" then
        turtle.back()
    elseif stack[1] == "up" then
        turtle.down()
    elseif stack[1] == "down" then
        turtle.up()
    end
    stack = stack[2]
    return true
end

--Only for forward
function checkAndDig()
    local block_check, block = turtle.inspect()
    if block_check and block.name:find(search) then
        turtle.dig()
        turtle.forward()
        stack = {"forward",stack}
        move()
        return true
    end
    return false
end

function move()
    --Refuel the turtle if the fuel is low
    local fuel = turtle.getFuelLevel()
    while fuel <= 100 do
        fuel = turtle.getFuelLevel()
        turtle.refuel(1)
    end

    --actual mining
    if stack[1] ~= "forward" then
        for i = 1,4 do
            checkAndDig()
            turtle.turnRight()
        end
    else
        checkAndDig()
        turtle.turnRight()
        checkAndDig()
        turtle.turnLeft()
        turtle.turnLeft()
        checkAndDig()
        turtle.turnRight()
    end
    block_check, block = turtle.inspectUp()
    if block_check and block.name:find(search) ~= nil then
        turtle.digUp()
        turtle.up()
        stack = {"up",stack}
        move()
    end
    block_check, block = turtle.inspectDown()
    if block_check and block.name:find(search) ~= nil then
        turtle.digDown()
        turtle.down()
        stack = {"down",stack}
        move()
    end
    moveReversed()
end

pcall(move())
