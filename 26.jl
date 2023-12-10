using HorizonSideRobots
include("functions.jl")

r = Robot("field26.sit", animate = true)

function mark_labirint!(robot)
    if !ismarker(robot)
        putmarker!(robot)
        for side in (Nord, West, Sud, Ost)
            if !isborder(robot, side)
                move!(robot, side)
                mark_labirint!(robot)
                move!(robot, inverse(side))
            end
        end
    end
end

mark_labirint!(r)