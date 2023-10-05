using HorizonSideRobots
include("functions.jl")

r = Robot("untitled10.sit", animate = true)

"""
- Робот оказывается в юго-западном углу поля сохрання свой путь
- Робот перемещается в заданном направлении и закрашивает клетки в шахмотном порядке
(переменая state хранит в себе информацию о необходимости закрашивания данной клетки)
(если state == 0 то данную клетку не стоит закрашивать, так как предыдущая была уже закрашена
если state == 1 то данную клетку нужно закрасить, так как предыдущая не была закрашена или робот в начале клеточного поля)
- Робот поднимается на следующий уровень поля вверх и закрашивает поля пока свододно сверху
- Робот возращается в юго-западный угол поля
- Робот возращается в исходное положение
"""

function check_side!(robot, N, side) # Проверка влезает ли ещё одни квадрат
    flag = true
    num_steps = 0
    for _ in 1:(N-1)
        if isborder(robot, side)
            flag = false
            break
        end
        move!(robot, side)
        num_steps += 1
    end
    if flag
        along!(robot, inverse(side), N-1)
    else
        along!(robot, inverse(side), num_steps)
    end
    return flag
end

"""
num_steps_mark_along!(robot, direction, num_steps)
-- строит полосу из маркеров длиною в num_steps шагов в заданном направлении
"""
function num_steps_mark_along!(robot, direction, num_steps) # Специальная функция для putmarker!(robot, N)
    putmarker!(robot)
    for _ in 1:(num_steps-1)
        move!(robot, direction)
        putmarker!(robot)
    end
end

"""
NxN_marker!(robot, N::Int)::Nothing
-- функция строт квадрат размером NxN из маркеров
предполагается что данный квадрат влезает в поле
и что робот в конце останется в юго-западном углу этого квадрата
"""
function NxN_marker_right!(robot, N::Int)::Nothing
    side = Ost
    for n in 1:N
        num_steps_mark_along!(robot, side, N)
        side = inverse(side)
        if n != N
            move!(robot, Nord)
        end
    end
    along!(robot, Sud, N-1)
    if inverse(side) == West
        along!(robot, Ost, N-1)
    end
end

function NxN_marker_left!(robot, N::Int)::Nothing
    side = West
    for n in 1:N
        num_steps_mark_along!(robot, side, N)
        side = inverse(side)
        if n != N
            move!(robot, Nord)
        end
    end
    along!(robot, Sud, N-1)
    if inverse(side) == Ost
        along!(robot, West, N-1)
    end
end

"""
mark_chess_field_N_along!(robot, N, state, side)
-- Данная функция должна моставить маркерованные квадраты размером NxN в шахмотном порядке
-- на прямой в направлении side до тех пор пока не закончится место на прямой для хотя бы для ещё одного квадрата
-- предполагается что квадраты влезают по высоте
"""
function mark_chess_field_N_along!(robot, N, state, side)
    while check_side!(robot, N + 1, side)
        if state == 1
            if side == Ost
                NxN_marker_right!(robot, N)
            else
                NxN_marker_left!(robot, N)
            end
            move!(robot, side)
        else
            along!(robot, side, N)
        end
        state = (state + 1) % 2
    end
    if check_side!(robot, N, side) && state == 1
        if side == Ost
            NxN_marker_right!(robot, N)
        else
            NxN_marker_left!(robot, N)
        end
        state = 0
    elseif check_side!(robot, N, side) && state == 0
        along!(robot, side, N-1)
        state = 1
    else
        move!(robot, inverse(side))
    end
    return state
end

function creating_chess_field!(robot, N)
    side = Ost
    state = 1
    while check_side!(robot, N + 1, Nord)
        state = mark_chess_field_N_along!(robot, N, state, side)
        side = inverse(side)
        along!(robot, Nord, N)
    end
    if check_side!(robot, N, Nord)
        mark_chess_field_N_along!(robot, N, state, side)
    end
    along!(robot, Sud)
    along!(robot, West)
end

function chess_field_N!(robot, N)
    path = move_to_angle!(robot, (Sud, West))
    #УТВ: робот в юго-западном углу поля. path - путь обратно в исходное положение
    creating_chess_field!(robot, N)
    #УТВ: поле закрашено в шахматном порядке клетками NxN
    move_to_back!(robot, path)
    #УТВ: робот в исходном положении
end

chess_field_N!(r, 2)