#= using Pkg
Pkg.add("Printf") =#

using Printf
include("volatility_calculator.jl")

###########   DEFINING THE BINOMIAL LATTICE METHOD  ###############

function binomial_lattice(S0, K, r, T, σ, N, option_type, exercise_type)
    Δt = T / N
    u = exp(σ * sqrt(Δt))
    d = 1 / u
    p = (exp(r * Δt) - d) / (u - d)

    stock_prices = zeros(N + 1, N + 1)
    option_prices = zeros(N + 1, N + 1)
    optimal_days = fill(N, N + 1, N + 1)  # Initialize optimal days matrix

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
            early_exercise = option_type == "call" ? (stock_prices[i + 1, j + 1] - K) : (K - stock_prices[i + 1, j + 1])
            continuation_value = exp(-r * Δt) * (p * option_prices[i + 2, j + 2] + (1 - p) * option_prices[i + 1, j + 2])

            if exercise_type == "american" && early_exercise >= continuation_value
                option_prices[i + 1, j + 1] = early_exercise
                optimal_days[i + 1, j + 1] = j
            else
                option_prices[i + 1, j + 1] = continuation_value
            end
        end
    end

    return option_prices[1, 1], optimal_days[1, 1]
end

########### VARIABLES  ##########

r = 0.046  # Risk-free rate provided by the Treasury
T = 18/252  # Time to maturity (divide number of trading days left (no weekends and holidays to maturity by 252)
N = 18  # Number of trading days from 04/04/2023 to 04/28/2023
all_S0 = [148.69,102.41,166.17,76.09,494.19,116.13,310.31,104.36,363.77,162.28] # Stock price at t = 0 (April 4, 2023)
all_K = [146.00,101.00,165.00,68.00,475.00,103.00,310.00,101.00,347.50,160.00] # Strike price
volatilities = output()[1]
tickers = output()[2]

actual_option_prices_at_expiration = [4.45,4.70,4.62,9.70,18.70,15.78,18.75,6.19,16.43,8.06] # April 28, 2023 Expiration
actual_option_prices = [3.72,6.7,4.72,8.45,25.88,12.78,6.2,6.6,16.45,5.35] # April 4, 2023
############  CALCULATING OPTION PRICES USING THE BINOMIAL LATTICE METHOD   ################

all_option_prices = []
all_optimal_execution_days = []
for m in 1:10
    option_price, optimal_execution_day = binomial_lattice(all_S0[m], all_K[m], r, T, volatilities[m], 19, "call", "american")
    push!(all_option_prices, option_price)
    push!(all_optimal_execution_days, optimal_execution_day)
end

############  PRINTING THE OUTPUT FOR EACH COMPANY WITH THE OPTION PRICE   ###########

# Iterate through each combination of stock ticker, stock price, strike price, and volatility
for (i, ticker) in enumerate(tickers)
    S0 = all_S0[i]
    K = all_K[i]
    σ = volatilities[i]
    calculated_option_price = all_option_prices[i]
    actual_price = actual_option_prices[i]
    difference = abs(actual_price - calculated_option_price)

    expiration_price = actual_option_prices_at_expiration[i]
    prediction_difference = expiration_price - actual_price
    
    optimal_day = all_optimal_execution_days[i]
    
    if optimal_day == 19
        @printf "Ticker & %s\n Day 0 Stock Price & %.2f\n Strike Price & %.2f\n Volatility & %.2f\n Calculated Option Price on 4/4/2023 & %.2f\n Actual Option Price on 4/4/2023 & %.2f\n Difference & %.2f\n Exercise before Expiration Date & No\n Actual Price on Expiration Date & %.2f\n 4/4/23 vs. 4/28/23 Difference & %.2f\n\n" ticker S0 K σ calculated_option_price actual_price difference expiration_price prediction_difference
    else
        @printf "Ticker & %s\n Day 0 Stock Price & %.2f\n Strike Price & %.2f\n Volatility & %.2f\n Calculated Option Price on 4/4/2023 & %.2f\n Actual Option Price on 4/4/2023 & %.2f\n Difference & %.2f\n Exercise before Expiration Date & Yes\n Actual Price on Expiration Date & %.2f\n 4/4/23 vs. 4/28/23 Difference & %.2f\n\n" ticker S0 K σ calculated_option_price actual_price difference expiration_price prediction_difference
    end
end

####### END OF PROGRAM ################