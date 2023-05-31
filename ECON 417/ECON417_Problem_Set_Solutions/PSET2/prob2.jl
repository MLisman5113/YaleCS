include("rootfinders.jl")
include("printarray.jl")

U(c) = log(c)
U_prime(c) = 1/c

obj(a0, a1, y0, yH, yL, r, β, p) = U(a0+y0-a1) + β*(p*U((1+r)*a1+yH) + (1-p)*U((1+r)*a1+yL)) # objective function (to be maximized)
foc(a0, a1, y0, yH, yL, r, β, p) = - U_prime(a0+y0-a1) + (1+r)*β*(p*U_prime((1+r)*a1+yH) + (1-p)*U_prime((1+r)*a1+yL)) # first-order condition (derivative of objective wrt a1)

a0=5; y0=20; yH=10; yL=0; r=0.1; β=0.9; p=0.5; # define parameter values

##################################################################################################################
# 2(b)
##################################################################################################################

println("\n"*"-"^80*"\n    Problem 2(b) \n"*"-"^80*"\n")

a1star = newton(a1 -> foc(a0,a1,y0,yH,yL,r,β,p), 5, verbose=2)
printfmtln("\nThe optimal savings (a1*) are {1:.4f}. (c0* = {2:.4f}, cH* = {3:.4f}, cL* = {4:.4f})", a1star, a0+y0-a1star, (1+r)*a1star+yH, (1+r)*a1star+yL)

##################################################################################################################
# 2(c)
##################################################################################################################

println("\n"*"-"^80*"\n    Problem 2(c) \n"*"-"^80*"\n")

# returns a1* and value, given a0 and parameters
function V(a0, y0, yH, yL, r, β, p)
    a1star = newton(a1 -> foc(a0,a1,y0,yH,yL,r,β,p), 5, verbose=0)
    return a1star, obj(a0,a1star,y0,yH,yL,r,β,p)
end

a0s = [0, 2, 5, 10, 15, 20, 25, 50] # different values of a0 to test
with_uncertainty = V.(a0s, y0, yH, yL, r, β, p)
without_uncertainty = V.(a0s, y0, p*yH+(1-p)*yL, 0, r, β, 1)

printarray(hcat(a0s, [t[1] for t in with_uncertainty], [t[1] for t in without_uncertainty], [t[2] for t in with_uncertainty], [t[2] for t in without_uncertainty]), 
    colnames=["a0", "a1* (uncert)", "a1* (cert)", "V (uncert)", "V (cert)"], format="%.4f")

println("\nOptimal savings a1* are higher in case with uncertainty, value lower (for given a0).")
