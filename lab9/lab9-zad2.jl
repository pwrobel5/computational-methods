using QuadGK
using Polynomials

k = 3

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

function accurate_integral_polynomial(rank)
    if(rank % 2 == 1)
        result = 0
    else
        result = (1 / (rank + 1)) * 2
    end
    result
end

function approximate_integral(f)
    (xp, a) = gauss(Float64, k)
    result = sum(a .* f.(xp))
    result
end

println(string("Gauss points = ", k))
println("")

for i = 1:10
    approx_int = approximate_integral(x -> polyval(polynomial_n(i), x))
    accurate_int = accurate_integral_polynomial(i)
    println(string("i = ", i))
    println(string("accurate integral = ", accurate_int))
    println(string("approximate integral = ", approx_int))
    println(string("error = ", abs(accurate_int - approx_int)))
    println("")
end
