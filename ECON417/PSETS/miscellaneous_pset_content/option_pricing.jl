function binomial_lattice_option_price(S0, K, r, sigma, T, N, exercise_type)
    dt = T / N
    u = exp(sigma * sqrt(dt))
    d = 1 / u
    p = (exp(r * dt) - d) / (u - d)
    disc = exp(-r * dt)
    prices = zeros(N+1, N+1)
    
    # Initialize the final prices
    for j in 0:N
        prices[j+1, N+1] = max(0, S0 * u^j * d^(N-j) - K)
    end
    
    # Work backwards through the lattice
    for i in N-1:-1:0
        for j in 0:i
            early_exercise_value = max(0, S0 * u^j * d^(i-j) - K)
            expected_future_value = p * prices[j+1, i+1+1] + (1-p) * prices[j+1+1, i+1+1]
            if exercise_type == "American"
                prices[j+1, i+1] = max(early_exercise_value, disc * expected_future_value)
            elseif exercise_type == "European"
                prices[j+1, i+1] = disc * expected_future_value
            else
                error("Invalid exercise type: $exercise_type")
            end
        end
    end
    
    return prices[1,1]
end


binomial_lattice_option_price(100, 98, 0.04, 0.3, 4/52, 4, "American")