include("spline1.jl")
include("creategrid1.jl")
include("brent1.jl")
using Plots, LaTeXStrings, Formatting


######## PSET 6 PROBLEM 1 ###########

println("PROBLEM SET 6 PROBLEM 1")

function lin_interpolation(x,y,a)

    width = x[2] - x[1]
    temp = findlast(x.<=a)
    
    if a < x[1] || a>x[end]
        return NaN
    elseif temp==length(x)
        return y[end]
    else 
        return y[temp] + (y[temp + 1] - y[temp]) / (x[temp + 1] - x[temp])*(a-x[temp])
    end
end

function prob1(n_input)
    N = n_input
    xpts=creategrid(0,2*pi, N)
    ypts=sin.(xpts)

    lin_interpolation(xpts, ypts, 1.5)

    N_fine = 1000
    xpts_fine = creategrid(0,2*pi, N_fine)
    ypts_fine = broadcast(xpts_fine -> lin_interpolation(xpts, ypts, xpts_fine), xpts_fine)


    ypts_fine_lin_interpolation = zeros(N_fine)
    for i=1:N_fine
        ypts_fine_lin_interpolation[i] = lin_interpolation(xpts, ypts, xpts_fine[i])
    end

    sspline = makespline(xpts, ypts)
    ypts_fine_spline = broadcast(xpts_fine -> interp(xpts_fine, sspline)[1], xpts_fine)

    accurate = sin.(xpts_fine)

    plot(xpts_fine, accurate)
    plot!(xpts_fine, ypts_fine_lin_interpolation)
    plot!(xpts_fine, ypts_fine_spline)
    savefig("Q1_accurate_lin_interpolation_fine_spline.png")

    total_lin_interp = 0
    total_fine_spline = 0
    max_lin_interp = -99999
    max_fine_spline = -99999

    for i in 1:N
        total_lin_interp = total_lin_interp + abs(accurate[i] - ypts_fine_lin_interpolation[i])
        total_fine_spline = total_fine_spline + abs(accurate[i] - ypts_fine_spline[i])

        if abs(accurate[i] - ypts_fine_lin_interpolation[i]) > max_lin_interp
            max_lin_interp = abs(accurate[i] - ypts_fine_lin_interpolation[i])
        end
        if abs(accurate[i] - ypts_fine_spline[i]) > max_fine_spline
            max_fine_spline = abs(accurate[i] - ypts_fine_spline[i])
        end
    end

    average_err_lin_interp = total_lin_interp / N
    average_err_fine_spline = total_fine_spline / N

    println("N: ",N)
    println("Average Error Linear Interpolation: ", average_err_lin_interp)
    println("Average Error Spline: ", average_err_fine_spline)

    println("Minimum of the two errors: ", min(average_err_fine_spline, average_err_lin_interp))

    println("Max Error Linear Interpolation: ", max_lin_interp)
    println("Max Error Spline: ", max_fine_spline)
    println("")

end


# error calculations for N= 5,11,15,999,1000: accurate - interpolation result -- CALCULATE!
N5 = prob1(5)
N11 = prob1(11)
N15 = prob1(15)
N999 = prob1(999)
N1000 = prob1(1000)



######### PSET 6 PROBLEM 2 ############


println("PROBLEM SET 6 PROBLEM 2")

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
println("Cubic spline for decision rule: ", gspline)

T=100
k_sim=zeros(T)
k_sim[1]=4
for t=2:T
    k_sim[T] = interp(k_sim[t-1], gspline)[1]
end

plot(1:T,k_sim)
savefig("Q2_k_sim_interpolation.png")

capital_stock_path = getPath(gspline, 4, T)
println("Optimal Path for Capital Stock: ", capital_stock_path)

plot(1:T, capital_stock_path)
savefig("Q2_capital_stock_path.png")

println("The plot shows that the capital stock path converges to the steady state k_ss: ", k_ss)
println("")

######## PSET 6 PROBLEM 3 ##############

println("PROBLEM SET 6 PROBLEM 3")

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
N = 15

# (1) compute steady state k
k_ss = ((1/β-(1-δ))/α)^(1/(α-1)) # analytic steady state (solution to F'(k)=1/β)
println("Steady-state capital is k_ss = {1:.8f}.", k_ss)

# (2) create k grid
k = creategrid(0.5*k_ss, 1.5*k_ss, N)

# (3a) compute value function and decision rule on grid
v, g, converged, niter = valueFuncIter2(F, U, k, β)
println("Value function iteration " * "converged"^converged * "did not converge"^(!converged) * " after $niter iterations.")

# (3b) generate spline for value function and decision rule

vspline = makespline(v, g) # value function
gspline = makespline(k, g) # decision rule


# graph of cubic spline approximation for the value function (v) and decision rule (g)
plot(vspline.x, vspline.y)
plot!(gspline.x, gspline.y)
savefig("Q3_cubic_spline_value&decision.png")

# graphs showing starting slightly below k_ss and slightly above k_ss
plot(getPath(gspline, 2.5, 100))
plot!(getPath(gspline, 3, 100))
savefig("Q3_capital_path_above_below_kss.png")