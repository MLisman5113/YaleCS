
include("rootfinders.jl")

# supply function (for general N-good case)
function supply(p, a)
    return exp.(a.*p) .- 1.0
end

# demand function
function demand(p, b, ϵ)
    pbar = sum(p) / length(p)
    return b.*(p./pbar).^(-ϵ)
end

z(p, a, b, ϵ) = demand(p, b, ϵ) .- supply(p, a) # excess demand function

##################################################################################################################
# 3(a) function iteration
##################################################################################################################

println("\n"*"-"^80*"\n    Problem 3(a) - function iteration \n"*"-"^80*"\n")

pstar0 = funciter(p -> z(p, 0.1, 1.0, 1.0), [1,1], verbose=1)
pstar1 = funciter(p -> z(p, 0.1, [1.1, 1.0], 1.0), pstar0, verbose=1) # demand for good A increases by 10%

println("\nOriginal p*: $(strarray(pstar0, "%.4f"))")
println("New p* (10% higher demand for good A): $(strarray(pstar1, "%.4f"))")

println("Percent change in prices: $(strarray((pstar1./pstar0 .- 1).*100, "%.2f"))%")

##################################################################################################################
# 3(b) Newton's method
##################################################################################################################

println("\n"*"-"^80*"\n    Problem 3(b) - Newton's method \n"*"-"^80*"\n")

println("(i) using numerical Jacobian...")
pstar0 = newton(p -> z(p, 0.1, 1.0, 1.0), [1, 1], verbose=1)
pstar1 = newton(p -> z(p, 0.1, [1.1, 1.0], 1.0), pstar0, verbose=1) # demand for good A increases by 10%

# Now repeat using analytic Jacobian
println("\n(ii) using analytic Jacobian...")

# Jacobian for general N-good case
function z_jacobian(p, a, b, ϵ)
    N = length(p); pbar = sum(p) / N
    return [(1/N)*b[i]*ϵ[i]*p[i]^(-ϵ[i])*pbar^(ϵ[i]-1) + (i==j)*(-b[i]*ϵ[i]*p[i]^(-ϵ[i]-1)*pbar^ϵ[i] - a[i]*exp(a[i]*p[i])) for i in 1:N, j in 1:N]
end

pstar0 = newton(p -> z(p, 0.1, 1.0, 1.0), [1,1], Df = (p -> z_jacobian(p, [0.1,0.1], [1,1], [1,1])), verbose=1)
pstar1 = newton(p -> z(p, 0.1, [1.1, 1.0], 1.0), pstar0, Df = (p -> z_jacobian(p, [0.1,0.1], [1.1,1], [1,1])), verbose=1)

##################################################################################################################
# Benchmarking - numerical vs analytic Jacobians
##################################################################################################################

# using BenchmarkTools

# println("\n"*"-"^80*"\n    Benchmarking \n"*"-"^80)

# println("\nNumerical Jacobian...\n")
# display(@benchmark newton($(p -> z(p, 0.1, 1.0, 1.0)), [1,1], verbose=0))

# println("\nAnalytic Jacobian...\n")
# display(@benchmark newton($(p -> z(p, 0.1, 1.0, 1.0)), [1,1], Df = $(p -> z_jacobian(p, [0.1,0.1], [1,1], [1,1])), verbose=0))