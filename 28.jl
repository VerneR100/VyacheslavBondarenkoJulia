function fibonacci_no_recursion(n)
    f_prev = f_next = 1
    while n > 0
        f_next, f_prev = f_next + f_prev, f_next
        n -= 1
    end
    return f_prev
end

function fibonacci_recursion(n)
    if n == 0 || n == 1
        return 1
    end
    return fibonacci_no_recursion(n - 1) + fibonacci_no_recursion(n - 2)
end

function memoize_fibonacci(n::Integer)
    dict = Dict{Int, Int}() # Создан пустой словарь типа Int=>Int
    dict[0] = 1
    dict[1] = 1
    function fib_recursion(n)
        if n in (0, 1)
            return dict[n]
        end
        if n - 2 in dict.keys
           f_prevprev = dict[n - 2] 
        else
            f_prevprev = fib_recursion(n - 2)
            dict[n - 2] = f_prevprev
        end
        if n - 1 in dict.keys
            f_prev = dict[n - 1]
        else
            f_prev = fib_recursion(n - 1)
            dict[n - 1] = f_prev
        end
        return f_prevprev + f_prev
    end
    fib_recursion(n)
end