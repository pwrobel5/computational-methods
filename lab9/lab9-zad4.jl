using QuadGK
using Polynomials

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

a = -3
b = 4
println(string("Range: a = ", a, " b = ", b))
println("Polynomial f(x) = x^4")
(approx_int, approx_error) = quadgk(x -> polyval(polynomial_n(4), x), a, b)
accurate_int = accurate_integral_polynomial(4, a, b)
println(string("accurate integral = ", accurate_int))
println(string("approximate integral = ", approx_int))
println(string("maximal absolute error = ", approx_error))
println("")

ag = -Inf
bg = Inf
println("Gauss function f(x) = 1 / sqrt(2pi) * exp(-x^2 / 2)")
(approx_int, approx_error) = quadgk(x -> (1 / sqrt(2 * pi)) * exp((-1 / 2) * x^2), ag, bg)
println(string("approximate integral = ", approx_int))
println(string("maximal absolute error = ", approx_error))
println("")
