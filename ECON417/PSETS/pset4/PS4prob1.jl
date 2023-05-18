
function createGrid(xmin, xmax, N)
    step = (xmax-xmin) / (N-1)
    return collect(xmin:step:xmax)
end

##################################################################################################################
# 1(a)
##################################################################################################################

# returns (discrete) value and policy functions on grid defined by the vector k
function valueFuncIter(F, U, k, β; v0=zeros(length(k)), toler=1e-6, maxiter=1000)
    N = length(k)
    g = fill(0, N) # g[i] will be j that maximizes U(F(k_i)-k_j) + βv_j (this is the policy rule)
    C = [F(k[i])-k[j] for i in 1:N, j in 1:N] # consumption(i,j) = F(k_i) - k_j
    J = sum(C .> 0, dims=2) # for each i, largest feasible j such that F(k_i) - k_j > 0 (consumption must be positive)
    U_ar = [[U(C[i,j]) for j in 1:J[i]] for i in 1:N] # U(i,j) = U(C(i,j)) = U(F(k_i) - k_j)
    err = 1+toler; niter = 0;
    v = v0
    
    while err > toler && niter < maxiter
        niter += 1
        v_new = copy(v)

        # define new value function by iterating over all grid points
        for i in 1:N
            rhs = U_ar[i] .+ β*v[1:J[i]] # RHS of Bellman equation (for all feasible j)
            v_new[i], g[i] = findmax(rhs) # update value function and get the optimizing j
        end
        
        err = maximum(abs.(v_new-v)) # error defined using the sup norm
        v = v_new
    end

    return v, g, (err <= toler), niter
end

# (0) define parameters/functions
β = 0.9; α=0.4; δ=0.1;
N = 501 # number of grid points (problem states N=31, but this gives nicer-looking results)
F(k) = k^α + (1-δ)*k # total capital at end of this period before consumption
U(c) = log(c) # consumption utility (felicity function)

# (1) compute steady state k
k_ss = ((1/β-(1-δ))/α)^(1/(α-1)) # analytic steady state (solution to F'(k)=1/β)
println("Steady-state capital is k_ss = $k_ss.")

# (2) create k grid
k = createGrid(0.5*k_ss, 1.5*k_ss, N)

# (3) compute value and policy functions
vsol, g, converged, niter = valueFuncIter(F, U, k, β)
println("Value function iteration " * "converged"^converged * "did not converge"^(!converged) * " after $niter iterations.")

# (4) plot value and policy functions
plot_a1 = plot(k, vsol, title="Value function", xlabel=L"k", ylabel=L"V(k)", legend=false)
plot_a2 = plot(k, [k[g] k], label=["Policy rule" "45-degree line"], title="Policy rule", xlabel=L"k", ylabel=L"k'", legend=:topleft)
vline!([k_ss], label=L"k_{ss}", linestyle=:dash) # add steady-state k

##################################################################################################################
# 1(b)
##################################################################################################################

# returns the indices (in k) corresponding to the optimal path of capital, when k0 = k[i0]
function getPath(g, i0, T)
    is = fill(i0, T) # optimal path of cake stock (expressed as an index of a)
    for t in 2:T
        is[t] = g[is[t-1]]
    end
    return is
end

T = 60
k0 = 4 # initial stock of capital
i0 = findfirst(k .>= k0) # index of k (roughly) corresponding to k0
k_t = k[getPath(g, i0, T+2)] # path of capital
c_t = F.(k_t[1:(T+1)]) - k_t[2:(T+2)] # path of consumption
V_t = cumsum(β.^collect(0:T) .* U.(c_t)) # cumulative discounted utility

# plot paths of k and c
plot_b1 = plot(0:T, [k_t[1:(T+1)] c_t[1:(T+1)]], ylims=(0,maximum(k)+0.1), title=L"Paths of $k$ and $c$ ($k_0=%$k0$)", 
    xlabel=L"t", label=[L"k_t" L"c_t"], marker=3)
hline!([k_ss], label=L"k_{ss}", linestyle=:dash) # add steady-state k

# plot lifetime utility
plot_b2 = plot(0:T, V_t[1:(T+1)], ylims=(minimum(V_t)-0.1,vsol[i0]+0.5), title=L"Lifetime utility ($k_0=%$k0$)", 
    xlabel=L"t", label="Cumulative discounted utility", marker=3, legend=:bottomright)
hline!([vsol[i0]], label=L"V(k_0)", linestyle=:dash) # add V(k0)

##################################################################################################################
# draw all plots in one window
##################################################################################################################

plot(plot_a1, plot_a2, plot_b1, plot_b2, layout=(2,2), size=(900,600))
