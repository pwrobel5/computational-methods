Fs = 1024

t = 0:1/(Fs - 1):1

x = sin.(2*pi*t*200) + 2 * sin.(2*pi*t*400) + 3 * cos.(2*pi*t*120)

using Plots
function_plt = plot(t,x)
display(function_plt)

using FFTW
y = fft(x)
transform_plt = sticks((abs.(fft(x))))
display(transform_plt)
