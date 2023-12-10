using HorizonSideRobots
include("functions.jl")

r = Robot("field23.sit", animate = true)

"""Перемещает робота до упора в заданном направлении"""
function recursion_along!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        recursion_along!(robot, side)
    end
end

function to_symmetric_position!(robot, side)
    if !isborder(robot, inverse(side))
        move!(robot, inverse(side))
        to_symmetric_position!(robot, side)
        move!(robot, inverse(side))
    else
        recursion_along!(robot, side)
    end
end

to_symmetric_position!(r, West)