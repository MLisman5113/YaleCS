#Examples of how to use writeio and readio.

include("io2.jl")

n = 1
x = 1.0

#The first argument of writeio indicates where the output should be written.
#stdout means to write to the screen.

#The second argument of writeio is a tuple represeting the format for the output.

#The remaining arguments are variables to be written.  The number of variables must match
#the number of elements in the tuple representing the format.

#The format for an integer is an integer representing the number of required spaces for 
#the number to be written.

writeio(stdout,5,n)

#Strings can be added to the format tuple.

writeio(stdout,("n = ",5),n)

#The format for an integer is a real number: the integer to the left of the decimal point is
#is the number of required spaces for the real number, including the decimal point; and the integer
#to the right of the decimal point is the number decimal places to be written.

writeio(stdout,15.8,x)
writeio(stdout,("x = ",15.8),x)

writeio(stdout,(5,15.8),n,x)

writeio(stdout,("n = ",5,", x = ",15.8),n,x)

writeio(stdout,("n,x: ",5,15.8),n,x)


#The first argument of readio is the location of the data to be read; 
#stdin means to read from the screen.

#The second argument of readio is the number of numbers to be read; they can be in any format.

writeio(stdout,("Enter n: ",),cr=false)
n = readio(stdin,1)
writeio(stdout,("n = ",5),n)

writeio(stdout,("Enter x: ",),cr=false)
x = readio(stdin,1)
writeio(stdout,("n = ",15.8),x)

writeio(stdout,("Enter n,x: ",),cr=false)
n,x = readio(stdin,2)
writeio(stdout,("n,x: ",5,15.8),n,x)


x1 = 1.0
x2 = 2.0

#If several numbers will be written in the same format, then the format tuple can include 
#itself a 2-tuple, the first element of which is the number of numbers with the same format and
#the second element of which is the format in which the numbers should be written.

writeio(stdout,((2,15.8),),x1,x2)

writeio(stdout,(5,(2,15.8)),n,x1,x2)







 






