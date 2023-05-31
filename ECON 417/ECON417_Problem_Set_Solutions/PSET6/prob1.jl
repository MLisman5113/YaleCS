
using Formatting, Plots, LaTeXStrings
include("spline1.jl")
pyplot()

# returns linearly interpolated function value at x, based on grids xpts and ypts
function lininterp(x, xpts, ypts)
    if x < xpts[1] || x > xpts[length(xpts)]
        error("x = $x is outside of the grid domain.")
    end
    
    i = findlast(xpts .<= x) # index of interval to use

    if x == xpts[i] # really only useful if we're at the grid upper bound
        return ypts[i]
    else
        slope = (ypts[i+1]-ypts[i]) / (xpts[i+1]-xpts[i]) # slope over interval
        return ypts[i] + slope*(x-xpts[i])
    end
end

# (1) define parameters and create x and y grids
f(x) = sin(x)
lb = 0; ub = 2π
N = 11 # number of grid points used for interpolation
xpts = creategrid(lb, ub, N) # grid used for interpolation
ypts = f.(xpts)

# (2) compute interpolated y values (linear and spline)
M = 200 # number of points to be interpolated
xfine = creategrid(lb, ub, M) # grid used for plotting and testing
ylinearpts = broadcast(x->lininterp(x, xpts, ypts), xfine) # linearly interpolated y values
yspline = makespline(xpts, ypts) # function defined in spline1.jl
ysplinepts = broadcast(x->interp(x, yspline)[1], xfine) # spline interpolated y values

# (3) compute and plot errors
ytrue = f.(xfine)
errlinear = ylinearpts - ytrue
errspline = ysplinepts - ytrue

printfmtln("Linear interpolation (N=$N):\nMean abs error = {1:.3e}, max abs error = {2:.3e}\n",
    sum(abs.(errlinear))/M, maximum(abs.(errlinear)))
printfmtln("Cubic spline interpolation (N=$N):\nMean abs error = {1:.3e}, max abs error = {2:.3e}\n",
    sum(abs.(errspline))/M, maximum(abs.(errspline)))

p1 = plot(xfine, [ytrue ylinearpts ysplinepts], label=["y(x)" "Linear" "Cubic spline"], color=[:black :blue :red],
    title="True and interpolated function values (N = $N)", xlabel=L"x", ylabel=L"$y$ or $\hat{y}$")
scatter!(xpts, ypts, label=false)
p2 = plot(xfine, [errlinear errspline], label=["Linear" "Cubic spline"], color=[:blue :red],
    title="Approximation error (N = $N)", xlabel=L"x", ylabel=L"\hat{y}-y")
plot(p1, p2, layout=(2,1), size=(600,900))

