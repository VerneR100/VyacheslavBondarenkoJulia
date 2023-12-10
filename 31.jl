using HorizonSideRobots
include("functions.jl")
include("structs.jl")


### 1
r = Robot("field26.sit", animate = true)

labirint_traversal!(() -> true, DiagonalRobot(CoordsRobot(r, 0, 0), Set([])))


### 2
another_r = Robot("field30.sit", animate = true)

function mark_cross_x!(robot::DiagonalRobot)
    side = 
end