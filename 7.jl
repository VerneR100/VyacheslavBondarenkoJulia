using HorizonSideRobots
include("functions.jl")

r = Robot("untitled7.sit", animate = true)

function search!(robot)
    num_steps = 0
    side = Ost
    while isborder(robot, Nord)
        num_steps += 1
        along!(robot, side, num_steps)
        side = inverse(side)
    end
end

search!(r)
