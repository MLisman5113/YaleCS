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

function secant(f, x0, x1; toler=1.0e-6, mxiter=30, verbose=1)

    diff = abs(x1 - x0)

    if (diff <= toler)
        wait("Must choose x0 and x1 such that |x1-x0| > toler.")
    end

    niter = 0

    while (diff > toler && niter < mxiter)
        niter += 1
        xcur = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0))

        diff = abs(xcur - x1)

        if verbose >= 2
            printfmtln("niter = {1:3d},  x0 = {2:12.8f},  x1 = {3:12.8f},  xcur = {4:12.8f},  f(xcur) = {5:14.10f},  diff = {6:14.10f}", niter,x0,x1,xcur,f(xcur),diff)
        end

        x0 = x1
        x1 = xcur
    end

    xcur = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0))

    if (diff <= toler) && (verbose >= 1)
        printfmtln("Secant method converged to {1:.8f} in {2:d} iterations (f(sol) = {3:.3e})", xcur, niter, f(xcur))
    elseif (diff > toler)
        printfmtln("Did not converge in {1:d} iterations: diff = {2:6.3e}, xcur = {3:10.6f}, f(xcur) = {4:6.3e}", niter, diff, xcur, f(xcur))
    end

    return xcur

end

function funciter(f, x0; stepsize=1, toler=1.0e-6, mxiter=100, verbose=1)

    fx0 = f(x0)
    diff = abs(fx0)
    niter = 0

    while (diff > toler && niter < mxiter)
        niter += 1
        xcur = stepsize*fx0 + x0
        fxcur = f(xcur)
        diff = abs(xcur - x0)

        if verbose >= 2
            printfmtln("niter = {1:3d},  xcur = {2:12.8f},  f(xcur) = {3:14.10f},  diff = {4:14.10f}", niter, xcur, fxcur, diff)
        end

        x0 = xcur
        fx0 = fxcur
    end

    xcur = stepsize*fx0 + x0

    if (diff <= toler) && (verbose >= 1)
        printfmtln("Function iteration converged to {1:.8f} in {2:d} iterations (f(sol) = {3:.3e})", xcur, niter, f(xcur))
    elseif (diff > toler)
        printfmtln("Did not converge in {1:d} iterations: diff = {2:6.3e}, xcur = {3:10.6f}, f(xcur) = {4:6.3e}", niter, diff, xcur, f(xcur))
    end

    return xcur

end
