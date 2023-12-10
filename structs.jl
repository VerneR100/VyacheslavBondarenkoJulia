using HorizonSideRobots
HSR = HorizonSideRobots
include("functions.jl")


### AbstractRobot
abstract type AbstractRobot end

HSR.move!(robot::AbstractRobot, side) = move!(get_base_robot(robot), side)

function HorizonSideRobots.move!(robot::AbstractRobot, side::NTuple{2, HorizonSide})
    move!(robot, side[1])
    move!(robot, side[2])
end

function move!(robot::AbstractRobot, side::NTuple{N, HorizonSide} where N)
    for s in side
        move!(get_base_robot(robot), s)
    end
end

HSR.isborder(robot::AbstractRobot, side) = isborder(get_base_robot(robot), side)

function HorizonSideRobots.isborder(robot::AbstractRobot, side::NTuple{2, HorizonSide})
    if !isborder(robot, side[1])
        move!(robot, side[1])
        if !isborder(robot, side[2])
            move!(robot, inverse(side[1]))
            return false
        else
            move!(robot, inverse(side[1]))
        end
    end
    return true
end

HSR.putmarker!(robot::AbstractRobot) = putmarker!(get_base_robot(robot))

HSR.ismarker(robot::AbstractRobot) = ismarker(get_base_robot(robot))

HSR.temperature(robot::AbstractRobot) = temperature(get_base_robot(robot))



### AbstractCoordsRobot
abstract type AbstractCoordsRobot <: AbstractRobot end

function HSR.move!(robot::AbstractCoordsRobot, side::HorizonSide)
    move!(get_base_robot(robot), side)
    x, y = get_coords(robot)
    if side == Nord
        set_coords(robot, x, y+1)
    elseif side == Sud
        set_coords(robot, x, y-1)
    elseif side == Ost
        set_coords(robot, x+1, y)
    else
        set_coords(robot, x-1, y)
    end 
end

function set_coords(robot::AbstractRobot, x::Int, y::Int)
    robot.x = x
    robot.y = y
end

### AbstractLabirintRobot
abstract type AbstractLabirintRobot <: AbstractCoordsRobot end

get_base_robot(robot::AbstractLabirintRobot) = robot.robot

get_coords(robot::AbstractLabirintRobot) = get_coords(get_base_robot(robot))

get_passed_coords(robot::AbstractLabirintRobot) = robot.passed_coords

set_passed_coords(robot::AbstractLabirintRobot) = push!(robot.passed_coords, get_coords(robot))

set_coords(robot::AbstractLabirintRobot, x::Int, y::Int) = set_coords(get_base_robot(robot), x, y)

function labirint_traversal!(action::Function, robot::AbstractLabirintRobot)
    if get_coords(robot) in get_passed_coords(robot)
        return
    end
    set_passed_coords(robot)
    action()
    for side in (Nord, West, Sud, Ost)
        if !isborder(robot, side)
            move!(robot, side)
            labirint_traversal!(action, robot)
            move!(robot, inverse(side))
        end
    end
end


### CoordsRobot
mutable struct CoordsRobot <: AbstractCoordsRobot
    robot::Robot
    x::Int
    y::Int
end

get_base_robot(robot::CoordsRobot) = robot.robot

get_coords(robot::CoordsRobot) = (robot.x, robot.y)

function set_coords(robot::CoordsRobot, x::Int, y::Int)
    robot.x = x
    robot.y = y
end


### PutmarkersRobot
struct PutmarkersRobot <: AbstractRobot
    robot::Robot
end

function HSR.move!(robot::PutmarkersRobot, side)
    #     Однако, для вызова унаследованной от AbstractCoordsRobot функции
    # move! здесь необходимо было воспользоваться специальной встроенной 
    # функцией invoke, которая в качестве аргументов получает имя взываемой
    # функции (значение функционального типа), кортеж типов её аргументов и сами 
    # аргументы. В результате этого будет вызван тот метод функции, которому
    # соответствует данный кортеж типов (определяющий, так называемую, сигнатуру 
    # функции). Необходимость воспользоваться функцией invoke обусловлена тем,
    # что необходимо вызвать унаследованный метод функции move! из тела 
    # определяемого нового метода этой функции (без этого такой вызов оказался бы 
    # рекурсивным)
    invoke(move!, (AbstractRobot, Any), robot, side)
    putmarker!(robot)
end


### RectBorderRobot
struct RectBorderRobot{TypeRobot} <: AbstractRobot
    robot::TypeRobot
end

function try_move!(robot::RectBorderRobot, side::HorizonSide)
    ortogonal_side = left(side)
    back_side = inverse(ortogonal_side)
    num_steps = 0
    while isborder(robot, side) == true &&
                isborder(robot, ortogonal_side) == false
        move!(robot, ortogonal_side)
        num_steps += 1
    end
    if isborder(robot, side) == true
        along!(robot, back_side, num_steps)
        return false
    end
    move!(robot, side)
    while isborder(robot, back_side)
        move!(robot, side)
    end
    along!(robot, back_side, num_steps)
    return true
end

"""
Стоит внимательно следить за тем чтобы направление выглядели следующим образом: 
(Nord, Ost), (Nord, West), (Sud, Ost), (Sud, West)
"""
function try_move!(robot::RectBorderRobot, side::NTuple{2, HorizonSide})
    robot = CoordsRobot(get_base_robot(robot), 0, 0)
    function stop_condition(robot::CoordsRobot)
        x, y = get_coords(robot)
        if side in ((Nord, Ost), (Sud, West))
            return x == y
        else
            return x == -y
        end
    end
    if isborder(robot, side[1])
        ortogonal_side = left(side[1])
    elseif isborder(robot, side[2])
        ortogonal_side = left(side[2])
    else
        if !isborder(robot, side)
            move!(robot, side)
            return true
        else
            ortogonal_side = side[1]
        end
    end
    move!(robot, ortogonal_side)
    while !stop_condition(robot)
        while isborder(robot, right(ortogonal_side)) && !isborder(robot, ortogonal_side)
            move!(robot, ortogonal_side)
            if stop_condition(robot)
                return true
            end
        end
        if isborder(robot, right(ortogonal_side))
            along!(() -> get_coords(robot) == (0, 0), robot, inverse(ortogonal_side))
            return false
        end
        ortogonal_side = right(ortogonal_side)
        move!(robot, ortogonal_side)
    end
    return true
end

get_base_robot(robot::RectBorderRobot) = get_base_robot(robot.robot)

along!(robot::RectBorderRobot, side::HorizonSide) = while try_move!(robot, side) end

get_base_robot(robot::Robot) = robot


### CountMarkerRobot
struct CountMarkerRobot <: AbstractRobot
    robot::Robot
    count :: Integer
end

get_base_robot(robot::CountMarkerRobot) = robot.robot

function HSR.move!(robot::CountMarkerRobot)
    move!(robot.robot, side)
    if ismarker(robot)
        robot.count += 1
    end
end


### LabirintRobot
struct LabirintRobot <: AbstractLabirintRobot
    robot::CoordsRobot
    passed_coords::Set{NTuple{2, Int}}
    # LabirintRobot(robot) = 
    #         new(CoordsRobot(get_base_robot(robot), get_coords(robot)[1], get_coords(robot)[2]), Set{NTuple{2, Int}}())
end

# get_base_robot(robot::LabirintRobot) = robot.robot

# get_passed_coords(robot::LabirintRobot) = robot.passed_coords

# function labirint_traversal!(action::Function, robot::LabirintRobot)
#     if get_coords(robot.robot) in robot.passed_coords
#         return
#     end
#     push!(robot.passed_coords, get_coords(robot.robot))
#     action()
#     for side in (Nord, West, Sud, Ost)
#         if !isborder(robot.robot, side)
#             move!(robot.robot, side)
#             labirint_traversal!(action, robot)
#             move!(robot.robot, inverse(side))
#         end
#     end
# end


### ChessRobot
struct ChessRobot <: AbstractLabirintRobot
    robot::CoordsRobot
    passed_coords::Set{NTuple{2, Int}}
end

# get_base_robot(robot::ChessRobot) = robot.robot

# get_passed_coords(robot::ChessRobot) = robot.passed_coords

# set_coords(robot::ChessRobot) = push!(robot.passed_coords, get_coords(get_base_robot(robot)))

function HSR.move!(robot::ChessRobot, side::HorizonSide)
    move!(get_base_robot(robot), side)
    x, y = get_coords(get_base_robot(robot))
    if !ismarker(get_base_robot(robot))
        if (x + y) % 2 == 0 
            putmarker!(get_base_robot(robot))
        end
    end
end

# function labirint_traversal!(action::Function, robot::ChessRobot)
#     if get_coords(get_base_robot(robot)) in get_passed_coords(robot)
#         return
#     end
#     set_coords(robot)
#     action()
#     for side in (Nord, West, Sud, Ost)
#         if !isborder(get_base_robot(robot), side)
#             move!(robot, side)
#             labirint_traversal!(action, robot)
#             move!(robot, inverse(side))
#         end
#     end
# end

### DiagonalRobot
struct DiagonalRobot <: AbstractLabirintRobot
    robot::CoordsRobot
    passed_coords::Set{NTuple{2, Int}}
end

function HSR.move!(robot::DiagonalRobot, side::HorizonSide)
    move!(get_base_robot(robot), side)
    if !ismarker(robot)
        x, y = get_coords(robot)
        if x == y || x == -y
            putmarker!(robot)
        end
    end
end