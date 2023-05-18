import Pkg
Pkg.add("BenchmarkTools")

function g(x)
    g = ((1x^(-1)) - (exp(0.1x) - 1))
 end

 function h(x)
    h = ((1.1x^(-1)) - (exp(0.1x) - 1))
 end

function fixedpt(g::Function,p_zero,epsilon,numiter)
    n = 1
    while n < numiter
        println(p_zero)
        p_one = g(p_zero) + p_zero
        if abs(p_one - p_zero) < epsilon
            return println("p is $p_one. Iteration number: $n")
        end
        p_zero = p_one
        n += 1
    end
    println("The function did not converge. The last estimate is p = $p_zero.")
end

fixedpt(x->g(x),2.5,10^(-4),30)

# gets the computation speed based on the number of iterations 
using BenchmarkTools
println(@benchmark fixedpt(x->g(x),2.5,10^(-4),30))
println(@benchmark fixedpt(x->h(x),2.5,10^(-4),30))

function f(x)
    f = (1x^(-1))
end

function z(x)
    z = (1.1x^(-1))

println(f(2.933113492024196))
println(z(3.065646080852911))