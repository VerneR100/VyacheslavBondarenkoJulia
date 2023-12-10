using HorizonSideRobots
include("functions.jl")
include("structs.jl")

r = Robot("field30.sit", animate = true)
chess_robot = ChessRobot(CoordsRobot(r, 0, 0), Set([]))

labirint_traversal!(() -> true, chess_robot)