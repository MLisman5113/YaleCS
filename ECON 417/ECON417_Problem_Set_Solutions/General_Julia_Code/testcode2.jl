# This code illustrates the use of "for loops" and arrays.  It also shows how to write and read
# data from external files.  Finally, it illustrates uses of the functions writeio and readio 
# contained in io2.jl.


include("io2.jl")

n = 5
x = zeros(n)

for i in eachindex(x)

   if (i == 1)
      x[1] = 1 
   else   
      x[i] = x[i-1] + 1 
   end
   
end

writeio(stdout,((5,15.8),),x[1],x[2],x[3],x[4],x[5])
writeio(stdout,15.8,x)

wait()

io = open("testcode2.dat","w")
writeio(io,15.8,x)
close(io)

wait()

io = open("testcode2.dat","r")
r1,r2,r3,r4,r5 = readio(io,5)
close(io)

writeio(stdout,((5,15.8),),r1,r2,r3,r4,r5)

wait()

io = open("testcode2.dat","r")
r = readio(io,5)
close(io)

println(typeof(r))

writeio(stdout,((5,15.8),),r[1],r[2],r[3],r[4],r[5])

wait()

io = open("testcode2.dat","r")
y = readio(io,("r5",))
close(io)

writeio(stdout,15.8,y)





   
   




