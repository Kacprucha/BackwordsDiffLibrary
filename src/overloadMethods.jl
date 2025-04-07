import Base: +, -, *, /, sin, cos, tan, cot, sec, csc, exp, log, ^
import Statistics: mean

# Addition: z = a + b  =>  dz/da = 1, dz/db = 1
+(a::ReverseNode, b::ReverseNode) = begin
    out = ReverseNode(a.value + b.value)
    push!(out.children, (a, δ -> δ))
    push!(out.children, (b, δ -> δ))
    out
end

# Subtraction: z = a - b  =>  dz/da = 1, dz/db = -1
-(a::ReverseNode, b::ReverseNode) = begin
    out = ReverseNode(a.value - b.value)
    push!(out.children, (a, δ -> δ))
    push!(out.children, (b, δ -> δ * -1.0))
    out
end

# Multiplication: z = a * b  =>  dz/da = b, dz/db = a
*(a::ReverseNode{T}, b::ReverseNode{T}) where {T<:Number} = begin
    out = ReverseNode(a.value * b.value)
    push!(out.children, (a, δ -> δ * b.value))
    push!(out.children, (b, δ -> δ * a.value))
    out
end

# Matrix multiplication: z = a * b  =>  dz/da = b', dz/db = a'
*(a::ReverseNode{T1}, b::ReverseNode{T2}) where {T1<:AbstractArray, T2<:AbstractArray} = begin
    out = ReverseNode(a.value * b.value)
    push!(out.children, (a, δ -> (ndims(δ)==1 ? reshape(δ, :, 1) : δ) * transpose(b.value)))
    push!(out.children, (b, δ -> vec(transpose(a.value) * (ndims(δ)==1 ? reshape(δ, :, 1) : δ))))
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
sin(a::ReverseNode{T}) where {T<:Number} = begin
    out = ReverseNode(sin(a.value))
    push!(out.children, (a, δ -> δ * cos(a.value)))
    out
end

sin(a::ReverseNode{T}) where {T<:AbstractArray} = begin
    out = ReverseNode(sin.(a.value))
    push!(out.children, (a, δ -> δ .* cos.(a.value)))
    out
end

# cos: z = cos(a)  =>  dz/da = -sin(a)
cos(a::ReverseNode{T}) where {T<:Number} = begin
    out = ReverseNode(cos(a.value))
    push!(out.children, (a, δ -> δ * -sin(a.value)))
    out
end

cos(a::ReverseNode{T}) where {T<:AbstractArray} = begin
    out = ReverseNode(cos.(a.value))
    push!(out.children, (a, δ -> δ .* -sin.(a.value)))
    out
end

# tan: z = tan(a)  =>  dz/da = sec(a)^2
tan(a::ReverseNode{T}) where {T<:Number} = begin
    out = ReverseNode(tan(a.value))
    push!(out.children, (a, δ -> δ * sec(a.value)^2))

    out
end

tan(a::ReverseNode{T}) where {T<:AbstractArray} = begin
    out = ReverseNode(tan.(a.value))
    push!(out.children, (a, δ -> δ .* sec.(a.value).^2))
    out
end

# cot: z = cot(a)  =>  dz/da = -csc(a)^2
cot(a::ReverseNode{T}) where{T<:Number} = begin
    out = ReverseNode(cot(a.value))
    push!(out.children, (a, δ -> δ * -csc(a.value)^2))
    out
end

cot(a::ReverseNode{T}) where{T<:AbstractArray} = begin
    out = ReverseNode(cot.(a.value))
    push!(out.children, (a, δ -> δ .* -csc.(a.value).^2))
    out
end

# sec: z = sec(a)  =>  dz/da = sec(a)tan(a)
sec(a::ReverseNode{T}) where{T<:Number} = begin
    out = ReverseNode(sec(a.value))
    push!(out.children, (a, δ -> δ * sec(a.value)tan(a.value)))
    out
end

sec(a::ReverseNode{T}) where{T<:AbstractArray} = begin
    out = ReverseNode(sec.(a.value))
    push!(out.children, (a, δ -> δ .* sec.(a.value)tan.(a.value)))
    out
end

# csc: z = csc(a)  =>  dz/da = -csc(a)cot(a)
csc(a::ReverseNode{T}) where {T<:Number} = begin
    out = ReverseNode(csc(a.value))
    push!(out.children, (a, δ -> δ * -csc(a.value)cot(a.value)))
    out
end

csc(a::ReverseNode{T}) where {T<:AbstractArray} = begin
    out = ReverseNode(csc.(a.value))
    push!(out.children, (a, δ -> δ .* -csc.(a.value)cot.(a.value)))
    out
end

# log: z = log(a)  =>  dz/da = 1/a
log(a::ReverseNode{T}) where {T<:Number} = begin
    out = ReverseNode(log(a.value))
    push!(out.children, (a, δ -> δ /a.value))
    out
end

log(a::ReverseNode{T}) where {T<:AbstractArray} = begin
    out = ReverseNode(log.(a.value))
    push!(out.children, (a, δ -> δ ./ a.value))
    out
end

# ^: z = a^b  =>  dz/da = b*a^(b-1), dz/db = a^b*log(a)
^(a::ReverseNode{T}, b::ReverseNode{T}) where {T<:Number} = begin
    out = ReverseNode(a.value ^ b.value)
    push!(out.children, (a, δ -> δ * b.value * a.value^(b.value - 1)))
    push!(out.children, (b, δ -> δ * out.value * log(Complex(a.value))))
    out
end

^(a::ReverseNode{T1}, b::ReverseNode{T2}) where {T1<:AbstractArray, T2<:AbstractArray} = begin
    out = ReverseNode(a.value .^ b.value)
    push!(out.children, (a, δ -> δ .* b.value .* a.value.^(b.value - 1)))
    push!(out.children, (b, δ -> δ .* out.value .* log.(a.value)))
    out
end

# Overload power for a matrix base and a scalar exponent.
^(a::ReverseNode{Matrix{Float64}}, b::ReverseNode{Float64}) = begin
    out_val = a.value .^ b.value
    out = lift(out_val)
    push!(out.children, (a, δ -> δ .* (b.value .* (a.value .^ (b.value - 1)))))
    push!(out.children, (b, δ -> sum(δ .* (out.value .* log.(max.(a.value, eps()))))))
    out
end


# exp: z = exp(a)  =>  dz/da = exp(a)
exp(a::ReverseNode{T}) where{T<:Number} = begin
    out = ReverseNode(exp(a.value))
    push!(out.children, (a, δ -> δ * exp(a.value)))
    out
end

exp(a::ReverseNode{T}) where{T<:AbstractArray} = begin
    out = ReverseNode(exp.(a.value))
    push!(out.children, (a, δ -> δ .* exp.(a.value)))
    out
end

mean(a::ReverseNode) = begin
    out_val = mean(a.value)
    out = lift(out_val)
    n = length(a.value)
    push!(out.children, (a, δ -> fill(δ / n, size(a.value))))
    out
end