include("robot.jl")
include("functions.jl")


function marking_field!(robot)
    num_steps_nord = num_steps_along!(robot, Sud)
    num_steps_ost = num_steps_along!(robot, West)
    side = Ost
    putmarker!(robot)
    while true
        mark_along!(robot, side)
        move!(robot, Nord)
        putmarker!(robot)
        side = inverse(side)
        if isborder(robot, Nord)
            mark_along!(robot, side)
            break
        end
    end
    along!(robot, Sud)
    along!(robot, West)
    along!(robot, Nord, num_steps_nord)
    along!(robot, Ost, num_steps_ost)
end

marking_field!(r)