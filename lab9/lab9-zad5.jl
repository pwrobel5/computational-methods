using Plots
using DataFrames

function trapezoid_method(f, a, b, roots)
    h = (b - a) / (roots - 1)
    result = 0
    y_prev = f(a)
    for i = 1:(roots - 1)
        y_curr = f(a + i * h)
        result = result + ((y_curr + y_prev) / 2) * h
        y_prev = y_curr
    end
    result
end

function accurate_integral_polynomial(rank, a, b)
    if(rank % 2 == 1 & a == (-1) * b)
        result = 0
    else
        result = (1 / (rank + 1)) * (b^(rank + 1) - a^(rank + 1))
    end
    result
end

a = 1
b = 4
polynomial = x -> x^4 - 2 * x^3 + 3
accurate_int = accurate_integral_polynomial(4, a, b) - 2 * accurate_integral_polynomial(3, a, b) + 3 * accurate_integral_polynomial(0, a, b)

results = DataFrame(Roots = Int[], Relative_error = Float64[])

for roots = 2:100
    approx_int = trapezoid_method(polynomial, a, b, roots)
    approx_err = abs(approx_int - accurate_int)
    relative_err = abs(approx_err / accurate_int)
    push!(results, (roots, relative_err))
end

err_plot = scatter(results[:Roots], results[:Relative_error], label = "Relative error",
            xlabel = "Trapezoid method roots", ylabel = "Relative error", title = "f(x) = x^4 - 2x^3 + 3")
display(err_plot)
