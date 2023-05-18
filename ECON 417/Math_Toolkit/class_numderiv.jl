using Formatting

include("io2.jl")

function numderiv(f,x;delta=1.0e-6)

   h = delta*x

   deriv = (f(x+h) - f(x))/h

   return deriv

end

function f(x)

   f = exp(x)

end

deriv = numderiv(f,1)
println("deriv = ",deriv)
printfmtln("deriv = {1:12.8f}",deriv)
writeio(stdout,("deriv = ",12.8),deriv)

wait()

delta = 1.0e-8

deriv = numderiv(f,1,delta=1.0e-8)
println("deriv = ",deriv," e = ",delta)
printfmtln("deriv = {1:12.8f}, e = {2:15.12f}",deriv,delta)
writeio(stdout,("deriv = ",12.8,", e = ",15.12),deriv,delta)

wait()

function doderiv(x)

   docalc = true
   
   expx = exp(x)

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

doderiv(1)
   






