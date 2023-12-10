function summa(array::Vector, s = 0)
    if length(array) == 0
        return s
    end
    return summa(array[1:end-1], s + array[end])
end

print(summa([1, 2, 3, 4, 5, 6, 7, 8, 9]))
print("\t")
print(sum([1, 2, 3, 4, 5, 6, 7, 8, 9]))