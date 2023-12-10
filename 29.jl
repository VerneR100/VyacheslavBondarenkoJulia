using HorizonSideRobots
include("functions.jl")
include("structs.jl")

r = Robot("field29a.sit", animate = true)

function first_labirint_traversal!(action::Function, robot::LabirintRobot)
    if get_coords(robot.robot) in robot.passed_coords || ismarker(robot.robot)
        return
    end
    push!(robot.passed_coords, get_coords(robot.robot))
    action()
    for side in (Nord, West, Sud, Ost)
        if !isborder(robot.robot, side)
            move!(robot.robot, side)
            first_labirint_traversal!(action, robot)
            move!(robot.robot, inverse(side))
        end
    end
end

first_labirint_traversal!(() -> putmarker!(r), LabirintRobot(CoordsRobot(r, 0, 0), Set([])))

new_r = Robot("field29b.sit", animate = true)

# function second_labirint_traversal!(action::Function, robot::LabirintRobot)
#     if get_coords(robot.robot) in robot.passed_coords
#         return
#     end
#     push!(robot.passed_coords, get_coords(robot.robot))
#     action()
#     for side in (Nord, West, Sud, Ost)
#         if !isborder(robot.robot, side)
#             move!(robot.robot, side)
#             second_labirint_traversal!(action, robot)
#             move!(robot.robot, inverse(side))
#         end
#     end
# end

labirint_traversal!(() -> putmarker!(new_r), LabirintRobot(CoordsRobot(new_r, 0, 0), Set([])))