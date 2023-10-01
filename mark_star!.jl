function mark_star!(robot, directions)
    putmarker!(robot)
    for side in directions
        num_steps = numsteps_mark_along!(robot, side)
        along!(robot, inverse(side), num_steps)
    end
end