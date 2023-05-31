
using Formatting, Plots, LaTeXStrings, Random
# pyplot()

include("spline1.jl")
include("gauher1.jl")
include("brent1.jl")

##################################################################################################################
# 2(a)
##################################################################################################################

# (0) define parameters, etc.
N = 31 # number of s grid points
T = 4 # number of periods
(w, u) = gauher(10) # weights and abscissas to be used when calculating approximate expectation
b = 1; σ = 0.5; β = 0.7; r = 0.2; # model parameters

v = Array{Function}(undef, T) # store value functions in array of length T (not the only way to do this)
g = Array{Function}(undef, T) # same with optimal saving rules

# (1) set last period (T) value
v[T] = (s -> log(s)) # consume all remaining wealth
g[T] = (s -> 0)

# (2) solve for T-1 value and saving rule
a(s) = (β/(1+β))*s # analytic solution to two-period problem
v[T-1] = (s -> (log(s-a(s)) + β*log((1+r)*a(s)))) # just the analytic value function
g[T-1] = (s -> a(s))

# (3) solve for value and saving rule for remaining periods recursively
smax = (2+r)*b + exp(3σ) # maximum "plausible" cash-on-hand in second period (adjust for larger T)
sgrid = creategrid(b, smax, N) # grid on which value functions and saving rules will be calculated
vsplines = Array{spline}(undef, T-2); gsplines = Array{spline}(undef, T-2) # store splines so that they don't have to be recalculated each time

G(v,a) = π^(-0.5) * sum(w .* v.((1+r)*a + b .+ exp.(σ*u*sqrt(2)))) # expected next-period value, given v_{t+1}=v and a_{t+1}=a
negobj(s,a,t) = -(log(s-a) + β*G(v[t+1], a))

let # this gets around declaring global variables in loops
for t in Iterators.reverse(1:(T-2)) # iterate backwards to first period
    vgrid = zeros(N); ggrid = zeros(N)
    for i in 1:N
        fmin, a, ~ = brent(0, sgrid[i]/2, sgrid[i], a->negobj(sgrid[i],a,t)) # use Brent's method to find a that maximizes objective (minimizes negobj)
        vgrid[i] = -fmin # update value function
        ggrid[i] = a # update decision rule
    end
    vsplines[t] = makespline(sgrid, vgrid); gsplines[t] = makespline(sgrid, ggrid)
    v[t] = s -> interp(s, vsplines[t])[1]; g[t] = s -> interp(s, gsplines[t])[1] # store value function and saving rule as interpolated splines
end
end

# (4) plot value functions and optimal saving rules
p1 = plot(xlabel=L"s_t", ylabel=L"v_t(s_t)", title="Value functions")
p2 = plot(xlabel=L"s_t", ylabel=L"a_{t+1}=g_t(s_t)", title="Saving rules")
s1 = creategrid(b, smax, 200) # grid of s values to be used for plotting
s2 = creategrid(0, smax, 200) # grid for last period value

for t in 1:T
    if t < T
        plot!(p1, s1, v[t].(s1), label=L"t=%$(t-1)")
        plot!(p2, s1, g[t].(s1), label=L"t=%$(t-1)")
    else
        plot!(p1, s2, v[t].(s2), label=L"t=%$(t-1)")
    end
end

printfmtln("v0(b) = {1:.6f}, g0(b) = {2:.6f}", v[1](b), g[1](b))

##################################################################################################################
# 2(b)
##################################################################################################################

Random.seed!(100)

nsims = 5
u_t = σ*randn(T-2, nsims) # random normally-distributed income shocks
s_t = zeros(T); a_t = zeros(T+1)
y_t = zeros(T); y_t[1] = b;

p3 = plot(xlabel=L"t", title="Simulations")
colors = palette(:default) # for plotting each simulation in a different color

let
for i in 1:nsims
    y_t[2:(T-1)] = b .+ exp.(u_t[:,i]) # define income path using shocks
    for t in 1:T
        s_t[t] = (1+r)*a_t[t] + y_t[t] # cash-on-hand for period t
        a_t[t+1] = g[t](s_t[t]) # savings for period t+1
    end
    c_t = s_t .- a_t[2:(T+1)] # consumption is just this period's cash-on-hand minus savings for next period
    label = (i == 1) ? [L"c_t" L"a_{t+1}"] : false # create legend entry only for first simulation
    plot!(p3, 0:(T-1), [c_t a_t[2:(T+1)]], label=label, 
        color=colors[i], linestyle=[:solid :dash])
end
end

##################################################################################################################
# draw all plots in one window
##################################################################################################################

plot(p1, p2, p3, layout=(3,1), size=(600,900))