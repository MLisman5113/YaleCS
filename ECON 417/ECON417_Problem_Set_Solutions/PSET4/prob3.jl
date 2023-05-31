
include("ps4_functions.jl")

# returns sum of squared excess demands
function ss_excess_demand(p; a=0.1, b=1.0, ϵ=1.0)
    pbar = sum(p) / length(p)
    excessDemand = b.*(p./pbar).^(-ϵ) - (exp.(a.*p) .- 1.0)
    return sum(excessDemand.^2)
end

# first solve for symmetric p* (default parameter values)
~,pstar0,~,niter = newton_optim(p -> ss_excess_demand(p), [1,1])
println("symmetric p* = $pstar0 (niter = $niter)")

# then solve for p* when demand for good A goes up by 10%
~,pstar1,~,niter = newton_optim(p -> ss_excess_demand(p; b=[1.1,1.0]), pstar0)
println("new p* = $pstar1 (niter = $niter)")