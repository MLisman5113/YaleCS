
# add these packages if you haven't already
# using Pkg
# Pkg.add("Plots")
# Pkg.add("LaTeXStrings")

using Plots
using LaTeXStrings

# returns grid of N equally-spaced points on interval [xmin, xmax]
function createGrid(xmin, xmax, N)
    step = (xmax-xmin) / (N-1)
    return collect(xmin:step:xmax)
end

# returns (discrete) value and policy functions on grid defined by the vector a
function valueFuncIter(U, a; β=0.9, v0=zeros(length(a)), toler=1e-6, maxiter=1000, verbose=1)
    N = length(a)
    g = fill(0, N) # g[i] will be j<=i that maximizes U(a_i-a_j) + βv_j (this is the optimal decision rule/policy function)
    U_ar = [U(a[i]-a[j]) for i in 1:N, j in 1:N] # NxN array of all possible values of U, given grid a
    err = 1+toler; niter = 0;
    
    while err > toler && niter < maxiter
        niter += 1
        v1 = copy(v0)

        # define new value function by iterating over all grid points
        for i in 1:N
            rhs = U_ar[i,1:i] .+ β*v0[1:i] # RHS of Bellman equation (for all a_j<=a_i)
            v1[i], g[i] = findmax(rhs) # simultaneously update value function and get the optimizing j (for given i)
        end
        
        err = maximum(abs.(v1-v0)) # error defined using the sup norm
        v0 = v1
    end

    if err <= toler && verbose >= 1
        println("Value function iteration converged in $niter iterations (maxerr = $err)")
    elseif err > toler
        println("Value function iteration failed to converge in $niter iterations (maxerr = $err)")
    end

    return v0, g
end

# returns the indices (in a) corresponding to the optimal path of savings, when a0 = a[idx0]
function getPath(g, idx0, T)
    idxs = fill(idx0, T) # optimal path of cake stock (expressed as an index of a)
    for t in 2:T
        idxs[t] = g[idxs[t-1]]
    end
    return idxs
end

# the consumer's felicity function
function U(c; ϵ=0.01)
    # we don't allow negative consumption, even if c > -ϵ
    if c < 0
        return -Inf
    else
        return log(c+ϵ)
    end
end

##################################################################################################################
# 2(a)
##################################################################################################################

N = 21 # number of grid points
a = createGrid(0, 1, N)
vsol, g = valueFuncIter(U, a)

# Plot value and policy functions
plot_a1 = plot(a, vsol, title="Value function (N = $N)", xlabel=L"a", ylabel=L"V(a)", legend=false)
plot_a2 = plot(a, [a[g] a], label=["Optimal decision rule" "45-degree line"], title="Optimal decision rule (N = $N)", xlabel=L"a", ylabel=L"a'", legend=:topleft)

##################################################################################################################
# 2(b)
##################################################################################################################

T = 32
a_t = a[getPath(g, N, T)] # path of cake stock; consumer starts off with a_0=1, which has index N
c_t = a_t[1:(T-1)] .- a_t[2:T] # path of consumption

# Plot paths of cake stock and consumption
plot_b = plot(0:(T-2), [a_t[1:(T-1)] c_t[1:(T-1)]], label=[L"a_t" L"c_t"], title="Simulation (N = $N)", xlabel=L"t", marker=3)

##################################################################################################################
# 2(c)
##################################################################################################################

N = 51
a = createGrid(0, 1, N)
vsol, g = valueFuncIter(U, a)

# Plot value and policy functions
plot_c1 = plot(a, vsol, title="Value function (N = $N)", xlabel=L"a", ylabel=L"V(a)", legend=false)
plot_c2 = plot(a, [a[g] a], label=["Optimal decision rule" "45-degree line"], title="Optimal decision rule (N = $N)", xlabel=L"a", ylabel=L"a'", legend=:topleft)

# Now get savings and consumption paths
a_t = a[getPath(g, N, T)] # path of cake stock
c_t = a_t[1:(T-1)] .- a_t[2:T] # path of consumption

# Plot these paths
plot_c3 = plot(0:(T-2), [a_t[1:(T-1)] c_t[1:(T-1)]], label=[L"a_t" L"c_t"], title="Simulation (N = $N)", xlabel=L"t", marker=3)

##################################################################################################################
# Plot all results in one window
##################################################################################################################

plot(plot_a1, plot_a2, plot_c1, plot_c2, plot_b, plot_c3, layout=(3,2), size = (800,600))