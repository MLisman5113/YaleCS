
using Plots, LaTeXStrings, Formatting
include("spline1.jl")
include("creategrid1.jl")
include("brent1.jl")

# returns (discrete) value function and decision rule on grid defined by the vector k
# this is modified from Problem Set 4 based on the TA session on March 3
function valueFuncIter2(F, U, k, β; v0=zeros(length(k)), toler=1e-6, maxiter=1000)
    N = length(k)
    g = zeros(N)                            # decision rule              # for each i, largest feasible j such that C(i,j) > 0
    err = 1+toler; niter = 0
    
    while err > toler && niter < maxiter
        niter += 1
        v1 = copy(v0)
        v0spline = makespline(k,v0)
        negobj(i_k, kprime) = -(U(F(k[i_k]) - kprime) + β*interp(kprime,v0spline)[1]) 

        # define new value function by iterating over all grid points
        for i in 1:N
            a,b,~=brent(0, F(k[i])/2, F(k[i]),kprime -> negobj(i,kprime))
            v1[i] = -a
            g[i] = b
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
println("Steady-state capital is k_ss = {1:.8f}.", k_ss)

# (2) create k grid
k = creategrid(0.5*k_ss, 1.5*k_ss, N)

# (3a) compute value function and decision rule on grid
v, g, converged, niter = valueFuncIter2(F, U, k, β)
println("Value function iteration " * "converged"^converged * "did not converge"^(!converged) * " after $niter iterations.")

# (3b) generate spline for decision rule
gspline = makespline(k, g)

