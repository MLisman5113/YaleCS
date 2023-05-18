using Formatting

include("io2.jl")

# calculates the one-sided numerical derivative using the definition of the derivative
function numderiv(f,x;delta=1.0e-6)

   h = delta*x

   deriv = (f(x+h) - f(x))/h

   return deriv

end

# function established in the problem specification
function f(x)

   f = 0.5x^-.5 + 0.5x^-.2

end

deriv = numderiv(f,1.5)
println("deriv = ",deriv)
printfmtln("deriv = {1:12.8f}",deriv)
writeio(stdout,("deriv = ",12.8),deriv)

wait()

delta = 1.0e-8

deriv = numderiv(f,1.5,delta=1.0e-8)
println("deriv = ",deriv," e = ",delta)
printfmtln("deriv = {1:12.8f}, e = {2:15.12f}",deriv,delta)
writeio(stdout,("deriv = ",12.8,", e = ",15.12),deriv,delta)

wait()

# keeps taking in deltas to calculate the derivatives based on those different deltas and then outputs them
function doderiv(x)

   docalc = true
   
   expx = -0.1975566242534 # normal calculator derivative

   while docalc

      writeio(stdout,("Enter delta: ",),cr=false)
      delta = readio(stdin,1)
      docalc = delta > 0
      if docalc
         deriv = numderiv(f,x,delta=delta)
         writeio(stdout,("delta = ",15.12,(3,18.12)),delta,deriv,expx,expx-deriv)
      end   
      
   end   
   
end 

# get the output for x = 1.5, the value specified in the problem instructions
doderiv(1.5)
   






