using CSV
using LinearAlgebra
using DataFrames
using Statistics
using Polynomials

input_file = "lab4.csv"
raw_data = CSV.read(input_file, delim = ";")
averages_df = by(raw_data, :Size, Average_time = :Time_naive => mean)

averages_array = convert(Matrix{Float64}, averages_df[:,1:2])

A = zeros(35,4)
x = convert(Array, averages_df[:,1])
y = convert(Array, averages_df[:,2])

A[:,1] = x.^3
A[:,2] = x.^2
A[:,3] = x
A[:,4] = ones(35)

A = factorize(A)

coefficients_factorization = A \ y
print("Result from factorization:\n")
print(coefficients_factorization)
print("\n")
print("Results from polyfit:\n")
coefficients_polyfit = polyfit(x, y, 3)
print(coefficients_polyfit)
