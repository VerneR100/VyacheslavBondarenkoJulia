using HorizonSideRobots
include("functions.jl")
include("structs.jl")

r = Robot("untitled9.sit", animate = true)

coords_robot = CoordsRobot(r, 0, 0)

function change_state(state)
    return (state + 1) % 2
end

function along!(stop_condition::Function, robot, side, state)::Int # Переопределили функцию along! спецально для задачи 13
    while !stop_condition()
        if state == 1
            putmarker!(robot)
        end
        state = change_state(state)
        move!(robot, side)
    end
    return state
end

function snake!(stop_condition::Function, robot, state::Int,
    (move_side, next_row_side)::NTuple{2, HorizonSide}=(Ost, Nord))
    inside_move_side = move_side # сооздаём купию для использования внутри функции, чтобы не изменять внешнюю переменную
    while !stop_condition(inside_move_side) && !stop_condition(next_row_side)
        state = along!(() -> isborder(robot, inside_move_side), robot, inside_move_side, state)
        inside_move_side = inverse(inside_move_side)
        if !stop_condition(next_row_side)
            if state == 1
                putmarker!(robot)
            end
            state = change_state(state)
            move!(robot, next_row_side)
        end
    end
    state = along!(() -> isborder(robot, inside_move_side), robot, inside_move_side, state)
    if state == 1
        putmarker!(robot)
    end
end

function chess_field!(robot)
    path = move_to_angle!(robot, (West, Sud))
    state = 0 # переменная состояния показывающая необходимость ставить маркер в Юго-западном углу
    if (path[1][2] + path[2][2]) % 2 == 0 # Если state = 0 стоит начинать закрашивать поле с пустой клетки, иначе, если state = 1 то начинаем шахмотное поле с закрашенной клетки
        state = 1
    end
    snake!((side) -> isborder(robot, side), robot, state)
    along!(robot, Sud)
    along!(robot, West)
    move_to_back!(robot, path)
end

chess_field!(coords_robot)