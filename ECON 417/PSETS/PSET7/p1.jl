include("gauher1.jl")

####     N = 2    ############################

println("####     N = 2    ############################");
println("")

n2=[1,2]
sigma=1
mu=1
Nn = length(n2)
Nsigma = length(sigma)
result2=zeros(Nn, Nsigma)
m(x) = exp(x)

for i_n=1:Nn
    w, x = gauher(n2[i_n])
    for i_sigma=1:Nsigma
        for i=1:n2[i_n]
            result2[i_n,i_sigma] += w[i] * m(sigma[i_sigma]*x[i]*sqrt(2) + mu)
        end
        result2[i_n,i_sigma] = result2[i_n, i_sigma]/sqrt(pi)
    end
end

println("Result:  ", result2)

accurate = exp(mu+sigma^2/2)

println("Difference:   ", abs(last(result2) - accurate))

println("")

####     N = 10    ############################

println("####     N = 10   ############################")
println("")

n10=[1,2,3,4,5,6,7,8,9,10]
sigma=1
mu=1
Nn = length(n10)
Nsigma = length(sigma)
result10=zeros(Nn, Nsigma)
m(x) = exp(x)

for i_n=1:Nn
    w, x = gauher(n10[i_n])
    for i_sigma=1:Nsigma
        for i=1:n10[i_n]
            result10[i_n,i_sigma] += w[i] * m(sigma[i_sigma]*x[i]*sqrt(2) + mu)
        end
        result10[i_n,i_sigma] = result10[i_n, i_sigma]/sqrt(pi)
    end
end

println("Result:   ", result10)

accurate = exp(mu+sigma^2/2)

println("Difference:   ", abs(last(result10) - accurate))



#################################################################

# n=[1,2,3,4,5,6,7,8,9,10]
# sigma=[1,2,3]
# Nsigma=length(sigma)
# Nn=length(n)
# result=zeros(Nn,Nsigma)
# mu=1
# accurate=zeros(Nsigma)