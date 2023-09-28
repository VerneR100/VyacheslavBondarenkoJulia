include("robot.jl")
include("functions.jl")

# Этап декомпозиции. На этом этапе выделяются подзадачи.
# Переместить робота в юго-западный угол (и запомнить, сколько шагов 
# было сделано на юг, и сколько на запад).
# - Поставить маркеры по периметру внешней рамки поля (и снова оказаться 
# в юго-западном углу).
# - Двигаясь змейкой, искать внутреннюю перегородку на поле (остановиться 
# рядом с ней).
# - Переместиться в юго-западный угол (имеется в виду внешний угол) 
# внутренней перегородки.
# - Поставить маркеры по ее периметру.
# - Вернуться в юго-западный угол.
# - Вернуться в исходное положение.

function mark_external_internal(robot)
    back_path = move_to_angle!(robot)
    #УТВ: робот - в юго-западном углу поля
    mark_external_rect!(robot)
    #УТВ: по периметру внешней рамки стоят маркеры
    find_internal_border!(robot)
    #УТВ: с севера от робота - внутренняя прямоугольная перегородка
    move_to_internal_sudwest!(robot)
    #УТВ: робот - во внешнем юго-западном углу внутренней прямоугольной перегородки
    mark_internal_rect!(robot)
    #УТВ: по периметру внутренней прямоугольной перегородки стоят маркеры
    move_to_back!(robot, back_path)
    #УТВ: робот - в исходном положении
end

# Этап детализации. На этом этапе, следуя технологии сверху-вниз, 
# требуется приступить к реализации каждой подпрограммы.

"""
move_to_angle!(robot)
-- перемещает робота в юго-западный угол, последовательно 
перемещаясь до упора в направлениях: Sud, West, Sud
-- возвращает "обратный путь" в виде 3-элементного кортежа 
из именованных кортежей, с именами полей: side, num_steps
"""
function move_to_angle!(robot)
    return (side = Nord, num_steps = 
                numsteps_along!(robot, Sud)), 
        (side = Ost, num_steps = 
                numsteps_along!(robot, West)), 
        (side = Nord, num_steps = 
                numsteps_along!(robot, Sud))
end

function move_to_back!(robot, back_path)
    for next in back_path
        along!(robot, next.side, next.num_steps)
    end
end

function find_internal_border!(robot)
    function find_in_row(side) # - это определение локальной вспомогательной функции
        while !isborder(robot, Nord) && !isborder(robot, side)
            move!(robot, side)
        end
    end
    side = Ost
    find_in_row(side)
    while !isborder(robot, Nord)
        move!(robot, Nord)
        side = inverse(side)
        find_in_row(side)
    end
end

function move_to_internal_sudwest!(robot)
    while isborder(robot, Nord)
        move!(robot, West)
    end
end

function mark_external_rect!(robot)
    for side in (Ost, Nord, West, Sud)
        mark_along!(robot, side)
    end
end


function mark_along!(robot, side)
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
    end
end

function mark_internal_rect!(robot)
    for side in (Ost, Nord, West, Sud)
        mark_along!(robot, side, left(side))
    end
end

function mark_along!(robot, move_side, border_side) 
    while isborder(robot, border_side)
        move!(robot, move_side)
        putmarker!(robot)
    end
end

mark_external_internal(r)
