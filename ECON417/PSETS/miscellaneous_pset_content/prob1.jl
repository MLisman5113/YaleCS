
include("rootfinders.jl")

U_prime(c) = 1/c
foc(a0, a1, y0, y1, r, β) = - U_prime(a0+y0-a1) + (1+r)*β*U_prime((1+r)*a1+y1) # first-order condition (derivative of objective function wrt a1)
a0=5; y0=20; y1=5; r=0.1; β=0.9; # define parameter values

##################################################################################################################
# 1(c) Newton's method
##################################################################################################################

println("\n"*"-"^80*"\n    Problem 1(c) - Newton's method \n"*"-"^80*"\n")

a1star = newton(a1 -> foc(a0,a1,y0,y1,r,β), 0, verbose=2)

printfmtln("\nThe optimal savings (a1*) are {1:.4f}. (c0* = {2:.4f}, c1* = {3:.4f})", a1star, a0+y0-a1star, (1+r)*a1star+y1)

a1star_analytic = β/(1+β)*(a0+y0) - 1/((1+r)*(1+β))*y1 # from solving foc analytically
printfmtln("a1* - a1*_analytic = {1:.5e}", a1star - a1star_analytic)

##################################################################################################################
# 1(d) Brent's method
##################################################################################################################

println("\n"*"-"^80*"\n    Problem 1(d) - Brent's method \n"*"-"^80*"\n")

a1star = zbrent(a1 -> foc(a0,a1,y0,y1,r,β), 0, a0+y0, 1e-12, 1e-12, verbose=2)

printfmtln("\nThe optimal savings (a1*) are {1:.4f}. (c0* = {2:.4f}, c1* = {3:.4f})", a1star, a0+y0-a1star, (1+r)*a1star+y1)
printfmtln("a1* - a1*_analytic = {1:.5e}", a1star - a1star_analytic)

##################################################################################################################
# Benchmarking - Newton's vs Brent's
##################################################################################################################

# using BenchmarkTools

# println("\n"*"-"^80*"\n    Benchmarking \n"*"-"^80)

# println("\nNewton's method...\n")
# display(@benchmark newton($(a1 -> foc(a0,a1,y0,y1,r,β)), 0, verbose=0))

# println("\nBrent's method:...\n")
# display(@benchmark zbrent($(a1 -> foc(a0,a1,y0,y1,r,β)), 0, a0+y0, 1e-12, 1e-12, verbose=0))