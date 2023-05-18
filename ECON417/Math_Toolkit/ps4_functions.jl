
using Formatting, LinearAlgebra

# returns grid of N equally-spaced points on interval [xmin, xmax]
function createGrid(xmin, xmax, N)
    step = (xmax-xmin) / (N-1)
    return collect(xmin:step:xmax)
end

# returns the two-sided numerical derivative of f at x, given increment h
function numderiv(f, x; h=1.0e-6)
    return (f(x+h) - f(x-h))/(2h)
end

# computes the numerical Jacobian for a multidimensional function f: R^N -> R^M
function numjacobian(f::Function, x; h=1e-6)
    N = length(x); M = length(f(x))
    if (N == 1 && M == 1) # f: R -> R, just take two-sided numerical derivative
        return numderiv(f, x, h=h)
    else
        vv = zeros(N,N) + Diagonal(fill(h,N)) # matrix of basis column vectors (identity matrix) scaled by h
        return [(f(x+vv[:,i])[j] - f(x-vv[:,i])[j]) / (2h) for i in 1:N, j in 1:M]
    end
end

# Newton's method for f: R^N -> R^N (N=1 ok); can use numerical or analytic Jacobian (numerical by default). λ is dampening factor (0 by default).
function newton(f::Function, x0; Df::Function=(x->numjacobian(f,x)), λ=0, toler=1.0e-6, mxiter=100)
    
    fx0 = f(x0)
    maxdiff = maximum(abs.(fx0))
    niter = 0

    while (maxdiff > toler && niter < mxiter)
        niter += 1
        J = Df(x0)
        xcur = x0 .- (1-λ) * inv(J) * fx0
        maxdiff = maximum(abs.(xcur .- x0))
        fxcur = f(xcur)
        x0 = xcur
        fx0 = fxcur
    end

    return x0, niter
end

# version of Newton's method to minimize/maximize a function f; note that this is just like applying regular Newton's method to grad(f)
function newton_optim(f::Function, x0; Df::Function=(x->numjacobian(f,x)), D2f::Function=(x->numjacobian(Df,x)), λ=0, toler=1.0e-6, mxiter=100)
    x0, niter = newton(Df, x0, Df=D2f, λ=λ, toler=toler, mxiter=mxiter)
    
    hess = det(D2f(x0))
    type = "min"^(hess>0) * "max"^(hess<0) * "saddle"^(hess==0) # is minimum/maximum if Hessian is positive/negative semi-definite
    
    return f(x0), x0, type, niter
end
    
