import Pkg
Pkg.add("BenchmarkTools")


# the secant function executes the secant method of finding the numerical derivative
# it takes in a function, an initial pair of values, an epsilon, and the max number of iterations you want to run
function secant(f::Function,p_zero,p_one,epsilon,numiter)
    n = 1
    p = 0.0 # to ensure the value of p carries out of the while loop
    while n <= numiter
        p = p_one - f(p_one)*(p_one-p_zero)/(f(p_one)-f(p_zero))
        if f(p) == 0 || abs(p - p_one) < epsilon
            return println("p is $p. Iteration number: $n")
            end
        p_zero = p_one
        p_one = p
        n += 1
    end

    y = f(p)
    println("No convergence. The last iteration yields $p with the function value $y")
end

# these call the secant function with the function values, initial values, an epsilon, and the number of iterations for both the original function and when the demand increases by 10% (i.e. b increasing by 10%)
secant(x-> ((1x^(-1)) - (exp(0.1x) - 1)), 1.0,5.0,10^(-4.0), 100)
secant(x-> ((1.1x^(-1)) - (exp(0.1x) - 1)), 1.0,5.0,10^(-4.0), 100)

function h(x)
    h = (1x^(-1))
end

function g(x)
    g = (1.1x^(-1))
end

# the program now takes the x values calculated by the secant function and plugs them into the original functions to get the y-value, which corresponds to the price
println(h(2.9334108244451977))
println(g(3.0659062713238323))

# gets the computation speed based on the number of iterations 
using BenchmarkTools
print(@benchmark secant(x-> ((1x^(-1)) - (exp(0.1x) - 1)), 1.0,5.0,10^(-4.0), 100))
print(@benchmark secant(x-> ((1.1x^(-1)) - (exp(0.1x) - 1)), 1.0,5.0,10^(-4.0), 100))