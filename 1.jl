include("robot.jl")
include("functions.jl")

"""
ДАНО: робот находится в произвольной клетке ограниченного 
прямоугольного поля (без внутренних перегородок и маркеров).
РЕЗУЛЬТАТ: робот - в исходном положении в центре из прямого креста из 
маркеров.
"""
function mark_cross!(robot)::Nothing
    putmarker!(robot)
    for side in 0:3
        line_markings!(robot, HorizonSide(side))
    end
end

function line_markings!(robot, direction)
    local num_steps = 0
    while !isborder(robot, direction)
        move!(robot, direction)
        num_steps += 1
        putmarker!(robot)
    end
    along!(robot, inverse(direction), num_steps)
end

print(mark_cross!(r))