
using Formatting
include("rootfinders.jl") # import root-finding functions

lb = 0.01; ub = 10.0; tol = 1e-6                # lower/upper bounds and tolerance for root-finding methods (use same for each method)
verbose = 1                                     # verbose=1 prints only final output, verbose=2 prints each iteration

supply(p, a) = exp(a*p) - 1
demand(p, b, ϵ) = b*p^(-ϵ)
z(p, a, b, ϵ) = demand(p, b, ϵ) - supply(p, a)  # excess demand function
a = 0.1; b = 1; ϵ = 1                           # baseline model parameters

##################################################################################################################
# 3(a) - bisection method
##################################################################################################################

println("\n"*"-"^80*"\n    Problem 3(a) \n"*"-"^80*"\n")

pstar0 = bisect(p -> z(p, a, b, ϵ), lb, ub; toler=tol, verbose=verbose)  # equilibrium price for baseline model using bisection method
pstar1 = bisect(p -> z(p, a, 1.1*b, ϵ), lb, ub; toler=tol, verbose=verbose)  # now for model with 10% higher demand

println()
printfmtln("When demand goes up by 10%, p* goes up from {1:.4f} to {2:.4f} ({3:.2f}% increase)", pstar0, pstar1, (pstar1/pstar0-1)*100)

##################################################################################################################
# 3(b) - secant method
##################################################################################################################

println("\n"*"-"^80*"\n    Problem 3(b) \n"*"-"^80*"\n")

secant(p -> z(p, a, b, ϵ), lb, ub; toler=tol, verbose=verbose)
secant(p -> z(p, a, 1.1*b, ϵ), lb, ub; toler=tol, verbose=verbose)

##################################################################################################################
# 3(c) - function iteration
##################################################################################################################

println("\n"*"-"^80*"\n    Problem 3(c) \n"*"-"^80*"\n")

p0 = (lb+ub)/2 # initial price is somewhat arbitrary
funciter(p -> z(p, a, b, ϵ), p0; toler=tol, verbose=verbose)
funciter(p -> z(p, a, 1.1*b, ϵ), p0; toler=tol, verbose=verbose)
