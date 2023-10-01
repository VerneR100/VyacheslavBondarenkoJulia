using HorizonSideRobots
include("functions.jl")

r = Robot("untitled8.sit", animate = true)

function search!(robot)
    num_steps = 2
    side = Nord
    while !ismarker(robot)
        along_search!(robot, side, num_steps//2)
        num_steps += 1
        side = left(side)
    end
end

search!(r)
