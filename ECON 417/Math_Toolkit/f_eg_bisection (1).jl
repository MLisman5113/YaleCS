using Formatting

function bisect(f, a, b; toler=1.0e-6, mxiter=30, verbose=1)

    if (f(a)*f(b) > 0)
        error("Root not bracketed.")
    elseif (a > b)
        error("Brackets out of order.")
    else

        diff = b - a

        downwardsloping = (f(a) > 0)

        xlow = a
        xhigh = b
        niter = 0

        while (diff > toler && niter < mxiter)
            niter += 1
            xcur = (xlow + xhigh)/2
            fxcur = f(xcur)

            if downwardsloping
                if (fxcur > 0)
                    xlow = xcur
                else
                    xhigh = xcur
                end
            else
                if (fxcur > 0)
                    xhigh = xcur
                else
                    xlow = xcur
                end
            end

            diff = abs(xhigh - xlow)

            if verbose >= 2
                printfmtln("niter = {1:3d},  xlow = {2:12.8f},  xhigh = {3:12.8f},  xcur = {4:12.8f},  f(xcur) = {5:14.10f},  diff = {6:14.10f}", niter,xlow,xhigh,xcur,fxcur,diff)
            end

        end
        
        bisect = (xlow+xhigh)/2

        if (diff <= toler) && (verbose >= 1)
            printfmtln("Bisection method converged to {1:.8f} in {2:d} iterations (f(sol) = {3:.3e})", bisect, niter, f(bisect))
        elseif (diff > toler)
            printfmtln("Did not converge in {1:d} iterations: diff = {2:6.3e}, xcur = {3:10.6f}, f(xcur) = {4:6.3e}", niter, diff, xcur, f(bisect))
        end

        return bisect

    end

end

# using Formatting
# using Plots
# f(x) = x^3
# # plot(range(-2,1,100),f.(range(-2,1,100)))
# bisect(f,-2,1;verbose=2)


# using BenchmarkTools
# @benchmark bisect(f, -2, 1, verbose=0)
# @benchmark bisect(f, -20, 20, verbose=0)