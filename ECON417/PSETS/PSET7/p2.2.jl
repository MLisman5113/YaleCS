using Formatting, Plots, LaTeXStrings, Random

include("spline1.jl")
include("gauher1.jl")
include("brent1.jl")

N = 31 # number of s grid points
T = 4 # number of periods
(w, u) = gauher(10) # weights and abscissas to be used when calculating approximate expectation
b = 1; σ = 0.5; β = 0.7; r = 0.2; # model parameters
u3 = [3.936159118837738, 3.0327316742327897, 2.2566836492998819, 1.5366108297895136, 0.8429013272237046, -0.8429013272237046, -1.5366108297895136, -2.2566836492998819, -3.0327316742327897, -3.936159118837738]
# 
v = Array{Function}(undef, T); g = Array{Function}(undef, T)
vsplines = Array{spline}(undef, T-2); gsplines = Array{spline}(undef, T-2)

v[T] = (s -> log(s))
g[T] = (s -> 0)

g[T-1] = (s -> β/(1+ β)*s)
v[T-1] = (s -> log(s - g[T-1](s))+β*v[T]((1+r)*g[T-1](s)))

smin=b
smax=(1+r)*b+b+exp(3*σ)
sgrid = creategrid(b, smax, N)

# G(t,a) = π^(-0.5) * sum(w .* v[t].((1+r)*a + b .+ exp.(σ*u*sqrt(2))))

function G(t,a)
    result = 0
    for i=1:10
        result += w[i]*v[t]((1+r)*a+b+exp(σ*u3[i]*sqrt(2)))
    end
    result /= sqrt(π)
    return result
end

v1sol=zeros(N)
g1sol=zeros(N)
negobj(s,a,t) = -(log(s-a) + β*G(t+1, a))
# looping over all s1 to solve v1(s1)
for i_s=1:N
    # Solve for optimal a(2) in [0,s1)
    fmin, amin, ~ = brent(0, sgrid[i_s]/2, sgrid[i_s], (a -> negobj(sgrid[i_s],a,2)))

    v1sol[i_s] = -fmin
    g1sol[i_s] = amin
end

println(v1sol)
println("")
println(g1sol)


v1splines = makespline(sgrid, v1sol)
#v1 of pset
v[2] = (s -> interp(s,v1splines)[1])
v0sol=zeros(N)
g0sol=zeros(N)

# looping over all s1 to solve v1(s1)
for i_s=1:N
    # Solve for optimal a(2) in [0,s1)
    fmin, amin, ~ = brent(0, sgrid[i_s]/2, sgrid[i_s], (a -> negobj(sgrid[i_s],a,1)))

    v0sol[i_s] = -fmin
    g0sol[i_s] = amin
end

println(v0sol)
println("")
println(g0sol)

# Plotting the value functions for v_i = 1,2,3 and decision rules for g_i = 1,2

# v_i = 3
s=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
plot(s -> log((1+r)g[T-1](s) + 0), title="v_i = 3")

# v_i = 2
plot(v1sol, title="v_i = 2",xlabel="v1sol")

# v_i = 1
plot(v0sol, title="v_i = 1", xlabel="v0sol")

# decision rules

# g_i = 1
plot(g0sol, title="g_i = 1", ylabel="g0sol")

# g_i = 2
plot(g1sol, title="g_i = 2", ylabel="g1sol")

# Printing the values of v_0(b) and g_0(b)
# INSERT v_0(b) AND g_0(b)!!!!!!!!!!!
println("v_0(1): ", v0sol[1])
println("g_0(1): ", g0sol[1])