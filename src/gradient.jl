# Backward pass
function backward!(root::ReverseNode)
    stack = [root]
    while !isempty(stack)
        node = pop!(stack)
        @inbounds for (child, local_grad) in node.children
            child.grad[1] += local_grad(node.grad[1])
            push!(stack, child)
        end
    end
end

function grad(f, input_values::Vector)
    nodes = [ReverseNode(x) for x in input_values]

    output = f(nodes...)
    output.grad[1] = seed(output.value)

    backward!(output)

    return [n.grad[1] for n in nodes]
end

seed(x) = x isa Number ? one(x) : ones(size(x))
