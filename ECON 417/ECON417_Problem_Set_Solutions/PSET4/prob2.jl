
include("brent1.jl")
include("ps4_functions.jl")

f(x) = log(x) - x

# (1) using Brent's method
~, xmin, niter = brent(0.5, 1.0, 2.0, x -> -f(x), 1.0e-8, 1.0e-8) # we're maximizing f, so we're minimizing -f
println("Brent's method: xmax = $xmin, f(xmax) = $(f(xmin)), niter = $niter")

# (2) using Newton's method
fx0, x0, type, niter = newton_optim(f, 0.5, Df = (x -> 1/x-1), D2f = (x -> -1/x^2))
println("Newton's method: xmax = $x0, f(xmax) = $fx0, niter = $niter")

# check visually
using Plots
xx = createGrid(0.01, 5, 1000)
plot(xx, f.(xx), xlabel="x", ylabel="f(x)")