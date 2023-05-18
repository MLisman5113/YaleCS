
n=3


v=[1,2,3]

# 1
v = Array{Int64, 1}(undef, 3)
for i = 1:n
    v[i] = i
end

# 2
v = Array{Int64, 1}(undef, 3)
for i = eachindex(v)
    v[i] = i
end

# 3
for i = [1,3]
    v[i]=100*i
end

# comprehension
C = [ 2i for i in 1:4 ]
D = [ 2*i + j for i in 1:3, j in 4:6 ]
