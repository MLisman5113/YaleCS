#= using Pkg
Pkg.add("Printf") =#

using Printf
include("volatility_calculator.jl")

function calculate_option_price(S0, K, r, T, σ, N, option_type, exercise_type)
    Δt = T / N
    u = exp(σ * sqrt(Δt))
    d = 1 / u
    p = (exp(r * Δt) - d) / (u - d)

    stock_prices = zeros(N + 1, N + 1)
    option_prices = zeros(N + 1, N + 1)

    for i in 0:N
        stock_prices[i + 1, N + 1] = S0 * u^i * d^(N - i)
        if option_type == "call"
            option_prices[i + 1, N + 1] = max(0, stock_prices[i + 1, N + 1] - K)
        else
            option_prices[i + 1, N + 1] = max(0, K - stock_prices[i + 1, N + 1])
        end
    end

    for j in N-1:-1:0
        for i in 0:j
            option_prices[i + 1, j + 1] = exp(-r * Δt) * (p * option_prices[i + 2, j + 2] + (1 - p) * option_prices[i + 1, j + 2])

            if exercise_type == "american"
                if option_type == "call" # call option computation
                    option_prices[i + 1, j + 1] = max(option_prices[i + 1, j + 1], stock_prices[i + 1, j + 1] - K)
                else # put option computation
                    option_prices[i + 1, j + 1] = max(option_prices[i + 1, j + 1], K - stock_prices[i + 1, j + 1])
                end
            end
        end
    end

    return option_prices[1, 1]
end

S0 = 100.0  # Stock price at t=0
K = 100.0  # Strike price
r = 0.046  # Risk-free rate provided by the Treasury
T = 19/252  # Time to maturity (divide number of trading days left (no weekends and holidays to maturity by 252)
σ = 0.2  # Volatility
N = 100  # Number of time steps
option_type = "call"  # "call" or "put"
exercise_type = "american"  # "american" or "european"

#option_price = calculate_option_price(S0, K, r, T, σ, N, option_type, exercise_type)
#@printf "The price of the %s %s option is: %.2f\n" exercise_type option_type option_price

all_S0 = [148.69,102.41,166.17,76.09,494.19,116.13,310.31,104.36,363.77,162.28]
all_K = [144.00,101.00,165.00,67.00,475.00,103.00,310.00,101.00,347.50,160.00]
volatilities = output()[1]
tickers = output()[2]


all_option_prices = []
for i in range(1,10)
    push!(all_option_prices, calculate_option_price(all_S0[i],all_K[i],r,T,volatilities[i],19,"call", "american"))
end

for (i, ticker) in enumerate(tickers)
    S0 = all_S0[i]
    K = all_K[i]
    σ = volatilities[i]
    option_price = all_option_prices[i]
    @printf "Ticker: %s\n Day 0 Stock Price: %.2f\n Strike Price: %.2f\n Volatility: %.2f\n Calculated Option Price: %.2f\n\n" ticker S0 K σ option_price
end