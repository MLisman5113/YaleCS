# where to access the variables

# integer
a=1
typeof(a)
a

# float
a=1.0
typeof(a)
a

# boolean
a=true
typeof(a)
a

# create a variable of specific type
x::Int8=100
typeof(x)
x
x=2.1
x=128

# vector and matrix
A=[1,2,3] # a column vector
# A = Vector{Int64}([1, 2, 3])
# A[1]=2.5 
A=[1;2;3] # a column vector
A=[1 2 3] # a row vector, in fact a matrix
A[1] # start from 1, not 0
A[end]
A[end-1]
length(A)

A[1]=10

# add and pop out element
push!(A, 5)
length(A)
pushfirst!(A, 5)
length(A)
pop!(A)
length(A)
popfirst!(A)
length(A)

# append another vector
append!(A, [5, 6, 7])
sum(A)
using Statistics
mean(A)

# create a matrix
A=[1 2 3;4 5 6]
eltype(A)
ndims(A)
size(A)
length(A)

# create a 3D matrix
A=zeros(3,3,3)
ndims(A)
size(A)
length(A)

# declare a matrix with values to be filled
A = Array{Int64, 3}(undef, 3, 3, 3)
A[1,1,1]=1
A[1:3,1:3,1].=10

# append matrix
A=[1 2;3 4]
B=[3 4;5 6]
[A;B]
[A B]

# String
s="I love Econ 417"
typeof(s)
s[1:3]
v=" Me too"
p=s*v
replace(p, "Me too" => "I don't")

# Tuple
t=(A,p)
t[1]
t[2]
t[2][17:end]
B,q=t

# a note
a=1
b=a
a=2
b
