function lagrangePolynomial(x,points)
    result = 0
    for i = 1:size(points,1)
        denomin = 1
        nomin = 1
        for j = 1:size(points,1)
            if j != i
                nomin = nomin * (x - j)
                denomin = denomin * (i - j)
            end
        end
        result = result + (nomin / denomin) * points[i]
    end
    result
end

function calculateDifferenceQuotients(points)
    result = zeros(Float64, size(points, 1), size(points, 1))

    #first column: zero order difference quotients
    for i = 1:size(points, 1)
        result[i, 1] = points[i]
    end

    order = 2
    while(order <= size(points, 1))
        for i = 1:(size(points, 1) - order + 1)
            result[i, order] = (result[i + 1, order - 1] - result[i, order - 1]) / (order - 1)
        end
        order += 1
    end
    result
end

function newtonPolynomial(x, points, quotients)
    result = 0
    for i = 1:size(points,1)
        partial_res = quotients[1, i]
        j = 1
        while(j < i)
            partial_res *= (x - j)
            j += 1
        end
        result += partial_res
    end
    result
end

using Plots

n = 10
order = 2
xs = 1:1:n
A = [rand() for x in xs]

scatter(xs, A, label = "dane")

x_linspace = 1:0.01:n
lagrange_ys = [lagrangePolynomial(x, A) for x in x_linspace]
plot!(x_linspace, lagrange_ys, label = "Lagrange Polynomial")

diffQuotients = calculateDifferenceQuotients(A)
newton_ys = [newtonPolynomial(x, A, diffQuotients) for x in x_linspace]
plot!(x_linspace, newton_ys, label = "Newton Polynomial")

using Polynomials
lib_fit = polyfit(xs, A)
lib_ys = [lib_fit(x) for x in x_linspace]
plot!(x_linspace, lib_ys, label = "Polyfit Polynomial")
