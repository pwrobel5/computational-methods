using QuadGK
using Polynomials

k = 10

function polynomial_n(rank)
    coeffs = [1]
    if(rank == 0)
        result = Poly(coeffs)
    else
        zeros = [0 for i in 1:rank]
        coeffs = vcat(zeros, coeffs)
        result = Poly(coeffs)
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

function approx_integral_func_a_b(f, a, b)
    (xp, c) = gauss(Float64, k)
    factor = c * ((b - a) / 2)
    result = sum(factor .* f.(((b + a) / 2) .+ ((b - a) / 2) .* xp))
    result
end

function accurate_integral_exp(alpha, a, b)
    result = (1 / alpha) * (exp(alpha * b) - exp(alpha * a))
    result
end

function accurate_integral_sin(a, b)
    if(a == (-1) * b)
        result = 0
    else
        result = (cos(a) - cos(b))
    end
    result
end

a = -10
b = 15

println(string("Gauss points = ", k))
println(string("range: a = ", a, " b = ", b))
println("")

println("Polynomials from 1st to 5th order")
for i = 1:5
    approx_int = approx_integral_func_a_b(x -> polyval(polynomial_n(i), x), a, b)
    accurate_int = accurate_integral_polynomial(i, a, b)
    approx_error = abs(accurate_int - approx_int)
    println(string("i = ", i))
    println(string("accurate integral = ", accurate_int))
    println(string("approximate integral = ", approx_int))
    println(string("error = ", approx_error))
    if(accurate_int != 0)
        println(string("relative error = ", approx_error / accurate_int))
    else
        println("relative error = 0")
    end
    println("")
end

println("Function f(x) = exp(-x)")
approx_int = approx_integral_func_a_b(x -> exp(-1 * x), a, b)
accurate_int = accurate_integral_exp(-1, a, b)
approx_error = abs(accurate_int - approx_int)
println(string("approximate integral = ", approx_int))
println(string("accurate integral = ", accurate_int))
println(string("error = ", approx_error))
println(string("relative error = ", approx_error / accurate_int))
println("")

println("Function f(x) = sin(x)")
approx_int = approx_integral_func_a_b(x -> sin(x), a, b)
accurate_int = accurate_integral_sin(a, b)
approx_error = abs(accurate_int - approx_int)
println(string("approximate integral = ", approx_int))
println(string("accurate integral = ", accurate_int))
println(string("error = ", approx_error))
println(string("relative error = ", abs(approx_error / accurate_int)))
println("")
