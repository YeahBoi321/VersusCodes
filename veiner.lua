--Variable definition
mined = {[0]={[0]={[0]=1}}}
coords = {x=0,y=0,z=0}
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

--Function to check if the block in a direction has been mined
function checkBlock(l_or_r)
    if l_or_r == "left" then
        block = facing - 1
    elseif l_or_r == "right" then
        block = facing + 1
    end
    if facing > 4 then
        block = 1
    elseif facing < 1 then
        block = 4
    end
    return mined[coords.x+directions[block][1]][coords.y][coords.z+directions[block][2]] == 1
end

--Just to make things more concise with my stack
function moveReversed()
    if stack[1] == "stop" then
        error()
    elseif stack[1] == "forward" then
        turtle.back()
        coords.x = coords.x - directions[facing][1]
        coords.z = coords.z - directions[facing][2]
    elseif stack[1] == "up" then
        turtle.down()
        coords.y = coords.y - 1
    elseif stack[1] == "down" then
        turtle.up()
        coords.y = coords.y + 1
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
        coords.x = coords.x + directions[facing][1]
        coords.z = coords.z + directions[facing][2]
        mined[coords.x] = {}
        mined[coords.x][coords.y] = {}
        mined[coords.x][coords.y][coords.z] = 1
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

    --Actual mining
    if stack[1] ~= "forward" then
        for i = 1,4 do
            checkAndDig()
            turtle.turnRight()
            rotate("right")
        end
    else
        if not checkBlock("right") then
            checkAndDig()
            turtle.turnRight()
            rotate("right")
            checkAndDig()
            turtle.turnLeft()
            rotate("left")
        end
        if not checkBlock("left") then
            turtle.turnLeft()
            rotate("left")
            checkAndDig()
            turtle.turnRight()
            rotate("right")
        end
    end
    block_check, block = turtle.inspectUp()
    if block_check and block.name:find(search) ~= nil then
        turtle.digUp()
        turtle.up()
        coords.y = coords.y + 1
        mined[coords.x] = {}
        mined[coords.x][coords.y] = {}
        mined[coords.x][coords.y][coords.z] = 1
        stack = {"up",stack}
        move()
    end
    block_check, block = turtle.inspectDown()
    if block_check and block.name:find(search) ~= nil then
        turtle.digDown()
        turtle.down()
        coords.y = coords.y - 1
        mined[coords.x] = {}
        mined[coords.x][coords.y] = {}
        mined[coords.x][coords.y][coords.z] = 1
        stack = {"down",stack}
        move()
    end
    moveReversed()
end

pcall(move())
