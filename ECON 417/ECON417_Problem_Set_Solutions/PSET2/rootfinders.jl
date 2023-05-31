
using Formatting, LinearAlgebra

# returns string version of array with formatted numbers
function strarray(array, format)
    I = size(array, 1); J = size(array, 2)

    if (I==1 && J==1) # scalar case
        return sprintf1(format, array)
    end

    str = "["
    for i in 1:I
        for j in 1:J
            str *= sprintf1(format, array[i,j])
            if j < J; str *= ", "; end
        end
        if i < I; str *= "; "; end
    end
    return str * "]"
end

# function iteration for f: R^N -> R^N (N=1 ok)
function funciter(f::Function, x0; stepsize=1, toler=1.0e-6, mxiter=100, verbose=1)

    fx0 = f(x0)
    maxdiff = maximum(abs.(fx0))
    niter = 0

    while (maxdiff > toler && niter < mxiter)
        niter += 1
        xcur = stepsize.*fx0 .+ x0
        fxcur = f(xcur)
        maxdiff = maximum(abs.(xcur .- x0))

        if verbose >= 2
            printfmtln("niter = {1:d},  xcur = {2},  maxdiff = {3:10.4e},  f(xcur) = {4}", 
                niter, strarray(xcur,"%12.8f"), maxdiff, strarray(fxcur,"%11.4e"))
        end

        x0 = xcur
        fx0 = fxcur
    end

    xcur = stepsize.*fx0 .+ x0

    if (maxdiff <= toler) && (verbose >= 1)
        println("Converged to $(strarray(xcur,"%.8f")) in $niter iterations (f(sol) = $(strarray(f(xcur),"%.2e")))")
    elseif (maxdiff > toler)
        println("Did not converge in $niter iterations: maxdiff = $maxdiff, xcur = $xcur, f(xcur) = $(f(xcur))")
    end

    return xcur
end

# computes the numerical Jacobian for a multidimensional function f: R^N -> R^M
function numjacobian(f::Function, x; h=1e-6)
    N = length(x); M = length(f(x))
    if (N == 1 && M == 1) # f: R -> R, just take two-sided numerical derivative
        return (f(x+h) - f(x-h)) / (2h)
    else
        vv = zeros(N,N) + Diagonal(fill(h,N)) # matrix of basis column vectors (identity matrix) scaled by h
        return [(f(x+vv[:,i])[j] - f(x-vv[:,i])[j]) / (2h) for i in 1:N, j in 1:N]
    end
end

# Newton's method for f: R^N -> R^N (N=1 ok); can use numerical or analytic Jacobian (numerical by default). λ is dampening factor (0 by default).
function newton(f::Function, x0; Df::Function=(x->numjacobian(f,x)), λ=0, toler=1.0e-6, mxiter=100, verbose=1)
    
    fx0 = f(x0)
    maxdiff = maximum(abs.(fx0))
    niter = 0

    if length(fx0) != length(x0)
        error("f must map x from R^N to R^N.")
    end

    if (size(fx0,2) > 1 || size(x0,2) > 1)
        error("f and x must be column, not row, vectors.")
    end

    while (maxdiff > toler && niter < mxiter)
        niter += 1
        J = Df(x0)
        J_inv = 1

        # embed inversion of Jacobian in try/catch in case it's singular
        try
            J_inv = inv(J)
        catch e
            error("Jacobian isn't invertible at x, can't proceed.")
        end

        xcur = x0 .- (1-λ) * J_inv * fx0
        maxdiff = maximum(abs.(xcur .- x0))
        fxcur = f(xcur)
    
        if verbose >= 2
            printfmtln("niter = {1:d},  xcur = {2},  maxdiff = {3:10.4e},  f(xcur) = {4}", 
                niter, strarray(xcur,"%12.8f"), maxdiff, strarray(fxcur,"%11.4e"))
        end

        x0 = xcur
        fx0 = fxcur
    end

    if (maxdiff <= toler) && (verbose >= 1)
        println("Converged to $(strarray(x0,"%.8f")) in $niter iterations (f(sol) = $(strarray(fx0,"%.2e")))")
    elseif (maxdiff > toler)
        println("Did not converge in $niter iterations: maxdiff = $maxdiff, xcur = $x0, f(xcur) = $fx0")
    end

    return x0
end

# Implement Brent's method for finding the root of a one-dimensional function.  See 
# Chapter 9.3 in Numerical Recipes in Fortran 77 for a detailed description of the function 
# zbrent.
function zbrent(fct, x1, x2, rtol, ftol; verbose=1)
    # x1 and x2 must bracket the root.  rtol and ftol are convergence tolerances, the 
    # first for the root itself and the second for the function value.  zbrent returns
    # the value of the root.
    
    global d,e
    
    itmax = 100
    toler = 1.0e-12
    tol1 = rtol
    
    a = x1
    b = x2
    fa = fct(a)
    fb = fct(b)
    if (fb*fa > 0.0)
        error("Root must be bracketed in zbrent: $a, $b, $fa, $fb")
    end
       
    c = b
    fc = fb
    
    for iter in 1:itmax
       
        if (fb*fc > 0.0) 
            c = a
            fc = fa
            d = b - a
            e = d
        end
        
        if (abs(fc) < abs(fb))
            a = b
            b = c
            c = a
            fa = fb
            fb = fc
            fc = fa
        end
        
        xm = 0.5*(c-b)

        if verbose >= 2
            printfmtln("niter = {1:d},  xb = {2:12.8f},  xm = {3:11.4e},  f(xb) = {4:11.4e}", iter, b, xm, fb)
        end
        
        if ((abs(xm) <= tol1) | (abs(fb) <= ftol))
            if verbose >= 1
                printfmtln("Converged to {1:.8f} in $iter iterations (f(sol) = {2:.2e})", b, fb)
            end
            return b
        end

        if ( (abs(e) >= tol1) & (abs(fa) > abs(fb)) )
            s = fb/fa
            if (abs(c-a) <= toler) 
                p = 2.0*xm*s
                q = 1.0 - s
            else
                q = fa/fc
                r = fb/fc
                p = s*(2.0*xm*q*(q-r)-(b-a)*(r-1.0))
                q = (q-1.0)*(r-1.0)*(s-1.0)
            end
            if (p > 0) 
                q = -q
            end   
            p = abs(p)
            term1 = 2.0*p
            term2 = min(3.0*xm*q-abs(tol1*q),abs(e*q))
            if (term1 < term2) 
                e = d
                d = p/q
            else
                d = xm
                e = d
            end
        else
            d = xm
            e = d
        end
        a = b
        fa = fb
        if (abs(d) > tol1) 
            b = b + d
        else
            b = b + abs(tol1)*sign(xm)
        end
        fb = fct(b)
            
    end

    error("zbrent exceeding maximum number of iterations")
    
end    
    
    