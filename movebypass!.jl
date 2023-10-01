# - Двигаясь вдоль перегородки "челноком", т.е. с переменой направления, 
# найти проход и подсчитать величину смещения от исходного положения.
# - Сделать шаг в заданном направлении(сводится к одной команде робота).
# - Переместиться в клетку, соседнюю с исходным положением (с другой стороны перегородки).

function movebypass!(robot, move_side)
    result = find_pass!(robot, move_side)
    move!(robot, move_side)
    along!(robot, result.back_side, result.num_steps)
end

"""
find_pass!(robot, border_side) 
-- ищет проход в перегородке, рядом с которой находится 
робот, и возвращает именованный кортеж с полями: back_size, 
num_steps (эти значения определяют координаты начального 
положение робота относительно его текущего положения)
"""
function find_pass!(robot, border_side)
    num_steps = 0
    bypass_side = left(border_side)
    while isborder(robot, border_side)
        num_steps += 1
        along!(robot, bypass_side, num_steps)
        bypass_side = inverse(bypass_side)
    end
    if num_steps % 2 == 0
        return (back_side = bypass_side, num_steps = num_steps//2)
    end
    return (back_side = bypass_side, num_steps = num_steps//2 + 1) # именованный кортеж
end

movebypass!(r, Ost)