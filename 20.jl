using HorizonSideRobots
include("functions.jl")

r = Robot("untitled.sit", animate = true)

function recursion_mark_along!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        recursion_mark_along!(robot, side)
        move!(robot, inverse(side))
    else
        putmarker!(robot)
    end
end

for side in (Nord, West, Sud, Ost)
    recursion_mark_along!(r, side)
end