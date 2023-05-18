# print
a=1
typeof(a)
print(a)
# print(a,"\n")

# println
x = "I love Econ 417";
println(x) # move the cursor to a new line
println("x")
println("$x")

# printstyled
for color in [:red, :cyan, :blue, :magenta]
    printstyled("Hello World $(color)\n"; color = color)
end

# printfmtln 
using Formatting
a=4
b=1
c=7
printfmtln("Course Econ {1:n} {2:n} {3:n}", a, b, c) 
printfmtln("Course Econ {1:.5f} {2:.1f} {3:.1f}", a, b, c)

