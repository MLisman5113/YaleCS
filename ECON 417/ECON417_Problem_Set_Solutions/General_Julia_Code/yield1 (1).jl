# This code uses Monte Carlo simulation to estimate the probability distribution over the 
# number of accepted offers when n offers are extended.  The code asks the user to 
# input both n, the number of offers, and the probabilities of acceptance associated with
# each offer.

include("io2.jl")
include("random1.jl")
include("creategrid1.jl")

function dosim(seed,nsim,p,n,nwrite)
# seed is the seed for the pseudo random number generator.
# nsim is the number of Monte Carlo simulations to perform.
# p is the nx1 vector of acceptance probabilities.
# n is the number of offers.
# nwrite controls how often the results of a particular simulation are written
# to the screen.

# Initialize the frequency distribution.
   hist = zeros(n+1)
   
   outcomes = trunc.(Int64,creategrid(0,n,n+1))
   writeio(stdout,("Simulation #","   No.",10),outcomes)
   
   for i in 1:nsim
   
# Generate n uniformly distributed random number.
      r,seed = randomuniform(seed,n)
      
# Add up how many offers are accepted.
      naccept = sum(r.<p)
      
# Update the frequency distribution.      
      hist[naccept+1] += 1
      writeio(stdout,(12,6,10.0),i,naccept,hist,write=multpl(i,nwrite))
   end

# Return the frequency distribution over accepted offers, as well as the updated seed.   
   return (hist/nsim,seed)
   
end   

writeio(stdout,("Enter number of offers: ",),cr=false)
n = readio(stdin,1)
writeio(stdout,("Enter ",length(string(n))," probabilities: "),n,cr=false)
p = readio(stdin,("r"*string(n),))
writearrays(stdout,(5,10.2),p)

wait()

nsim = 1000000
nwrite = 50000
seed = 235453.0

(hist,seed) = dosim(seed,nsim,p,n,nwrite)

writeio(stdout,("Probability distribution over number of acceptances:",))
writearrays(stdout,(5,10.6),collect(0:1:n),hist,writeindex=false)
writeio(stdout,("            Sum of frequencies:",10.6),sum(hist))
writeio(stdout,(" Average number of acceptances:",10.6),sum(hist.*collect(0:1:n)))
writeio(stdout,("Expected number of acceptances:",10.6,10.2),sum(p),p)
writeio(stdout,("seed = ",25.1),seed)





