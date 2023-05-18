include("rootfinders.jl")

# this causes error when running script but not when running on REPL
function f(x,y)
    return ((x-2)^2+(y-1)^2, (x+y)^2)
end
funciter(f, [1.0,2.0]; stepsize=1, toler=1.0e-6, mxiter=100, verbose=1)
# it is because of the function input value 





# this code has another error
# function f(x)
#     return ((x[1]-2)^2+(x[2]-1)^2, (x[1]+x[2])^2)
# end
# funciter(f, [1.0,2.0]; stepsize=1, toler=1.0e-6, mxiter=100, verbose=1)
# It is becasue the return type




function f(x)
    return [(x[1]-2)^2+(x[2]-1)^2, (x[1]+x[2])^2]
end
funciter(f, [1,2]; stepsize=1, toler=1.0e-6, mxiter=100, verbose=1)
# The code can run but give weird results, let's see some intermediate output 
funciter(f, [1,2]; stepsize=1, toler=1.0e-6, mxiter=100, verbose=2)
# The output is absurd 
newton(f, [1,2]; mxiter=100, verbose=2)
# The output looks better, but still, it does not converge to the root


function f(x)
    return [x[1]^2+x[2]^2, (x[1]+x[2])^2]
end
newton(f, [1,2]; mxiter=100, verbose=2)