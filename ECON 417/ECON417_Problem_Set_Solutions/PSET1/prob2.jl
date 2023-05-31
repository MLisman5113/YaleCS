
##################################################################################################################
# FUNCTIONS
##################################################################################################################

# here we define the one- and two-sided numerical derivative functions

# returns the one-sided numerical derivative of f at x, given increment h
function numderiv1(f, x; h=1.0e-6)
    return (f(x+h) - f(x))/h
end

# returns the two-sided numerical derivative of f at x, given increment h
function numderiv2(f, x; h=1.0e-6)
    return (f(x+h) - f(x-h))/(2*h)
end


##################################################################################################################
# MAIN
##################################################################################################################

include("printarray.jl") # for clean output of 2D arrays as tables
using Formatting

f(x) = 0.5*x^(-0.5) + 0.5*x^(-0.2)      # this is the function given in the problem
Df(x) = -0.25*x^(-1.5) - 0.1*x^(-1.2)   # analytic (exact) first derivative of f
x = 1.5                                 # point at which f' will be evaluated
ϵs = 10.0 .^ -(1:10)                    # this creates the array [10^(-1), 10^(-2), ..., 10^(-10)]

println("The exact (to machine precision) derivative is f'(1.5) = $(Df(x))")

##################################################################################################################
# 2(a)
##################################################################################################################

println("\n"*"-"^80*"\n    Problem 2(a) \n"*"-"^80*"\n")

nderivs1 = [numderiv1(f, x, h=ϵ*x) for ϵ in ϵs] # calculates all one-sided numderivs; note that this is a concise way of writing simple for loops in Julia (it's called a "comprehension")
errs1 = nderivs1 .- Df(x) # errors for one-sided numderivs; note that . is used to denote elementwise operations (even when you're adding a scalar to a vector)
printarray([ϵs nderivs1 errs1], colnames=["ϵ", "numderiv1", "error"], formats=["%5.1e","%12.10f","%8.3e"])

##################################################################################################################
# 2(b)
##################################################################################################################

println("\n"*"-"^80*"\n    Problem 2(b) \n"*"-"^80*"\n")

nderivs2 = [numderiv2(f, x, h=ϵ*x) for ϵ in ϵs] # calculates all two-sided numderivs
errs2 = nderivs2 .- Df(x)
printarray([ϵs nderivs2 errs2], colnames=["ϵ", "numderiv2", "error"], formats=["%5.1e","%12.10f","%8.3e"])

##################################################################################################################
# 2(c)
##################################################################################################################

println("\n"*"-"^80*"\n    Problem 2(c) \n"*"-"^80*"\n")

minindx1 = argmin(abs.(errs1)) # index of (absolute) error-minimizing ϵ for one-sided numderiv
printfmtln("One-sided numderiv error is minimized at ϵ = {1:.1e} (abs error = {2:.3e})", ϵs[minindx1], abs(errs1[minindx1])) # Python-style formatting (from the Formatting package)

minindx2 = argmin(abs.(errs2)) # index of (absolute) error-minimizing ϵ for one-sided numderiv
printfmtln("Two-sided numderiv error is minimized at ϵ = {1:.1e} (abs error = {2:.3e})", ϵs[minindx2], abs(errs2[minindx2]))



