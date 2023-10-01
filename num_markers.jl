"""
nummarkers!(robot)
-- возвращает число клеток поля, в которых стоят маркеры 
В начале и в конце робот находится в юго-западном углу поля
"""
function num_markers!(robot)
    side = Ost # - начальное направление при перемещениях змейкой
    num_markers = num_markers!(robot, side)
    while !isborder(robot,Nord)
        move!(robot,Nord)
        side = inverse(side)
        num_markers += num_markers!(robot, side)
    end
    #УТВ: робот - где-то у северной границы поля
    along!(robot, Sud) # возвращаемое функцией значение в данном случае игнорируется
    along!(robot, West)
    return num_markers
end

"""
num_markers!(robot,side)
-- перемещает робота до упора в заданном направлении и 
ВОЗВРАЩАЕТ число встретившихся на пути маркеров
"""
function num_markers!(robot, side)
    num_markers = ismarker(robot) 
    # - фактически, это то же самое, что и num_markers = 
    Int(ismarker(r))
    while !isborder(robot, side)
        move!(robot, side)
        if ismarker(robot)
            num_markers += 1
        end
    end
    return num_markers
end

function along!(robot, side)
    num_steps = 0
    while !isborder(robot, side)
        move!(robot,side)
        num_steps += 1
    end
    return num_steps
end

print(num_markers!(r))