using HorizonSideRobots
include("functions.jl")
include("structs.jl")

r = Robot(animate = true)


function spiral!(stop_condition::Function, robot)
    n = 2
    side = Nord
    while !stop_condition()
        num_steps_along!(stop_condition, robot, side, div(n, 2))
        n += 1
        side = right(side)
    end
end

spiral!(() -> ismarker(r), r)