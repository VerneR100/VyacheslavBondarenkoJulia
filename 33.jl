using HorizonSideRobots
include("functions.jl")
include("structs.jl")

r = Robot("field30.sit", animate = true)

function max_temperature!(robot::Robot)
    max_temp = temperature(robot)
    labirint_traversal!(LabirintRobot(CoordsRobot(robot, 0, 0), Set([]))) do
        current = temperature(robot)
        if current > max_temp
            max_temp = current
        end
    end
    return max_temp
end

function max_temperature_stop!(robot::Robot)
    max_temp = max_temperature!(robot)
    try
        labirint_traversal!(LabirintRobot(CoordsRobot(robot, 0 , 0), Set([]))) do 
            if temperature(robot) == max_temp
                throw("Max temperature in labirint!!!")
            end
        end
    catch 
        return max_temp
    end
end

max_temperature_stop!(r)