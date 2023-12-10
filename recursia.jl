using HorizonSideRobots
include("functions.jl")

r = Robot("untitled.sit", animate = true)

function tolim!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
    end
end

function marklim!(robot, side)
    if isborder(robot, side)
        putmarker!(robot)
    else
        move!(robot, side)
        marklim!(robot, side)
    end
end

function step!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
    else
        move!(robot, left(side))
        step!(robot, side)
        move!(robot, right(side))
    end
end

function dobledist!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        dobledist!(robot, side)
        move!(robot, inverse(side))
    end
end


"""?????????????"""
function to_symmetric_position!(robot, side)
    if isborder(robot, side)
        tolim!(robot, side)
    else
        move!(robot,side)
        to_symmetric_position!(robot, side)
        move!(robot, inverse(side))
    end
end

"""
Бля реально работает
"""
function halfdist!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        no_delayed_action!(robot, side)
        move!(robot, inverse(side))
    end
end

function no_delayed_action!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        halfdist!(robot, side)
    end
end

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