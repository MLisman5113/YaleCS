# 0
# include a .jl file containing some functions
include("f_eg_bisection.jl")



# 1
# At the step of entering delta, try using decimals if scientific notation doesn't work
# credit to Jacques



# 2(a)
# "let ϵ range across all the values in the set" -> for loop
# "For which value of ϵ is the approximate first derivative the most accurate?"
# find the minimum in a column of a matrix and return the row index 
A=[1e-1 0.15;
1e-2 0.13;
1e-3 0.115;
1e-4 0.11;
1e-5 0.108;
1e-6 0.107;
1e-7 0.11;
1e-8 0.115;
1e-9 0.13;
1e-10 0.15;
]
println(minimum(A[:,2]))
println(A[argmin(A[:,2]),1])




# 3(c)
# Remember that when we find the root of f(x) using successive approximations,
# we are iterating on g(x)=f(x)+x
# 3(d)
# Compare the speed of different functions
using BenchmarkTools
f(x) = x*sin(x^(2/3)) - sqrt(x) + 10
print(@benchmark bisect($f, 0, 10, verbose=0))