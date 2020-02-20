Fs = 1024
t = 0:10/(Fs-1):10
x = [12*cos(i) + rand() for i in t]

using Plots
function_plt = plot(t,x)
display(function_plt)

using FFTW
y = fft(x)
transform_plt = sticks((abs.(fft(x))))
display(transform_plt)

clean_y = zeros(Complex{Float64}, size(y,1))

for i = 1:size(y,1)
    if(abs(y[i]) > 50.0)
        clean_y[i] = y[i]
    end
end

cleaned_transform_plt = sticks((abs.(clean_y)))
display(cleaned_transform_plt)

cleaned_function = real(ifft(clean_y))
cleaned_function_plt = plot(t, cleaned_function)
display(cleaned_function_plt)
