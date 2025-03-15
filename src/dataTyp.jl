struct ReverseNode
    value::Float64
    grad::Array{Float64}
    children::Vector{Tuple{ReverseNode, Function}}
end

ReverseNode(x::Float64) = ReverseNode(x, [0.0], Tuple{ReverseNode, Function}[])

lift(x::Float64) = ReverseNode(x)