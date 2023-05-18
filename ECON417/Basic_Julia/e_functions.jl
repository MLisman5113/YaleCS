# function examples

# 1
# function f(x,y)
#     return x + y
# end

# 2
# f(x,y) = x + y

# println(f(1,2))

# return multiple values
# function f(x,y)
#     return (x + y, x*y)
# end
# (a,b)=f(1,2)
# println(f(1,2))

# pass functions to functions
# function f(g,x,y)
#     return g(x) + g(y)
# end
# g(x)=2*x
# h(x)=3*x
# println(f(g,1,2))
# println(f(h,1,2))

# default values
# f(x=1,y=1) = x + y
# println(f())
# println(f(1,2))

# parameters
# f(x=1,y=1;c=100,d=100) = c * x + d * y
# println(f())
# println(f(1,2))
# println(f(1,2;c=2,d=2))
# println(f(1,2;d=2,c=2))

# pass a vector
# sin(1)
# sin.([1,2,3])

# a pop question
# f(x)=x^2
# fp(x;delta=1e-6)=(f(x*(1+delta))-f(x))/(delta*x)
# println(fp(1))
# f(x)=x^3 # redefine f
# println(fp(1))