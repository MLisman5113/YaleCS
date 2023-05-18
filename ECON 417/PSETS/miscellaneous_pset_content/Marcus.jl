
# creates a grid with N points on the interval from xmin to xmax
function createGrid(x_min, x_max, N)
    step = (x_max-x_min) / (N-1)
    return collect(x_min:step:x_max)
end

function F(k)
    return k^0.4 + 0.9k
end

# returns (discrete) value and policy functions on grid defined by the vector a
function valueFuncIter(U, a, F; beta=0.9, v0=zeros(length(a)), toler=1e-6, maxiter=1000, verbose=1)
    N = length(a)
    g = fill(0, N) # g[i] will be j<=i that maximizes U(a_i-a_j) + βv_j (this is the optimal decision rule/policy function)
    # Songyuan
    U_ar = [U(F(a[i])-a[j]) for i in 1:N, j in 1:N] # NxN array of all possible values of U, given grid a
    # Songyuan
    err = 1+toler; niter = 0;
    
    while err > toler && niter < maxiter
        niter += 1
        v1 = copy(v0)

        # define new value function by iterating over all grid points
        for i in 1:N
            # Songyuan
            rhs = U_ar[i,:] .+ beta*v0 # RHS of Bellman equation (for all a_j<=a_i)
            # Songyuan
            v1[i], g[i] = findmax(rhs) # simultaneously update value function and get the optimizing j (for given i)
        end
        
        err = maximum(abs.(v1-v0)) 
        v0 = v1
    end

    if err <= toler && verbose >= 1
        println("Value function iteration converged in $niter iterations (maxerr = $err)")
    elseif err > toler
        println("Value function iteration failed to converge in $niter iterations (maxerr = $err)")
    end

    return v0, g
end

# returns the indices (in a) corresponding to the optimal path of savings, when a0 = a[idx0]
function getPath(g, idx0, T)
    idxs = fill(idx0, T) # optimal path of cake stock (expressed as an index of a)
    for t in 2:T
        idxs[t] = g[idxs[t-1]]
    end
    return idxs
end

# the consumer's felicity function
function U(c)
    # we don't allow negative consumption, even if c > -ϵ
    if c < 0
        return -Inf
    else
        return log(c)
    end
end

function lifetime_utility(consumption, T, beta)
    value = 0
    for t in 1:T-1
        if consumption[t] == -Inf
            continue
        end
        # Songyuan
        value = value + ((beta^(t-1))*log(consumption[t]))
        # Songyuan
    end
    return value
end


## 1a #########################

N = 31 # number of grid points
# Songyuan
k_ss = ((1/0.9-(1-0.1))/0.4)^(1/(0.4-1))
a = createGrid(0.5*k_ss, 1.5*k_ss, N)
# Songyuan
println(a)
vsol, g = valueFuncIter(U, a, F)
println(vsol, g)

## 1b #######################

T = 1000
a_t = a[getPath(g, 1, T)] # path of stock
# Songyuan
c_t = F.(a_t[1:(T-1)]) .- a_t[2:T] # path of consumption
# Songyuan

# Calculating lifetime utility using the function I wrote called lifetime_utility
beta = 0.9
utility = lifetime_utility(c_t, T, beta)
println(utility)