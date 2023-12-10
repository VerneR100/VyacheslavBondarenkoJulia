using HorizonSideRobots
include("functions.jl")

# r = Robot(animate = true)

# function along!(stop_condition::Function, robot, side::HorizonSide)
#     while !stop_condition()
#         try_move!(robot, side) 
#     end
# end

# function snake!(stop_condition::Function, robot,
#             (move_side, next_row_side)::NTuple{2,HorizonSide}=(Ost, Nord))
#     #Робот - в (inverse(next_row_side),inverse(move_side))-углу поля
#     along!(stop_condition, robot, move_side)
#     while !stop_condition(move_side) && try_move!(robot, next_row_side)
#         move_side = inverse(move_side)
#         along!(stop_condition(move_side), robot, move_side)
#     end
# end

# function snake!(robot, (move_side, next_row_side)::NTuple{2,HorizonSide}=(Ost, Nord)) 
#     snake!(side -> isborder(robot, side), robot, (next_row_side, move_side))
#     #УТВ: Робот остановился в начале последнего ряда (последнй ряд остался не пройденным)
#     if isborder(robot, move_side) 
#         along!(robot, inverse(move_side))
#     else
#         along!(robot, move_side)
#     end
# end

# snake!(side -> !isborder(r, side), r, (Ost, Nord))