include("robot.jl")
include("functions.jl")

function marking_perimeter!(robot)
    num_steps_nord = num_steps_along!(robot, Sud)
    num_steps_west = num_steps_along!(robot, Ost)
    for side in 0:3
        mark_along!(robot, HorizonSide(side))
    end
    along!(robot, Nord, num_steps_nord)
    along!(robot, West, num_steps_west)
end

marking_perimeter!(r)