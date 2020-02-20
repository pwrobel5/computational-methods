using DataFrames
using Statistics
using Plots
using Polynomials

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

results = DataFrame(Points = Int[], Measure = Int[],
                    Time_Lagrange = Float64[], Time_Newton = Float64[],
                    Time_Lib_function = Float64[])

for points = 2:20:1200
    for measure = 1:1:10
        xs = 1:1:points
        A = [rand() for x in xs]
        x_avg = (points - 1) / 2 + 1
        push!(results, (points, measure, (@elapsed lagrangePolynomial(x_avg, A)),
            (@elapsed newtonPolynomial(x_avg, A, calculateDifferenceQuotients(A))),
            (@elapsed (polyfit(xs, A)(x_avg)))))
    end
end

lagrange_data = by(results, :Points, Average_time = :Time_Lagrange => mean, Standard_deviation = :Time_Lagrange => std)
scatter(lagrange_data[:Points], lagrange_data[:Average_time],
    colour = [:red], yerr = lagrange_data[:Standard_deviation],
    xlabel = "Points number", ylabel = "Average time [s]", label = "Lagrange interpolation")

newton_data = by(results, :Points, Average_time = :Time_Newton => mean, Standard_deviation = :Time_Newton => std)
scatter!(newton_data[:Points], newton_data[:Average_time],
    colour = [:blue], yerr = newton_data[:Standard_deviation],
    label = "Newton interpolation")

library_func_data = by(results, :Points, Average_time = :Time_Lib_function => mean, Standard_deviation = :Time_Lib_function => std)
scatter!(library_func_data[:Points], library_func_data[:Average_time],
    colour = [:green], yerr = library_func_data[:Standard_deviation],
    label = "Polynomials interpolation")
