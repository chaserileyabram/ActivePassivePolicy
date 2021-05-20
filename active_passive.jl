# Chase Abram
# Simple "Dual Taylor" Monetary and Fiscal Policy Model


using ForwardDiff
using LinearAlgebra
using Statistics
using StatsPlots
using Plots
using Parameters
using DifferentialEquations
using LaTeXStrings

##

# Model parameters
@with_kw mutable struct SimpleFTPLModel
    # Parameters
    
    # Initial discount rate
    rho_0 = 0.02
    # Immediately after a shock
    rho_1 = 0.01

    # Dixit-Stiglitz Mono Comp
    epsilon = 11.0

    # Rotemberg price adj cost
    theta = 100.0

    # Inverse Frisch
    varphi = 0.5

    # Phillips curve coeff on output gap
    kappa = (epsilon-1)*(1+varphi)/theta
    
    # MP
    phi = 1.01 # 1.25 AM
    # phi = 0.8 # PM
    
    # FP
    gamma = rho_0 * 2.0 # PF
    # gamma = rho_0 * 0.8 # AF


    # Steady-state debt
    b_ss = 10.0

    # Discount rate shock return speed
    mu = 0.1

    # Boundary Conditions
    b_0 = b_ss
    b_T = b_ss
    x_T = 0.0

    # Horizon
    T = 200
    tspan = (0.0, T)
    N = 200
    dt = T/N
end

##

# Solution of model with discount rate shock
function discount_shock(m)

    # Discount rate path
    rho(s) = m.rho_0 + exp(-m.mu*s)*(m.rho_1 - m.rho_0)

    # ODE system
    function nkftpl!(du,u,p,t)

        # pi
        du[1] = rho(t)*u[1] - m.kappa*u[2]

        # x
        du[2] = (m.phi - 1)*u[1] + m.rho_0 - rho(t)

        # b
        du[3] = (m.rho_0 - m.gamma)*(u[3] - m.b_ss) + (m.phi - 1)*u[1]*u[3]
    end

    # Boundary conditions
    function bc!(residual, u, p, t)
        # non-explosive output gap
        # residual[1] = u[end][2] - u[1][2]
        residual[1] = u[end][2] - m.x_T

        # inital debt
        residual[2] = u[1][3] - m.b_0

        # final debt
        residual[3] = u[end][3] - m.b_T

        # Alternative BCs (pi_T)
        # residual[2] = u[end][1]

    end

    # Policy region
    policy_region = string("NaN: ϕ=", m.phi, ", γ=", m.gamma)
    if m.phi > 1 && m.gamma > m.rho_0
        # Active M, Passive F
        policy_region = string("AM/PF: ϕ=", m.phi, ", γ=", m.gamma)
    elseif m.phi < 1 && m.gamma < m.rho_0
        # Passive M, Active F
        policy_region = string("PM/AF: ϕ=", m.phi, ", γ=", round(m.gamma, digits=2))
    end

    # Setup boundary value problem
    bvp = BVProblem(nkftpl!, bc!, [0,0,0], m.tspan)

    # Solve
    sol_bc = solve(bvp, MIRK4(), dt=m.dt)
    
    # Solution, discount rate path, policy region
    return sol_bc, rho, policy_region
end

# AM/PF
m0 = SimpleFTPLModel()
m0.phi = 1.01
m0.gamma = 2.0 * m0.rho_0
s0, rho0, pr0 = discount_shock(m0)

# PM/AF
m1 = SimpleFTPLModel()
m1.phi = 0.0
m1.gamma = 0.0 * m0.rho_0
s1, rho1, pr1 = discount_shock(m1)

##
# Make plots

# pi
p1 = plot(s0, vars = (1), label = pr0,legendfontsize=6)
plot!(s1, vars = (1), label = pr1)

# x
p2 = plot(s0, vars = (2), legend = false)
plot!(s1, vars = (2), legend = false)

# b
p3 = plot(s0, vars = (3), legend = false)
plot!(s1, vars = (3), legend = false)

# rho
p4 = plot(s0.t, rho0.(s0.t), legend = false)
plot!(s1.t, rho1.(s1.t), legend = false)

# i
p5 = plot(s0.t, m0.phi*getindex.(s0.u,1) .+ m0.rho_0, legend = false)
plot!(s1.t, m1.phi*getindex.(s1.u,1) .+ m1.rho_0, legend = false)

# r
p6 = plot(s0.t, (m0.phi-1)*getindex.(s0.u,1) .+ m0.rho_0, legend = false)
plot!(s1.t, (m1.phi-1)*getindex.(s1.u,1) .+ m1.rho_0, legend = false)

# s
p7 = plot(s0.t, m0.rho_0*m0.b_ss .+ m0.gamma*(getindex.(s0.u,3) .- m0.b_ss), legend = false)
plot!(s1.t, m1.rho_0*m1.b_ss .+ m1.gamma*(getindex.(s1.u,3) .- m1.b_ss), legend = false)

# all together
p = plot(p1,p2,p3,p4,p5,p6,p7, layout=7, xlabel = "t", 
title = ["π" "x" "b" "ρ" "i" "r" "s"])
display(p)

##

# Cumulative output gap (net boom/recession)
cumx0 = cumsum([s0.u[i][2] for i in 1:length(s0.u)])
p8 = plot(s0.t, cumx0, label = pr0, title = "Cumulative x")
cumx1 = cumsum([s1.u[i][2] for i in 1:length(s1.u)])
plot!(s1.t, cumx1, label = pr1)
display(p8)

######
# Save figures
##

name = string("plots/dual_taylor_phi", m0.phi, "_gamma", m0.gamma,"_phi", m1.phi, "_gamma", m1.gamma,".svg")
savefig(p, name)

##
name = string("plots/cum_dual_taylor_phi", m0.phi, "_gamma", m0.gamma,"_phi", m1.phi, "_gamma", m1.gamma,".svg")
savefig(p8, name)