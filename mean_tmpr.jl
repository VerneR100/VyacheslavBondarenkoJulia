"""
function mean_tmpr(robot)
-- возвращает среднюю температуру замаркированных клеток 
поля (без внутренних перегородок)
Перед началом и в конце робот находится в юго-западном углу.
"""
function mean_tmpr(robot)
    side = Ost
    num_sum = collect(numsum_row!(robot, side))
    while !isborder(robot, Nord)
        side = inverse(side)
        move!(robot, Nord)
        num_sum .+= numsum_row!(robot, side)
    end
    return num_sum[2]/num_sum[1]
end

function numsum_row!(robot, side)
    num_markers, sum_tmpr = 0, 0
    while !isborder(robot, side)
        move!(robot, side)
        if ismarker(robot)
            num_markers += 1
            sum_tmpr += temperature(robot)
        end
    end
    return num_markers, sum_tmpr
end