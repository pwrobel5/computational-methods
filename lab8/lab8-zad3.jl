using WAV
using Plots
using FFTW

snd, sampFreq = wavread("zad3-voice.wav")
points = size(snd)[1]

s1 = snd[:,1]
timeArray = (0:(points - 1)) / sampFreq
timeArray = timeArray * 1000 # scale to milliseconds

sound_plt = plot(timeArray, s1)
display(sound_plt)

n = length(s1)
p = fft(s1)

transform_plt = sticks((abs.(p)))
display(transform_plt)

clean_p = zeros(Complex{Float64}, size(p,1))

for i = 1:size(p,1)
    if(abs(p[i]) > 20.0)
        clean_p[i] = p[i]
    end
end

cleaned_transform_plt = sticks((abs.(clean_p)))
display(cleaned_transform_plt)

cleaned_function = real(ifft(clean_p))
cleaned_function_plt = plot(timeArray, cleaned_function)
display(cleaned_function_plt)

wavwrite(cleaned_function, "zad3-out.wav", Fs = sampFreq, nbits = 32)
