using HorizonSideRobots
include("functions.jl")
include("structs.jl")

r = Robot("untitled18.2.sit", animate = true)
rect_border_r = RectBorderRobot{Robot}(r)

# функция try_move! для перегородок полубесконечной длины
function try_move!(robot::RectBorderRobot, side::HorizonSide)
    num_steps, ortogonal_side = shuttle!(() -> !isborder(robot, side), robot, side)
    move!(robot, side)
    along!(robot, ortogonal_side, div(num_steps, 2))
end

spiral!(() -> ismarker(rect_border_r.robot), rect_border_r)

# Можно оптимзированть если добавить в along! и shuttle!() аргумент stop_condition = () -> ismarker(robot)