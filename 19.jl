using HorizonSideRobots
include("functions.jl")

r = Robot("untitled19.sit", animate = true)

function recursion_along!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        recursion_along!(robot, side)
        move!(robot, inverse(side))
    end
end

for side in (Nord, Sud, West, Ost)
    recursion_along!(r, side)
end