
Plot{Plots.GRBackend() n=1}
f(x) = exp(x)-1
plot!(x,f.(x)) Plot{Plots.GRBackend() n=2}
plot!(x,f.(x)+x)
funciter(f, -1; verbose = 2)
funciter(f,1;verbose = 2)
bisect(f,-1.5,2; verbose=2)