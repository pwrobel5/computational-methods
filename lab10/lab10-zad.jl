using Interact
using Plots
using DataFrames
using DifferentialEquations

function solve_euler(u0, tau, timestep, time_max)
    result = zeros(trunc(Int, time_max / timestep) + 1)
    u_val = u0
    index_arr = 1

    for i = 0:timestep:time_max
        result[index_arr] = u_val
        u_val = u_val - timestep * (u_val / tau)
        index_arr += 1
    end
    result
end

function solve_from_library(u0, tau, time_max)
    f(u, p, t) = -1.0 * (u / tau)
    tspan = (0.0, time_max)
    prob = ODEProblem(f, u0, tspan)
    sol = solve(prob)
    sol
end

function myodewidget()
    u0 = slider(0.1:0.1:10, label = "u(0)", value = 1)
    tau = slider(0.1:0.1:20, label = "tau (time constant)", value = 10)
    timestep = slider(0.1:0.1:10, label = "Euler's method timestep", value = 1)
    time_max = slider(1:100, label = "End time for simulation", value = 50)
    euler_output = Interact.@map solve_euler(&u0, &tau, &timestep, &time_max)
    plt = Interact.@map plot([i for i in 0:&timestep:&time_max], &euler_output, label = "Euler method")

    sol = Interact.@map solve_from_library(&u0, &tau, &time_max)
    Interact.@map plot!(&plt, &sol, label = "Method from DifferentialEquations")

    Interact.@map plot!(&plt, x -> &u0 * exp(-1.0 * x / &tau), label = "Exact solution")

    wdg = Widget(["u0" => u0, "tau" => tau, "timestep" => timestep, "time_max" => time_max], output = euler_output)
    @layout! wdg hbox(plt, vbox(:u0, :tau, :timestep, :time_max))
end

ebe = myodewidget()
display(ebe)
