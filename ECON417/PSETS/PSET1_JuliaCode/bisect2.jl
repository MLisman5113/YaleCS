include("io2.jl")
import Pkg
Pkg.add("BenchmarkTools")

# sets the function established in the problem set specification
function f(x)
   f = ((1x^(-1)) - (exp(0.1x) - 1))
end

function g(x)
   g = (1x^(-1))
end

# this function performs the bisection method of calculating the numerical derivative
function bisect(f,xlow,xhigh;toler=1.0e-6,mxiter=30)

   fxlow = f(xlow)
   fxhigh = f(xhigh)
   
   if (fxlow*fxhigh > 0) 
      wait("Root not bracketed.")
   elseif (xlow > xhigh) 
      wait("Brackets out of order.")   
   else
   
      diff = xhigh - xlow
   
      downwardsloping = (fxlow > 0)
      
      niter = 0
      
      while (niter < mxiter)
      
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
          
        diff = abs(xhigh-xlow)  
        
        writeio(stdout,(4,(5,15.8)),niter,xlow,xhigh,xcur,fxcur,diff,callwait=false)        
        
        if (diff < toler) 
           break
        end   
        
     end

     if (diff > toler)
        writeio(stdout,("Did not converge: ",(3,15.8)),xlow,xhigh,diff,callwait=true)             
     end
     
  end

  xroot = (xlow + xhigh)/2
  fxroot = f(xroot)
  
  bisect = xroot,fxroot,xlow,xhigh
   
end  

# outputs the result of the bisection method
xlow = 0.0
xhigh = 5.0
xroot,fxroot,xlow2,xhigh2 = bisect(x -> f(x),xlow,xhigh,toler=1.0e-6,mxiter=30);
writeio(stdout,("xroot,f(xroot),xlow2,xhigh2: ",(4,15.8)),xroot,g(xroot),xlow2,xhigh2)

# checks the computational speed in terms of iterations and runtime using the benchmark tools
using BenchmarkTools
print(@benchmark bisect(x -> f(x),xlow,xhigh,toler=1.0e-6,mxiter=30))    
                 
      
      
         
   

   
