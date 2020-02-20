using LinearAlgebra
using DelimitedFiles

epsilon = 1e-8
max_iterations = 100000
A = readdlm("macierz.txt")
prevA = zeros(size(A))
epsilon_matrix = zeros(size(A))

for i = 1:size(epsilon_matrix,1)
    for j = 1:size(epsilon_matrix,2)
        epsilon_matrix[i,j] = epsilon
    end
end

difference = A - prevA
bool_array = abs.(difference) .> epsilon_matrix
i = 0

while any(x -> x == true, bool_array) && i < max_iterations
    global prevA = A
    global A = qr(A)
    global A = A.R * A.Q
    global difference = A - prevA
    global bool_array = abs.(difference) .> epsilon_matrix
    global i = i + 1
end

print("Obtained matrix:\n")
print(A)
print("\nDiagonal elements:\n")
print(diag(A))
print("\nIterations made:\n")
print(i)

print("\nFrom Julia function:\n")
print(eigvals(A))
print("\n")
