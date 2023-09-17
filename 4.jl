include("robot.jl")
include("functions.jl")

function mark_star!(robot)
    putmarker!(robot)
    for side in ((Nord, West), (Nord, Ost), (Sud, West), (Sud, Ost))
        f(robot, side)
    end
end


function f(robot, side::NTuple{2, HorizonSide})
    num_steps = 0
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
        num_steps += 1
    end
    side = inverse(side)
    for s in side
        along!(robot, s, num_steps)
    end
end

mark_star!(r)