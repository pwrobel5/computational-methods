using LinearAlgebra

x = rand(1000)
A = rand(1000,1000)
b = A * x

print("Inv time: ")
x_inv = @time inv(A) * b
inv_err_vec = x - x_inv
inv_err = sqrt(dot(inv_err_vec, inv_err_vec))
print("Inv error: ", inv_err, "\n")
print("\n")

print("Backslash time: ")
x_backslash = @time A\b
backslash_err_vec = x - x_backslash
backslash_err = sqrt(dot(backslash_err_vec, backslash_err_vec))
print("Backslash error: ", backslash_err, "\n")
print("\n")

print("Factorize time: ")
A = factorize(A)
x_factorize = @time A\b
factorize_err_vec = x - x_factorize
factorize_err = sqrt(dot(factorize_err_vec, factorize_err_vec))
print("Factorize error: ", factorize_err, "\n")
print("\n")
