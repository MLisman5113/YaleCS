

## Question 2: Brent's method

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

function df(x)
   return 1/x - 1
end

function f(x)
   return log(x) - x
end


# Question 2: Newton-Raphson Method

function newton_raphson2(f, g, x0, error, numiter)
   x0 = x0
   x1 = 0
   iter = 0
   while iter < numiter
      if g(x0) == 0
         println("Solution found")
         println(x0)
         break
      end
      x1 = x0 - f(x0)/g(x0)
      if abs(f(x1)) > error
         x0 = x1
      end
      iter = iter + 1
   end
end


println("Answer for minimum using Brent's Method:")
zbrent(df,0.75,1.2,1e-6, 1e-6)

println("Answer for minimum using the Newton-Raphson Method:")
newton_raphson2(f, df, 1, 0.00001, 100)
