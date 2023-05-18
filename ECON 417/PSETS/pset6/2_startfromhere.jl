
using Plots, LaTeXStrings, Formatting
include("spline1.jl")

######## PSET 6 PROBLEM 2 #############


# returns (discrete) value function and decision rule on grid defined by the vector k
# this is unchanged from Problem Set 4
function valueFuncIter(F, U, k, β; v0=zeros(length(k)), toler=1e-6, maxiter=1000)
    N = length(k)
    g = fill(0, N)                              # decision rule
    C = [F(k[i])-k[j] for i in 1:N, j in 1:N]   # C(i,j) = F(k_i) - k_j
    J = sum(C .> 0, dims=2)                     # for each i, largest feasible j such that C(i,j) > 0
    U_ar = [[U(C[i,j]) for j in 1:J[i]] for i in 1:N] # U(i,j) = U(F(k_i) - k_j)
    err = 1+toler; niter = 0
    
    while err > toler && niter < maxiter
        niter += 1
        v1 = copy(v0)

        # define new value function by iterating over all grid points
        for i in 1:N
            obj = U_ar[i] .+ β*v0[1:J[i]] # RHS of Bellman equation (for all feasible j)
            v1[i], g[i] = findmax(obj) # update value function and get the optimizing j
        end
        
        err = maximum(abs.(v1-v0)) # error defined using the sup norm
        v0 = v1
    end

    return v0, g, (err <= toler), niter
end

# returns the optimal path of capital using the decision rule spline, starting at k0
function getPath(gspline, k0, T)
    k_t = fill(1.0*k0, T)
    for t in 2:T
        k_t[t] = interp(k_t[t-1], gspline)[1]
    end
    return k_t
end

# (0) define parameters/functions
β = 0.9; α = 0.4; δ = 0.1;
F(k) = k^α + (1-δ)*k # total capital at end of this period before consumption
U(c) = log(c) # consumption utility (felicity function)
N = 31

# (1) compute steady state k
k_ss = ((1/β-(1-δ))/α)^(1/(α-1)) # analytic steady state (solution to F'(k)=1/β)
printfmtln("Steady-state capital is k_ss = {1:.8f}.", k_ss)

# (2) create k grid
k = creategrid(0.5*k_ss, 1.5*k_ss, N)

# (3a) compute value function and decision rule on grid
v, g, converged, niter = valueFuncIter(F, U, k, β)
println("Value function iteration " * "converged"^converged * "did not converge"^(!converged) * " after $niter iterations.")

# (3b) generate spline for decision rule
gspline = makespline(k, k[g])

T=100
k_sim=zeros(T)
k_sim[1]=4
for t=2:T
    k_sim[T] = interp(k_sim[t-1], gspline)[1]
end

plot(1:T,k_sim)


###### PSET 6 PROBLEM 3  ############

