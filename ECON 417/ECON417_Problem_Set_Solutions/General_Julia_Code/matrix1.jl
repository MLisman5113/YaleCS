# This code illustrates basic operations with matrices.

# First import Julia's linear algebra package:
using LinearAlgebra

n = 2

# To create an nxn matrix of zeros:
a = zeros(n,n)

# To create an nxn matrix of ones:
b = ones(n,n)

# To create an nxn identity matrix:
eye = Matrix(1.0*I,n,n)

# To create an arbitrary 2x2 matrix:
c = [1 2; 3 4]

# To change an element of a matrix:
c[1,2] = 5

# To add two matrices:
d = b + c

# To multiply two matrices:
e = c*d

# To invert a matrix:
cinv = inv(c)

# To add a constant to a matrix:
f = c .+ 1.0

# To subtract a constant from a matrix:
g = c .- 1.0

# To take the transpose of a matrix:
h = f'

# To create an arbitray (column) vector:
v = [1; 2]

# To create a vector of ones:
w = ones(n)

# To multiply the transpose of w and a (conforming) matrix:
x = w'c













