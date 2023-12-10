
function show_typetree(type::Type, level = 0)
    println(" " ^ level, type)
    for t in subtypes(type)
        show_typetree(t, level + 3)
    end
end

show_typetree(Integer, 4)