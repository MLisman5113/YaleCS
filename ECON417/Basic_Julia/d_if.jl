x=5
y=0

if x == y
    println("x = $x is equal to y = $y")
elseif x != y
# else
    println("x = $x is not equal to y = $y")
end

if x < y
    println("x = $x is less than y = $y")
elseif x > y
    println("x = $x is greater than y = $y")
else
    println("x = $x is equal to y = $y")
end

if x > 0 &&  y > 0
    println("x = $x and y = $y are both positive")
end

if x > 0 ||  y > 0
    println("x = $x and y = $y, at least one of them is positive")
end