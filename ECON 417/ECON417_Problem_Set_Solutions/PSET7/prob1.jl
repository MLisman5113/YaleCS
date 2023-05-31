using DataFrames
include("gauher1.jl")

n = 5 # change this value to see how it affects the approximation
σs = [1,2,3]; μ = 1

(w, x) = gauher(n) # get Gauss-Hermite weights and abscissas (depend only on n)

function lognormquad(w, x, μ, σ)
    quad = π^(-0.5) * sum(w .* exp.(σ*x*sqrt(2) .+ μ))
    exact = exp(μ + σ^2/2)
    return quad, exact
end

df = DataFrame(broadcast(σ->lognormquad(w, x, μ, σ), σs)) # for each σ, calculate approximate and exact integral
rename!(df, ["quadrature", "exact"])
insertcols!(df, 1, :σ=>σs)

println("Using n = $n:")
println(df)