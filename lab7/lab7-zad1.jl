using Roots
using Plots
using ForwardDiff
using DataFrames
using SpecialFunctions

results = DataFrame(Method = String[], Function = String[],
                    Iteration_number = Int[], Function_calls = Int[],
                    Reached_zero = Bool[])
f1(x) = sin(x) - x / 2
f2(x) = x * exp(-x)

function f3(x) # Newton Baffler
    result = 0
    if x < 6.0
        result = (0.75 * (x - 6.25)) - 0.0125
    elseif x <= 6.50
        result = 2.00 * (x - 6.25)
    else
        result = (0.75 * (x - 6.25)) + 0.0125
    end
    result
end

f4(x) = 20.0 * x / (100.0 * x * x + 1.0) # the Repeller
f5(x) = 1.0 / ((x - 0.3) ^ 2 + 0.01) + 1.0 / ((x - 0.9) ^ 2 + 0.04) + 2.0 * x - 5.2 # the Camel
f6(x) = cos(100 * x) - 4 * erf(30 * x - 10)

# part 1
current_function = f1
plt = plot(current_function, -2.0, 2.0)
display(plt)

x = find_zero(current_function, (-3.0, 2.01), Bisection(), verbose = true)
println(iszero(current_function(x)))
println(current_function(prevfloat(x)) * current_function(x) < 0.0 || current_function(x) * current_function(nextfloat(x)) < 0.0)

D(f) = x->ForwardDiff.derivative(f, float(x))
DD(f) = x->ForwardDiff.derivative(D(f), float(x))

#x2 = find_zero((current_function, D(current_function), DD(current_function)), 0.09, Roots.Halley(), verbose = true, maxevals = 100)
#println(iszero(current_function(x2)))
#println(current_function(prevfloat(x2)) * current_function(x2) < 0.0 || current_function(x2) * current_function(nextfloat(x2)) < 0.0)

#x3 = find_zero(current_function, 0.33, Order1(), verbose = true)
#println(iszero(current_function(x3)))
#println(current_function(prevfloat(x3)) * current_function(x3) < 0.0 || current_function(x3) * current_function(nextfloat(x3)) < 0.0)
