include("robot.jl")
include("functions.jl")

r = field_6()

# Переместить робота в юго-западный угол (и запомнить, сколько шагов 
# было сделано на юг, и сколько на запад).
# - Поставить маркеры по периметру внешней рамки поля (и снова оказаться 
# в юго-западном углу).
# - Вернуться в исходное положение.

function move_to_angle!(robot)
    path = Tuple{HorizonSide, Int}[]
    side = Sud
    while !isborder(robot, Sud) || !isborder(robot, West)
        pushfirst!(path, (inverse(side), num_steps_along!(robot, side)))
        if side == Sud
            side = right(side)
        else
            side = left(side)
        end
    end
    return path
end

function mark_exter_rect!(robot)
    for side in (Ost, Nord, West, Sud)
        mark_along!(robot, side)
    end
end


function mark_extermal_rect!(robot) # !!! extermal и external разные слова не перепутай
    back_path = move_to_angle!(robot)
    #УТВ: робот - в юго-западном углу поля
    mark_exter_rect!(robot)
    #УТВ: по периметру внешней рамки стоят маркеры
    move_to_back!(robot, back_path)
    #УТВ: робот - в исходном положении
end

mark_extermal_rect!(r)
