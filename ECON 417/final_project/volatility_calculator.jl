#= using Pkg
Pkg.add("CSV")
Pkg.add("DataFrames")
Pkg.add("Statistics") =#

using CSV
using DataFrames
using Statistics


###### HELPER FUNCTIONS TO READ STOCK DATA, CALCULATE LOG RETURNS, AND VOLATILITY  #########
function read_stock_data(file_path)
    data = CSV.read(file_path, DataFrame)
    return data
end

function calculate_log_returns(prices)
    log_returns = log.(prices[2:end] ./ prices[1:end-1])
    return log_returns
end

function calculate_historical_volatility(log_returns)
    trading_days = 252
    volatility = std(log_returns) * sqrt(trading_days)
    return volatility
end

##########  OUTPUT FUNCTION TO RETURN THE STOCK TICKERS AND ARRAY OF VOLATILITIES  ########

function output()
    file_path = "ECON417_company_data3.csv" # Replace this with the path to your CSV file containing stock data.
    data = read_stock_data(file_path)
    tickers = names(data)
    volatilities = []

    for ticker in tickers
        prices = data[:, ticker]
        log_returns = calculate_log_returns(prices[2:end])
        volatility = calculate_historical_volatility(log_returns)
        push!(volatilities, volatility)
    end

    return volatilities, tickers
end

########## END OF PROGRAM ########