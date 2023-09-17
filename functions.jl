using HorizonSideRobots
import HorizonSideRobots.move!
import HorizonSideRobots.isborder

HSR = HorizonSideRobots

"""
along!(robot, direct)::Nothing
-- перемещает робота до упора в заданном направлении
"""
along!(robot, direction)::Nothing = while try_move!(robot, direction) end

"""
along!(robot, direct, num_steps)::Nothing
-- перемещает робота в заданном направлении на заданное 
число шагов (предполагается, что это возможно)
"""
function along!(robot, direction, num_steps)::Nothing
    for _ in 1:num_steps
        move!(robot, direction)
    end
end

"""
num_steps_along!(robot, direct)::Int
-- перемещает робота в заданном направлении до упора и 
возвращает число фактически сделанных им шагов
"""
function num_steps_along!(robot, direction)::Int
    num_steps = 0
    while try_move!(robot, direction)
        num_steps += 1
    end
    return num_steps
end

"""
try_move!(robot, direct)::Bool
-- делает попытку одного шага в заданном направлении и
возвращает true, в случае, если это возможно, и false - в 
противном случае (робот остается в исходном положении) 
"""
try_move!(robot, direction) = ((isborder(robot, direction)) ||
                        (move!(robot, direction); return true); return false)

"""
numsteps_along!(robot, direct, max_num_steps)::Int
-- перемещает робота в заданном направлении до упора, если 
необходимое для этого число шагов не превосходит 
max_num_steps, или на max_num_steps шагов, и возвращает 
число фактически сделанных им шагов
"""
function numsteps_along!(robot, direction, max_num_steps)::Int
    num_steps = zero(max_num_steps)
    while num_steps < max_num_steps && try_move!(robot, direction)
        num_steps += 1
    end
    return num_steps
end

"""
inverse(side::HorizonSide)::HorizonSide
-- возвращает направление, противоположное заданному 
@enum HorizonSide Nord=0, West=1, Sud=2, Ost=3
"""
function inverse(side::HorizonSide)::HorizonSide # mod - остаток от деления
    if side == Nord
        return Sud
    elseif side == Ost
        return West
    elseif side == Sud
        return Nord
    else
        return Ost
    end
end

"""
right(side::HorizonSide)::HorizonSide
-- возвращает направление, следующее по часовой стрелке по 
отношению к заданному
"""
right(side::HorizonSide)::HorizonSide = 
    HorizonSide(mod(Int(side)-1, 4))

"""
left(side::HorizonSide)::HorizonSide
-- возвращает направление, следующее против часовой стрелки 
по отношению к заданному
"""
left(side::HorizonSide)::HorizonSide = 
    HorizonSide(mod(Int(side)+1, 4))

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

"""
numsteps_mark_along!(robot, direct)::Int
-- перемещает робота в заданном направлении до упора, после 
каждого шага ставя маркер, и возвращает число фактически 
сделанных им шагов
"""
function numsteps_mark_along!(robot, direct)::Int
    num_steps = 0
    while !isborder(robot, direct)
        move!(robot, direct)
        putmarker!(robot)
        num_steps += 1
    end
    return num_steps
end

"""
mark_along!(robot, direct)::Nothing
-- перемещает робота в заданном направлении до упора, после 
каждого шага ставя маркер.
"""
function mark_along!(robot, direction)::Nothing
    while !isborder(robot, direction)
        move!(robot, direction)
        putmarker!(robot)
    end
end

# mark_row!(robot, direction) = (putmarker!(robot); markstaigth!(robot, direction)) !?

HSR.move!(robot, side::NTuple{2, HorizonSide})::Nothing = for s in side move!(robot, s) end

inverse(directions::NTuple{2, HorizonSide}) = inverse.(directions)

HSR.isborder(robot, side::NTuple{2, HorizonSide}) = isborder(robot, side[1]) || isborder(robot, side[2])