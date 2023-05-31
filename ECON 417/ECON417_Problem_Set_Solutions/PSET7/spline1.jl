# This file contains code, adapted from Numerical Recipes, for computing cubic spline
# interpolation

# The spline type: n is the number of grid points, x is the set of grid points,
# y is the set of values of the function on the grid points, and ydp is the set of 
# of second derivatives on the grid points, constructed as part of the cubic spline.

struct spline
   n::Int64
   x::Array{Float64}
   y::Array{Float64}
   ydp::Array{Float64}
end   

# Create an equally-spaced grid of points between xlow and xhigh.
function creategrid(xlow,xhigh,npts)

   xinc = (xhigh - xlow)/(npts-1)
   
   return collect(xlow:xinc:xhigh)
   
end   

# Function for solving a set of tridiagonal linear equations, with coefficents a, b, c, and r
# as outlined in lecture notes from March 17.
function tridag(a,b,c,r)

   toler = 1.0e-12
      
   n = length(a)
   u = zeros(n)
   gam = zeros(n)

   bet = b[1]
   u[1] = r[1]/bet
   for j in 2:n
      gam[j] = c[j-1]/bet
      bet = b[j] - a[j]*gam[j]
      if (abs(bet) <= toler)
         error("Failure in subroutine tridag.")
      end
      u[j] = (r[j]-a[j]*u[j-1])/bet
   end
   for j in n-1:-1:1
      u[j] = u[j] - gam[j+1]*u[j+1]
   end
   
   return u

end 

# Function to create a cubic spline.  fpts is the set of grid points and flevel is the 
# set of values of the function on the grid points.  makespline returns an object of type 
# spline.
function makespline(fpts,flevel)

   zero = 0.0
   one = 1.0
   
   npts = length(fpts)
   a = zeros(npts)
   b = zeros(npts)
   c = zeros(npts)
   r = zeros(npts)

   an = -one
   c1 = -one

   a[1] = zero
   a[npts] = an
   b[1] = one
   b[npts] = one
   c[1] = c1
   c[npts] = zero
   r[1] = zero
   r[npts] = zero

   for i in 2:npts-1
      a[i] = (fpts[i]-fpts[i-1])/6
      b[i] = (fpts[i+1]-fpts[i-1])/3
      c[i] = (fpts[i+1]-fpts[i])/6
      r[i] = (flevel[i+1]-flevel[i])/(fpts[i+1]-fpts[i]) - 
             (flevel[i]-flevel[i-1])/(fpts[i]-fpts[i-1])
   end

   vdp = tridag(a,b,c,r)
   
   return spline(npts,fpts,flevel,vdp)
   
end

# Calculate interpolated values at x using the cubic spline embodied in yspline (of type spline).
# calcy, calcyp, and calcydp are optional arguments; if calcy = true then the level (y) at x is 
# is computed; if calcyp = true then the first derivative (yp) at x is computed; if calcydp = true
# then second derivative (ydp) at x is computed.  interp returns the type of real numbers 
# (y,yp,ydp).
function interp(x,yspline;calcy=true,calcyp=false,calcydp=false)

   one = 1.0
   
   npts = yspline.n

   klo = 1
   khi = npts
   while ((khi-klo) > 1)
      k = Int(trunc((khi+klo)/2))
      if (yspline.x[k] > x)
         khi = k
      else
         klo = k
      end
   end
   
   h = yspline.x[khi] - yspline.x[klo]
   a = (yspline.x[khi] - x)/h
   b = (x - yspline.x[klo])/h
   asq = a*a
   bsq = b*b

   if calcy
      y = a*yspline.y[klo] + b*yspline.y[khi] + 
          ((asq*a-a)*yspline.ydp[klo] 
           +(bsq*b-b)*yspline.ydp[khi])*(h*h)/6
   else
      y = 0.0
   end           

   if calcyp
      yp = (yspline.y[khi]-yspline.y[klo])/h - 
           (3*asq-one)/6*h*yspline.ydp[klo] + 
           (3*bsq-one)/6*h*yspline.ydp[khi]
   else
      yp = 0.0
   end           

   if calcydp
      ydp = a*yspline.ydp[klo] + b*yspline.ydp[khi]
   else
      ydp = 0.0
   end
   
   interp = (y,yp,ydp)      
      
end 


# The rest of the code illustrates how to compute a cubic spline and how to calculate
# interpolated values using it.  The example function f(x) is log(x).  fp(x) is the first 
# derivative of f at x and fdp(x) is the second derivative of f at x.  When 
# including spline1.jl in another program, you should delete all the code below.

# function f(x)
#    return log(x)
# end   

# function fp(x)
#    return 1.0/x
# end   

# function fdp(x)
#    return -1.0/(x*x)
# end   
  
# nx = 10  
# a = 1.0
# b = 3.0

# # Create the grid.
# x = creategrid(a,b,nx)
# # Calculate the function values on the grid.
# y = f.(x)
# # Compute the cubic spline using x and y.
# yspline = makespline(x,y)

# # Set of a fine grid and calculate interpolated values and actual (correct) values on this grid,
# # diff is the difference between the interpolated and correct values.
# nxfine = 200
# xfine = creategrid(a,b,nxfine)
# ysplinefine = broadcast(x->interp(x,yspline)[1],xfine)
# yfine = f.(xfine)
# diff = ysplinefine - yfine
