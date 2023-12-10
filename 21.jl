using HorizonSideRobots
include("functions.jl")

r = Robot("field21.sit", animate = true)

function recursion_try_move!(robot, side)
    if !try_move!(robot, side)
        move!(robot, left(side))
        recursion_try_move!(robot, side)
        move!(robot, right(side))
    end
end

recursion_try_move!(r, Ost)