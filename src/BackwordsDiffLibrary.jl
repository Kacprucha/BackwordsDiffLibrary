module BackwordsDiffLibrary

include("dataTyp.jl")
include("overloadMethods.jl")
include("gradient.jl")

export ReverseNode, lift, @diffunction
export grad

end
