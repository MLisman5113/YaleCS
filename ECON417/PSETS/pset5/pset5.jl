
using Plots, LaTeXStrings, Statistics
pyplot() # use PyPlot backend for Plots
include("ps4_functions.jl") # useful functions


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
β = 0.9; α=0.4; δ=0.1; z_g = 1.1; z_b = 0.9; pi_gg = 0.9; pi_bb = 0.9
N = 101 # number of grid points (problem states N=31, but this gives nicer-looking results)
G(k) = z_g*k^α + (1-δ)*k # good state
B(k) = z_b*k^α + (1-δ)*k # bad state - total capital at end of this period before consumption
U(c) = log(c) # consumption utility (felicity function)

# (1) compute steady state k
k_ssG = ((1/β-(1-δ))/α)^(1/(α-1))
k_ssB = ((1/β-(1-δ))/α)^(1/(α-1)) # analytic steady state (solution to F'(k)=1/β)
println("Steady-state capital is k_ssG = $k_ssG.")
println("Steady-state capital is k_ssB = $k_ssB.")

# (2) create k grid
k1 = createGrid(0.25*k_ssG, 1.75*k_ssG, N)
k2 = createGrid(0.25*k_ssB, 1.75*k_ssB, N)


# (3) compute value and policy functions
vsol1, g1, converged1, niter1 = valueFuncIter(G, U, k1, β)
println("Value function iteration " * "converged"^converged1 * "did not converge"^(!converged1) * " after $niter1 iterations.")
vsol2, g2, converged2, niter2 = valueFuncIter(B, U, k2, β)
println("Value function iteration " * "converged"^converged2 * "did not converge"^(!converged2) * " after $niter2 iterations.")

# (4) plot value and policy functions
plot_a1 = plot(k1, vsol1, title="Value function Good State", xlabel=L"k", ylabel=L"V(k)", legend=false)
plot_a2 = plot(k1, [k1[g1] k1], label=["Policy rule" "45-degree line"], title="Policy rule", xlabel=L"k", ylabel=L"k'", legend=:topleft)


plot_a1_1 = plot(k2, vsol2, title="Value function Bad State", xlabel=L"k", ylabel=L"V(k)", legend=false)
plot_a2_2 = plot(k2, [k2[g2] k2], label=["Policy rule" "45-degree line"], title="Policy rule", xlabel=L"k", ylabel=L"k'", legend=:topleft)


# returns the indices (in k) corresponding to the optimal path of capital, when k0 = k[i0]
function getPath(g, i0, T)
    is = fill(i0, T) # optimal path of  stock (expressed as an index of a)
    for t in 2:T
        is[t] = g[is[t-1]]
    end
    return is
end

function my_std(samples)
    samples_mean = mean(samples)
    samples_size = length(samples)
    samples = map(x -> (x - samples_mean)^2, samples)
    samples_sum = sum(samples)
    samples_std = sqrt(samples_sum / (samples_size - 1))
    return samples_std
end

T = 1000
k0 = 4 # initial stock of capital
i0_G = findfirst(k1 .>= k0)
i0_B = findfirst(k2 .>= k0) # index of k (roughly) corresponding to k0

k_tG = k1[getPath(g1, i0_G, T+2)] # path of capital
k_tB = k2[getPath(g2, i0_B, T+2)]

mean(k_tG)
my_std(k_tG)
volatility_k_tG = my_std(k_tG)/mean(k_tG)

mean(k_tB)
my_std(k_tB)
volatility_k_tB = my_std(k_tB)/mean(k_tB)

c_tG = G.(k_tG[1:(T+1)]) - k_tG[2:(T+2)]
c_tB = B.(k_tB[1:(T+1)]) - k_tB[2:(T+2)] # path of consumption

mean(c_tG)
my_std(c_tG)
volatility_c_tG = my_std(c_tG)/mean(c_tG)

mean(c_tB)
my_std(c_tB)
volatility_c_tB = my_std(c_tB)/mean(c_tB)

V_tG = cumsum(β.^collect(0:T) .* G.(c_tG))
V_tB = cumsum(β.^collect(0:T) .* B.(c_tB)) # cumulative discounted utility
mean(V_tG)
my_std(V_tG)
volatility_V_tG = my_std(V_tG)/mean(V_tG)

mean(V_tB)
my_std(V_tB)
volatility_V_tB = my_std(V_tB)/mean(V_tB)

min(volatility_c_tB,volatility_c_tG,volatility_k_tB,volatility_k_tG,volatility_V_tB,volatility_V_tG)
println("Consumption is the least volatile according to the above calculations!")

# plot paths of k and c
plot_b1G = plot(0:100, [k_tG[1:(101)] c_tG[1:(101)]], ylims=(0,maximum(k1)+0.1), title=L"Paths of $k$ and $c$ in Good State (z_g) ($k_0=%$k0$)", 
    xlabel=L"t", label=[L"k_tG" L"c_tG"], marker=3)

plot_b1B = plot(0:100, [k_tB[1:(101)] c_tB[1:(101)]], ylims=(0,maximum(k2)+0.1), title=L"Paths of $k$ and $c$ in Bad State (z_b) ($k_0=%$k0$)", 
    xlabel=L"t", label=[L"k_tB" L"c_tB"], marker=3)

# plot lifetime utility
plot_b2G = plot(0:100, V_tG[1:(101)], ylims=(minimum(V_tG)-0.1,vsol1[i0_G]+40), title=L"Lifetime utility Good State ($k_0=%$k0$)", 
    xlabel=L"t", label="Cumulative discounted utility", marker=3, legend=:bottomright)

plot_b2B = plot(0:100, V_tB[1:(101)], ylims=(minimum(V_tB)-0.1,vsol2[i0_B]+40), title=L"Lifetime utility Bad State ($k_0=%$k0$)", 
    xlabel=L"t", label="Cumulative discounted utility", marker=3, legend=:bottomright)

##################################################################################################################
# draw all plots in one window
##################################################################################################################

plot(plot_a1, plot_a1_1, plot_a2, plot_a2_2, plot_b1G, plot_b1B, plot_b2G, plot_b2B, layout=(2,4), size=(1500,900))

png("All Plots")