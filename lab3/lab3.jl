function naive_multiplication(A, B)
    C = zeros(Float64, size(A,1), size(B,2))
    for i = 1:size(A,1)
        for j = 1:size(B,2)
            for k = 1:size(A,2)
                C[i,j] = C[i,j] + A[i,k] * B[k,j]
            end
        end
    end
    C
end

function better_multiplication(A,B)
    C = zeros(Float64, size(A,1), size(B,2))
    for j = 1:size(B,2)
        for k = 1:size(A,2)
            for i = 1:size(A,1)
                C[i,j] = C[i,j] + A[i,k] * B[k,j]
            end
        end
    end
    C
end

using DataFrames
using Plots
using Statistics
using Polynomials
using CSV

experimental_results = DataFrame(Size = Int[], Measure = Int[],
                                Time_naive = Float64[], Time_better = Float64[],
                                Time_blas = Float64[])


for size = 2:10:350
    for measure = 1:10
        A = rand(size,size)
        B = rand(size,size)
        push!(experimental_results, (size, measure, (@elapsed naive_multiplication(A,B)), (@elapsed better_multiplication(A,B)), (@elapsed A * B)))
    end
end

naive_data = by(experimental_results, :Size, Average_time = :Time_naive => mean, Standard_deviation = :Time_naive => std)
better_data = by(experimental_results, :Size, Average_time = :Time_better => mean, Standard_deviation = :Time_better => std)
blas_data = by(experimental_results, :Size, Average_time = :Time_blas => mean, Standard_deviation = :Time_blas => std)

pl_naive = scatter(naive_data[:Size], naive_data[:Average_time], colour = [:red], yerr = naive_data[:Standard_deviation], xlabel = "Array size", ylabel = "Average time [s]", label = "Naive multiplication", title = "Julia computing")
scatter!(better_data[:Size], better_data[:Average_time], colour = [:blue], yerr = better_data[:Standard_deviation], label = "Better multiplication")
scatter!(blas_data[:Size], blas_data[:Average_time], colour = [:green], yerr = blas_data[:Standard_deviation], label = "BLAS")

fit_naive = polyfit(naive_data[:Size], naive_data[:Average_time], 3)
plot!(naive_data[:Size], polyval(fit_naive, naive_data[:Size]), label = "Naive polynomial", colour = [:red])

fit_better = polyfit(better_data[:Size], better_data[:Average_time], 3)
plot!(better_data[:Size], polyval(fit_better, better_data[:Size]), label = "Better polynomial", colour = [:blue])

fit_blas = polyfit(blas_data[:Size], blas_data[:Average_time], 3)
plot!(blas_data[:Size], polyval(fit_blas, blas_data[:Size]), label = "BLAS polynomial", colour = [:green])

#load data from C
input_file = "matrices_out.csv"
my_C_data = CSV.read(input_file, delim = ";")

naive_c_data = by(my_C_data, :Size, Average_time = :Time_naive => mean, Standard_deviation = :Time_naive => std)
better_c_data = by(my_C_data, :Size, Average_time = :Time_better => mean, Standard_deviation = :Time_better => std)
blas_c_data = by(my_C_data, :Size, Average_time = :Time_blas => mean, Standard_deviation = :Time_blas => std)

pl_c_naive = scatter(naive_c_data[:Size], naive_c_data[:Average_time], colour = [:red], yerr = naive_c_data[:Standard_deviation], xlabel = "Array size", ylabel = "Average time [ms]", label = "Naive multiplication", title = "C computing")
scatter!(better_c_data[:Size], better_c_data[:Average_time], colour = [:blue], yerr = better_c_data[:Standard_deviation], label = "Better multiplication")
scatter!(blas_c_data[:Size], blas_c_data[:Average_time], colour = [:green], yerr = blas_c_data[:Standard_deviation], label = "BLAS")

fit_c_naive = polyfit(naive_c_data[:Size], naive_c_data[:Average_time], 3)
plot!(naive_c_data[:Size], polyval(fit_c_naive, naive_c_data[:Size]), label = "Naive polynomial", colour = [:red])

fit_c_better = polyfit(better_c_data[:Size], better_c_data[:Average_time], 3)
plot!(better_c_data[:Size], polyval(fit_c_better, better_c_data[:Size]), label = "Better polynomial", colour = [:blue])

fit_c_blas = polyfit(blas_c_data[:Size], blas_c_data[:Average_time], 3)
plot!(blas_c_data[:Size], polyval(fit_c_blas, blas_c_data[:Size]), label = "BLAS polynomial", colour = [:green])

#load data from C optimized
input_file_opt = "matrices_out_opt.csv"
my_C_opt_data = CSV.read(input_file_opt, delim = ";")

naive_c_opt_data = by(my_C_opt_data, :Size, Average_time = :Time_naive => mean, Standard_deviation = :Time_naive => std)
better_c_opt_data = by(my_C_opt_data, :Size, Average_time = :Time_better => mean, Standard_deviation = :Time_better => std)
blas_c_opt_data = by(my_C_opt_data, :Size, Average_time = :Time_blas => mean, Standard_deviation = :Time_blas => std)

pl_c_opt_naive = scatter(naive_c_opt_data[:Size], naive_c_opt_data[:Average_time], colour = [:red], yerr = naive_c_opt_data[:Standard_deviation], xlabel = "Array size", ylabel = "Average time [ms]", label = "Naive multiplication", title = "C -O computing")
scatter!(better_c_opt_data[:Size], better_c_opt_data[:Average_time], colour = [:blue], yerr = better_c_opt_data[:Standard_deviation], label = "Better multiplication")
scatter!(blas_c_opt_data[:Size], blas_c_opt_data[:Average_time], colour = [:green], yerr = blas_c_opt_data[:Standard_deviation], label = "BLAS")

fit_c_opt_naive = polyfit(naive_c_opt_data[:Size], naive_c_opt_data[:Average_time], 3)
plot!(naive_c_opt_data[:Size], polyval(fit_c_opt_naive, naive_c_opt_data[:Size]), label = "Naive polynomial", colour = [:red])

fit_c_opt_better = polyfit(better_c_opt_data[:Size], better_c_opt_data[:Average_time], 3)
plot!(better_c_opt_data[:Size], polyval(fit_c_opt_better, better_c_opt_data[:Size]), label = "Better polynomial", colour = [:blue])

fit_c_opt_blas = polyfit(blas_c_opt_data[:Size], blas_c_opt_data[:Average_time], 3)
plot!(blas_c_opt_data[:Size], polyval(fit_c_opt_blas, blas_c_opt_data[:Size]), label = "BLAS polynomial", colour = [:green])

#load data from C O3 optimized
input_file_opt3 = "matrices_out_opt3.csv"
my_C_opt3_data = CSV.read(input_file_opt, delim = ";")

naive_c_opt3_data = by(my_C_opt3_data, :Size, Average_time = :Time_naive => mean, Standard_deviation = :Time_naive => std)
better_c_opt3_data = by(my_C_opt3_data, :Size, Average_time = :Time_better => mean, Standard_deviation = :Time_better => std)
blas_c_opt3_data = by(my_C_opt3_data, :Size, Average_time = :Time_blas => mean, Standard_deviation = :Time_blas => std)

pl_c_opt3_naive = scatter(naive_c_opt3_data[:Size], naive_c_opt3_data[:Average_time], colour = [:red], yerr = naive_c_opt3_data[:Standard_deviation], xlabel = "Array size", ylabel = "Average time [ms]", label = "Naive multiplication", title = "C -O3 computing")
scatter!(better_c_opt3_data[:Size], better_c_opt3_data[:Average_time], colour = [:blue], yerr = better_c_opt3_data[:Standard_deviation], label = "Better multiplication")
scatter!(blas_c_opt3_data[:Size], blas_c_opt3_data[:Average_time], colour = [:green], yerr = blas_c_opt3_data[:Standard_deviation], label = "BLAS")

fit_c_opt3_naive = polyfit(naive_c_opt3_data[:Size], naive_c_opt3_data[:Average_time], 3)
plot!(naive_c_opt3_data[:Size], polyval(fit_c_opt3_naive, naive_c_opt3_data[:Size]), label = "Naive polynomial", colour = [:red])

fit_c_opt3_better = polyfit(better_c_opt3_data[:Size], better_c_opt3_data[:Average_time], 3)
plot!(better_c_opt3_data[:Size], polyval(fit_c_opt3_better, better_c_opt3_data[:Size]), label = "Better polynomial", colour = [:blue])

fit_c_opt3_blas = polyfit(blas_c_opt3_data[:Size], blas_c_opt3_data[:Average_time], 3)
plot!(blas_c_opt3_data[:Size], polyval(fit_c_opt3_blas, blas_c_opt3_data[:Size]), label = "BLAS polynomial", colour = [:green])


plot(pl_naive, pl_c_naive, pl_c_opt_naive, pl_c_opt3_naive, layout = grid(2,2, heights = [0.50, 0.50], widths = [0.5, 0.5]), size = (1800, 1200))

savefig("figure.png")
