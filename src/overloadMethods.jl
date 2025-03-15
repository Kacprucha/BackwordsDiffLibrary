import Base: +, -, *, /, sin, cos, tan, cot, sec, csc, exp, log, ^

# Addition: z = a + b  =>  dz/da = 1, dz/db = 1
+(a::ReverseNode, b::ReverseNode) = begin
    out = ReverseNode(a.value + b.value)
    push!(out.children, (a, δ -> δ * 1.0))
    push!(out.children, (b, δ -> δ * 1.0))
    out
end

# Subtraction: z = a - b  =>  dz/da = 1, dz/db = -1
-(a::ReverseNode, b::ReverseNode) = begin
    out = ReverseNode(a.value - b.value)
    push!(out.children, (a, δ -> δ * 1.0))
    push!(out.children, (b, δ -> δ * -1.0))
    out
end

# Multiplication: z = a * b  =>  dz/da = b, dz/db = a
*(a::ReverseNode, b::ReverseNode) = begin
    out = ReverseNode(a.value * b.value)
    push!(out.children, (a, δ -> δ * b.value))
    push!(out.children, (b, δ -> δ * a.value))
    out
end

# Division: z = a / b  =>  dz/da = 1/b, dz/db = -a/(b^2)
/(a::ReverseNode, b::ReverseNode) = begin
    out = ReverseNode(a.value / b.value)
    push!(out.children, (a, δ -> δ * (1 / b.value)))
    push!(out.children, (b, δ -> δ * (-a.value / (b.value^2))))
    out
end

# sin: z = sin(a)  =>  dz/da = cos(a)
sin(a::ReverseNode) = begin
    out = ReverseNode(sin(a.value))
    push!(out.children, (a, δ -> δ * cos(a.value)))
    out
end

# cos: z = cos(a)  =>  dz/da = -sin(a)
cos(a::ReverseNode) = begin
    out = ReverseNode(cos(a.value))
    push!(out.children, (a, δ -> δ * -sin(a.value)))
    out
end

# tan: z = tan(a)  =>  dz/da = sec(a)^2
tan(a::ReverseNode) = begin
    out = ReverseNode(tan(a.value))
    push!(out.children, (a, δ -> δ * sec(a.value)^2))
    out
end

# cot: z = cot(a)  =>  dz/da = -csc(a)^2
cot(a::ReverseNode) = begin
    out = ReverseNode(cot(a.value))
    push!(out.children, (a, δ -> δ * -csc(a.value)^2))
    out
end

# sec: z = sec(a)  =>  dz/da = sec(a)tan(a)
sec(a::ReverseNode) = begin
    out = ReverseNode(sec(a.value))
    push!(out.children, (a, δ -> δ * sec(a.value)tan(a.value)))
    out
end

# csc: z = csc(a)  =>  dz/da = -csc(a)cot(a)
csc(a::ReverseNode) = begin
    out = ReverseNode(csc(a.value))
    push!(out.children, (a, δ -> δ * -csc(a.value)cot(a.value)))
    out
end

# log: z = log(a)  =>  dz/da = 1/a
log(a::ReverseNode) = begin
    out = ReverseNode(log(a.value))
    push!(out.children, (a, δ -> δ * 1/a.value))
    out
end

# ^: z = a^b  =>  dz/da = b*a^(b-1), dz/db = a^b*log(a)
^(a::ReverseNode, b::ReverseNode) = begin
    out = ReverseNode(a.value ^ b.value)
    push!(out.children, (a, δ -> δ * b.value * a.value^(b.value - 1)))
    push!(out.children, (b, δ -> δ * a.value^b.value * log(Complex(a.value))))
    out
end

# exp: z = exp(a)  =>  dz/da = exp(a)
exp(a::ReverseNode) = begin
    out = ReverseNode(exp(a.value))
    push!(out.children, (a, δ -> δ * exp(a.value)))
    out
end