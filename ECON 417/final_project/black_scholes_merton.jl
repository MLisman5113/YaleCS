#= using Pkg
Pkg.add("Distributions")
Pkg.add("FinancialToolbox")
Pkg.add("Printf") =#

using Printf
using Distributions
using FinancialToolbox
include("volatility_calculator.jl")

#####  DEFINING THE BLACK-SCHOLES-MERTON METHOD  ##########

function black_scholes_merton(S0, K, r, T, sigma, option_type)
    d1 = (log(S0 / K) + (r + 0.5 * sigma^2) * T) / (sigma * sqrt(T))
    d2 = d1 - sigma * sqrt(T)

    if option_type == "call"
        price = S0 * normcdf(d1) - K * exp(-r * T) * normcdf(d2)
    elseif option_type == "put"
        price = K * exp(-r * T) * normcdf(-d2) - S0 * normcdf(-d1)
    else
        println("Error: Invalid option type")
        price = NaN
    end

    return price
end

##########  VARIABLES  ##########

r = 0.046  # Risk-free rate provided by the Treasury
T = 18/252  # Time to maturity (divide number of trading days left (no weekends and holidays to maturity by 252))
all_S0 = [148.69,102.41,166.17,76.09,494.19,116.13,310.31,104.36,363.77,162.28] # Stock price at t = 0 (April 4, 2023)
all_K = [146.00,101.00,165.00,68.00,475.00,103.00,310.00,101.00,347.50,160.00] # Strike price

volatilities = output()[1] # Call output function from volatility_calculator.jl to get the array of historical volatilities
tickers = output()[2]
actual_option_prices_at_expiration = [4.45,4.70,4.62,9.70,18.70,15.78,18.75,6.19,16.43,8.06] # April 28, 2023 Expiration
actual_option_prices = [3.72,6.7,4.72,8.45,25.88,12.78,6.2,6.6,16.45,5.35] # April 4, 2023

############  CALCULATING OPTION PRICES USING BLACK-SCHOLES-MERTON METHOD   ################

all_option_prices = []

for m in 1:10
    option_price = black_scholes_merton(all_S0[m], all_K[m], r, T, volatilities[m], "call")
    push!(all_option_prices, option_price)
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
    
    @printf "Ticker & %s\n Day 0 Stock Price & %.2f\n Strike Price & %.2f\n Volatility & %.2f\n Calculated Option Price on 4/4/2023 & %.2f\n Actual Option Price on 4/4/2023 & %.2f\n Difference & %.2f\n\n" ticker S0 K σ calculated_option_price actual_price difference
end
##########  END OF PROGRAM  ########