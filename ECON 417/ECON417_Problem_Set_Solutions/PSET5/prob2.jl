
using Plots, LaTeXStrings
pyplot() # use PyPlot backend for Plots

##################################################################################################################
# 2(a)
##################################################################################################################

# Returns grid of N equally-spaced points on the interval [xmin, xmax]
function createGrid(xmin, xmax, N)
    step = (xmax-xmin) / (N-1)
    return collect(xmin:step:xmax)
end

# Returns (discrete) value and policy functions on grid k (of length N); z is vector (length S) of possible states (could be more than 2 if desired); P is SxS transition matrix.
# v is an NxS matrix representation of the value function, where v[i,s] = v_s(k_i); similarly, g is an NxS matrix representation of the policy rule.
function valueFuncIter(F, U, k, z, P, β; v0=zeros(length(k), length(z)), toler=1e-6, maxiter=1000)
    
    N = length(k); S = length(z)
    g = fill(0, N, S)                                               # policy rule for capital tomorrow conditional on having capital k_i and being in state s today
    C = [F(k[i],z[s])-k[j] for i in 1:N, j in 1:N, s in 1:S]        # consumption array: C[i,j,s] = F(k_i,z_s) - k_j
    J = [sum(C[i,:,s] .> 0) for i in 1:N, s in 1:S]                 # for each i and s, largest feasible j such that C[i,j,s] > 0
    U_ar = [[U(C[i,j,s]) for j in 1:J[i,s]] for i in 1:N, s in 1:S] # utility/felicity array: U_ar[i,j,s] = U(C[i,j,s]); only defined when C[i,j,s] > 0
    
    err = 1+toler; niter = 0; v = v0;
    
    while err > toler && niter < maxiter
        niter += 1
        v_new = copy(v)

        # define new value function by iterating over all grid points and states
        for i in 1:N
            for s in 1:S
                Ev = vec(sum(P[s,:]'.*v[1:J[i,s],:], dims=2)) # expected value E[v(j,s')|s]
                obj = U_ar[i,s] .+ β*Ev                     # objective function
                v_new[i,s], g[i,s] = findmax(obj)           # update value function and get the optimizing j
            end
        end
        
        err = maximum(abs.(v_new-v))
        v = v_new
    end

    return v, g, (err <= toler), niter
end

# (0) define parameters/functions
β = 0.9; α = 0.4; δ = 0.1;
z = [1.1, 0.9] # [z_g, z_b]
P = [0.9 0.1; 0.1 0.9] # transition matrix (P[i,j] = Pr(s'=j|s=i))
N = 501 # number of grid points (problem states N=101, but this gives nicer-looking results)
f(k,z) = z*k^α # production function
F(k,z) = f(k,z) + (1-δ)*k # total capital at end of this period before consumption
U(c) = log(c) # consumption utility (felicity function)

# (1) compute deterministic steady state (with z=1)
kbar = ((1/β-(1-δ))/α)^(1/(α-1))
println("Deterministic steady-state capital (with z = 1) is kbar = $kbar.")

# (2) create k grid
k = createGrid(0.25*kbar, 1.75*kbar, N)

# (3) compute value and policy functions on grid
vsol, g, converged, niter = valueFuncIter(F, U, k, z, P, β)
println("Value function iteration " * "converged"^converged * "did not converge"^(!converged) * " after $niter iterations.")

# (4) plot value and policy functions
plot_a1 = plot(k, vsol, label=[L"v_g(k)" L"v_b(k)"], title="Value functions", xlabel=L"k", ylabel=L"v(k)")
plot_a2 = plot(k, k[g], label=[L"g_g(k)" L"g_b(k)"], title="Decision rules", xlabel=L"k", ylabel=L"k'", legend=:topleft)
plot!(k, k, label="45-degree line", linestyle=:dash, color=:black) # add 45-degree line

##################################################################################################################
# 2(b)
##################################################################################################################

using Random
Random.seed!(123)

# Returns the indices (in k) corresponding to the optimal path of capital, when k0 = k[i0] and initial state is s0
function simPath(g, i0, P, T; s0=1, sdraws=rand(Float64, T-1))
    i = fill(i0, T) # optimal path of capital (expressed as an index of k)
    s = fill(s0, T) # stochastic path of states
    for t in 2:T
        i[t] = g[i[t-1], s[t-1]] # use last period's k and state to get this period's k
        s[t] = findfirst(sdraws[t-1] .<= cumsum(P[s[t-1],:])) # use last period's state and random draw to get this period's state
    end
    return i, s
end

T = 1000
k0 = kbar # initial stock of capital

i0 = findfirst(k .>= k0) # index of k (roughly) corresponding to k0
i, s = simPath(g, i0, P, T+2) # path of capital (index) and states
k_t = k[i] # path of capital
y_t = f.(k_t[1:(T+1)], z[s[1:(T+1)]]) # path of output (y = f(k,z))
x_t = k_t[2:(T+2)] - (1-δ)*k_t[1:(T+1)] # path of investment (x = k'-(1-δ)k)
c_t = y_t - x_t # path of consumption (from accounting identity c + x = y)

# plot paths out to t=100
t = 100
plot_b = plot(0:t, [k_t[1:(t+1)] y_t[1:(t+1)] x_t[1:(t+1)] c_t[1:(t+1)]], title="Simulated paths", 
    xlabel=L"t", label=[L"k_t" L"y_t" L"x_t" L"c_t"])

# calculate summary statistics (mean, standard deviation, coefficient of variation)
function stats(x)
    μ = sum(x) / length(x)
    σ = sqrt(sum((x.-μ).^2) / length(x))
    return (μ=μ, σ=σ, cv=σ/μ)
end

# we'll use the DataFrames package to display the summary statistics
# using Pkg
# Pkg.add("DataFrames")
using DataFrames
df = DataFrame(stats.([k_t, y_t, x_t, c_t]))
insertcols!(df, 1, :variable=>["capital","output","investment","consumption"])

println("\nSummary statistics for variable paths (T=$T):")
println(df)

##################################################################################################################
# draw all plots in one window
##################################################################################################################

plot(plot_a1, plot_a2, plot_b, layout=(3,1), size=(600,900))
