function cake_eating(beta::Float64, N::Int)
    # Initialize cake grid
    cgrid = range(0.0, 1.0, length=N)

    # Initialize value function
    V = zeros(N)

    # Set tolerance level
    tol = 0.01

    # Iterate until convergence
    while true
        # Compute expected future value
        EV = (V' * ones(1, N)) ./ N
        println(EV)

        # Compute current value function
        V_new = max.(cgrid .^ (-2) .+ beta * EV, cgrid)

        # Check convergence
        if maximum(abs.(V_new - V)) < tol
            break
        end

        V .= V_new
    end

    return V
end

# Set parameters
beta = 0.9
N = 21

# Solve the cake-eating problem
V = cake_eating(beta, N)

using Plots
plot(range(0, 1, length=N), V, xlabel="Cake", ylabel="Value", label="Optimal value")

