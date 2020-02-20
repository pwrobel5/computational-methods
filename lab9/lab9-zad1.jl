using Polynomials
using Plots
using QuadGK

function Legendre_polynomial(rank)
    if(rank == 0)
        result = Poly([1])
    elseif(rank == 1)
        result = Poly([0,1])
    else
        prev_coeffs = coeffs(Legendre_polynomial(rank - 1))
        coeffs_for_current = vcat([0], prev_coeffs)
        result = (2 * rank - 1) / (rank) * Poly(coeffs_for_current) - (rank - 1) / (rank) * Legendre_polynomial(rank - 2)
    end
    result
end

x_linspace = -1.0:0.01:1.0
plt = plot(polyval(Legendre_polynomial(0), x_linspace), label = "rank 0")

for i = 1:6
    plot!(polyval(Legendre_polynomial(i), x_linspace), label = string("rank ", i))
end

display(plt)

for i = 2:4
    (xp, a) = gauss(Float64, i)
    legendre_roots = sort(roots(Legendre_polynomial(i)))
    diff_array = [xp[i] - legendre_roots[i] for i in 1:length(xp)]
    println(string("i = ", i))
    println(string("gauss roots: ", xp))
    println(string("Legendre polynomial roots: ", legendre_roots))
    println(string("Differences: ", diff_array))
    println("")
end
