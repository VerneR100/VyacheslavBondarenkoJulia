using HorizonSideRobots
include("functions.jl")

r = Robot("untitled9.sit", animate = true)

"""
- Робот перемещается в юго-западный угол, попудно считет шаги
- Если число сделанных шагов робота чётно, то робот ставит маркер в начальную клетку(state = 1), инече не ставит и начинает маркировку со второй клетки(state = 0)
- Если роботу стоит начать маркировать поле с текущей клетки то state = 1, иначе state = 0
- Робот перемещается в заданном направлении(Ost or West) и ставит маркеры в шахматном порядке
"""

"""
mark_chess_along!(robot, side, state)
-- Перемещает робота в заданном направлении и попутно расставляет маркеры в шахматном порядке
"""
function mark_chess_along!(robot, side, state)
    while !isborder(robot, side)
        if state == 1
            putmarker!(robot)
        end
        state = (state + 1) % 2
        move!(robot, side)
    end
    return state
end

function chess_field!(robot)
    putmarker!(robot)
    #УТВ: Исходная позиция робота замаркирована
    Nord_num_steps = numsteps_along!(robot, Sud)
    Ost_num_steps = numsteps_along!(robot, West)
    num_steps = Nord_num_steps + Ost_num_steps
    #УТВ: Робот находится в юго-западном углу поля
    if num_steps % 2 == 0
        state = 1
    else
        state = 0
    end
    #УТВ: state - хранит в себе информацию о необходимости ставить маркер для робота
    side = Ost
    while !isborder(robot, Nord)
        state = mark_chess_along!(robot, side, state)
        if state == 1
            putmarker!(robot)
            move!(robot, Nord)
        else
            move!(robot, Nord)
        end
        state = (state + 1) % 2
        side = inverse(side)
    end
    mark_chess_along!(robot, side, state)
    putmarker!(robot)
    along!(robot, (Sud, West))
    along!(robot, Nord, Nord_num_steps)
    along!(robot, Ost, Ost_num_steps)
end

chess_field!(r)