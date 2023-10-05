using HorizonSideRobots
include("functions.jl")

r = Robot("untitled12.sit", animate = true)

function counting_partitions_in_row!(robot, side)
    # state = 0 пока не увидели не одну перегородку
    # state = 1 увидели дыру в перегородке или её конец
    # state = 2 самое начало перегородки или её продолжение
    state = 0
    num_partitions = 0
    while !isborder(robot, side)
        move!(robot, side)
        if state == 0 && isborder(robot, Nord)
            state = 2
        elseif  state == 1 && !isborder(robot, Nord)
            num_partitions += 1
            state = 0
        elseif  state == 1 && isborder(robot, Nord)
            state = 2
        elseif state == 2 && !isborder(robot, Nord)
            state = 1
        end
    end
    if state == 1
        num_partitions += 1
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