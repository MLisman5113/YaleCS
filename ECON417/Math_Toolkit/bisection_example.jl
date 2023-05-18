include("f_eg_bisection.jl")

x=-2:0.001:2
plot([-2,2],[0,0])

# 1: single root + continuous + f(a)f(b)<0
f(x)=x+1
plot!(x,f.(x))
bisect(f,-2,1;verbose=2)

# 2: single root + continuous + f(a)f(b)>0
f(x)=x+1
plot!(x,f.(x))
bisect(f,-0.5,1;verbose=2)

# 3: multiple root + continuous + f(a)f(b)<0
f(x)=(x+1)*(x-0)*(x-0.8)
plot!(x,f.(x))
bisect(f,-2,1;verbose=2)
bisect(f,-1.1,2;verbose=2)
# So, if there are multiple roots, bisection gives one root depending on the bound 

# 4: single root + noncontinuous + f(a)f(b)<0
function f(x)
    if x>0 && x<0.5
        return x+1
    else
        return x-1
    end
end
plot!(x,f.(x))
bisect(f,-1.5,2;verbose=2)


