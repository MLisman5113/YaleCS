n = 3
x = zeros(n)
y = zeros(n,n)

x[1] = 2
x[3] = 3

y[2,3] = 5

# array with floating point numbers with 2 indices of 4x2 (row by columns)
z = Array{Float64, 2}(undef,4,2)

println(x)
println(y)
println(z)
println(typeof(x))
