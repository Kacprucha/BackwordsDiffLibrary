# BackwordsDiffLibrary

## Overview

BackwordsDiffLibrary is a Julia library that provides backwords differentiation. It is designed to efficiently compute gradients for functions.

## Features

- **Reverse-Mode Differentiation**: Compute gradients efficiently for functions with many inputs.
- **Performance**: Optimized for speed and low memory usage.
- **Flexibility**: Suitable for both simple functions and complex models.

## Installation

Ensure you have Julia installed (version 1.11.3). Install Julia's package manager. In the Julia REPL, run:

```julia
using Pkg
Pkg.add("BackwordsDiffLibrary")
```

## Usage

Import the library in your Julia script:

```julia
using BackwordsDiffLibrary
```

Define your function using ```ReverseNode``` structure to define parameters and numberic elements in function. You can use ```lift``` funcion to crate ```ReverseNode``` element form the number. Hear is example of the function:

```julia
# Example function: f(x) = 2x + cos(xy + 0.5x)^2
function f(x::ReverseNode, y::ReverseNode)
    # We can "lift" constants as ReverseNode too.
    two = lift(2.0)
    half = lift(0.5)
    return two*x + cos(x*y + half*x)^two
end
```

After defining the function we can use ```grad``` function that takes as first argument function that gradient we want to calculate and as second a point in witch we want to calculate it. The point is stored as a Vector. Hear is an example of using it:

```julia
# Compute gradient at (x = 2.0, y = 5.0)
input_vals = [2.0, 5.0]
computed_gradient = grad(f, input_vals)
```

## Examples

You can see examples of uing this function in notebooks in examples folder.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
