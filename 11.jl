using HorizonSideRobots
include("functions.jl")

r = Robot("untitled11.sit", animate = true)

function counting_partitions_in_row!(robot, side)
    state = 0
    num_partitions = 0
    while !isborder(robot, side)
        move!(robot, side)
        if state == 0 && isborder(robot, Nord)
            state = 1
        elseif  state == 1 && !isborder(robot, Nord)
            num_partitions += 1
            state = 0
        end
    end
    return num_partitions
end

function number_of_partitions!(robot)
    path = move_to_angle!(robot, (Sud, West))
    num_partitions = 0
    side = Ost
    while !isborder(robot, Nord)
        num_partitions += counting_partitions_in_row!(robot, side)
        side = inverse(side)
        move!(robot, Nord)
    end
    num_partitions += counting_partitions_in_row!(robot, side)    
    along!(robot, Sud)
    along!(robot, West)
    move_to_back!(robot, path)
    return num_partitions
end

print(number_of_partitions!(r))